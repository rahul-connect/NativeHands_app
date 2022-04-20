import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'edit_category.dart';

class AllCategories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 
     Scaffold(
       appBar: AppBar(
         title:Text("All Categories")
       ),
            body: StreamBuilder(
            stream: Firestore.instance.collection('category').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snapshot.data.documents[index]['title']),
                        trailing: InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>EditCategoryScreen(title:snapshot.data.documents[index]['title'],categoryId: snapshot.data.documents[index].documentID,)));
                          },
                          child: Icon(Icons.edit,color: Colors.teal,)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 30,vertical: 10.0),
                      );
                    });
              }
              return CircularProgressIndicator();
            }),
     )
    ;
  }
}
