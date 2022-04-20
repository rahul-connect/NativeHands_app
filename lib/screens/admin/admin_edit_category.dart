import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../../model/user.dart';
import 'admin_drawer.dart';

class AdminEditCategory extends StatefulWidget {
  final User user;
  AdminEditCategory({this.user});
 

  @override
  _AdminEditCategoryState createState() => _AdminEditCategoryState();
}

class _AdminEditCategoryState extends State<AdminEditCategory> {
  Firestore _firestore = Firestore.instance;
   bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AdminDrawer(
        user: widget.user,
      ),
      appBar: AppBar(
        title: Text("Edit Categories"),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: _firestore.collection('category').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, index) {
                  var item = snapshot.data.documents[index];
                  return ListTile(
                    title: Text(item['title']),
                    trailing: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Delete ${item['title']}'),
                                content: const Text(
                                    'Are you sure you want to delete category and all its products ?'),
                                actions:<Widget>[
                                  FlatButton(
                                    child: const Text(
                                      'CANCEL',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                
                                  loading?FlatButton(onPressed: null, child: CircularProgressIndicator()):  SizedBox(
                                    width: 20.0,
                                  ),
                                  FlatButton(
                                    child: const Text('YES'),
                                    onPressed: () async {
                                      setState(() {
                                        loading = true;
                                      });
                                      var allProducts = await _firestore
                                          .collection('products')
                                          .where('category',
                                              isEqualTo: item.documentID)
                                          .getDocuments();
                                      allProducts.documents.forEach((product) async{
                                        for (var image
                                            in product.data["images"]) {
                                          FirebaseStorage.instance
                                              .getReferenceFromUrl(image)
                                              .then((res) {
                                            res.delete().then((res) {
                                              print("Deleted!");
                                            });
                                          });
                                        }

                                       await  _firestore.collection('products').document(product.documentID).delete();
                                      });
                                      await _firestore.collection('category').document(item.documentID).delete();
                                       setState(() {
                                        loading = false;
                                      });

                                      Navigator.pop(context);
                                      
                                    },
                                  )
                                ],
                              );
                            },
                          );
                        }),
                    subtitle: FutureBuilder(
                        future: _firestore
                            .collection('products')
                            .where('category', isEqualTo: item.documentID)
                            .getDocuments(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var count = snapshot.data.documents.length;
                            return Text('Total Products : $count');
                          }
                          return LinearProgressIndicator();
                        }),
                  );
                },
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
