import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class EditCategoryScreen extends StatefulWidget {
  final String categoryId;
  final String title;

  const EditCategoryScreen({@required this.categoryId, @required this.title});

  @override
  _EditCategoryScreenState createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  String newTitle='';
  bool loading = false;
 

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(

      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 30.0,),
            TextFormField(
              initialValue: widget.title,
              onChanged: (value){
                newTitle = value;
              },
              decoration: InputDecoration(
                 border: OutlineInputBorder(), labelText: "Title",
              ),
            ),
            SizedBox(height: 20.0,),
           loading? CircularProgressIndicator(): Container(
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(onPressed: () async{
                if(newTitle.trim().isNotEmpty){
                  setState(() {
                    loading = true;
                  });
                  await Firestore.instance.collection('category').document(widget.categoryId).updateData({
                      "title":newTitle,
                  });

                  setState(() {
                    loading = false;
                  });
                  Navigator.pop(context);
                }else{
                  // show Snackbar if want
                }
              },
              child: Text("Update"),
              color: Colors.teal,
              textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
      
    );
  }
}