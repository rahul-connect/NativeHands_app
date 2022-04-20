import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProductScreen extends StatefulWidget {
  final String productId;
  EditProductScreen({@required this.productId});
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _firestore = Firestore.instance;
  String prodTitle;
  String prodDescription;
  String prodPrice;
  bool loading=true;
  List<DropdownMenuItem> allCategories = [];
  String selectedCategory="";
  bool isAvailable;

  @override
  void initState() {
    fetchCategories();
    fetchProduct();
    super.initState();
  }

  Future<void> fetchCategories() async{
    var categories = await Firestore.instance.collection('category').getDocuments();
    var productCategory = await Firestore.instance.collection('products').document(widget.productId).get();
    var index = 0;
     for (var category in categories.documents) {
      allCategories.add(DropdownMenuItem(value: category.documentID, child: Text(category['title'])));
      if(category.documentID==productCategory.data['category']){
          index = allCategories.length-1;
      }
   }
  
   if(allCategories.length > 0){
      setState(() {
      selectedCategory = allCategories[index].value;
  });
   }
  }


  Future fetchProduct()async{
      DocumentSnapshot product = await _firestore.collection('products').document(widget.productId).get();
      if(product.exists){
            //  prodTitle = product.data['title'];
            //   prodDescription = product.data['description'];
            //   prodPrice = product.data['price'];
              isAvailable = product.data['available'];
      }
      setState(() {
        loading = false;
      });

  }


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
      ),
      body: SingleChildScrollView(
        child: loading ? Center(child: LinearProgressIndicator(backgroundColor: Colors.red,)) : FutureBuilder(
          future: _firestore.collection('products').document(widget.productId).get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {

            if(snapshot.hasData){
              prodTitle = snapshot.data['title'];
              prodDescription = snapshot.data['description'];
              prodPrice = snapshot.data['price'];

              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: TextEditingController(text: snapshot.data['title']),
                      decoration: InputDecoration(
                        labelText: "Product Title",
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Field is required";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        prodTitle = value;
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          'Category :  ',
                          style: TextStyle(fontSize: 18,color: Colors.grey),
                        ),
                               allCategories.isEmpty? CircularProgressIndicator(): DropdownButton(
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19),
                              value: selectedCategory,
                              items: allCategories,
                              onChanged: (selectedValue) {
                                setState(() {
                                  selectedCategory = selectedValue;
                                });
                              }),

                      ],
                    ),
                      SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        prodDescription = value;
                      },
                   controller: TextEditingController(text: snapshot.data['description']),
                    decoration: InputDecoration(labelText: "Description"),
                    keyboardType: TextInputType.multiline,
                    minLines: 3, 
                    maxLines: 10, 
                  ),
                  

                  TextFormField(
                      controller: TextEditingController(text: snapshot.data['price']),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                      
                        labelText: "Price",
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Field is required";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        prodPrice = value;
                      },
                    ),
                    SizedBox(height: 10,),

                   Row(
                     children: [
                       Text("Available",style: TextStyle(fontSize: 18,color: Colors.grey),),
                       SizedBox(width: 10,),
                   Checkbox(
                      value: isAvailable,
                      onChanged: (value) {
                        setState(() {
                          isAvailable = value;
                        });
                      },
                    ),

                     ],
                   ),
                  SizedBox( height: 50.0,),
                  

                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      color: Colors.teal,
                      textColor: Colors.white,
                      padding: EdgeInsets.all(10.0),
                      child: Text("Update", style: TextStyle(fontSize: 20.0),),
                      onPressed: ()async{
                         setState(() {
                           loading = true;
                         });


                        await _firestore.collection('products').document(widget.productId).updateData({
                          'title':prodTitle,
                          'description':prodDescription,
                          'price':prodPrice,
                          'category':selectedCategory,
                          'available':isAvailable,
                        });

                        setState(() {
                          loading = false;
                        });
                      }),
                  ),

                  SizedBox(height: 60.0,),

                                          RaisedButton.icon(
                                            textColor: Colors.white,
                                    label: Text("Delete"),
                        icon: Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () {
                          return showDialog(
                              context: (context),
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Are you sure to delete ?"),
                                  content: Text(""),
                                  actions: <Widget>[
                                    FlatButton(
                                        onPressed: () async {
                                          await _firestore
                                              .collection('products')
                                              .document(widget.productId)
                                              .delete();
                                          Navigator.pop(context);
                                           Navigator.pop(context);

                                        },
                                        child: Text("Yes")),
                                    SizedBox(
                                      width: 30.0,
                                    ),
                                    FlatButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Cancel",
                                          style:
                                              TextStyle(color: Colors.red),
                                        ))
                                  ],
                                );
                              });
                        }),

                  ],
                ),
              );
            }
            return LinearProgressIndicator(backgroundColor: Colors.yellow,);
          },
        ),
      ),
      
    );
  }
}