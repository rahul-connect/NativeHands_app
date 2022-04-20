import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EditOrderPrice extends StatefulWidget {
  final sellerId;
  final  orderId;
  final  List productList;

  const EditOrderPrice({@required this.orderId,@required this.productList,@required this.sellerId});

  @override
  _EditOrderPriceState createState() => _EditOrderPriceState();
}

class _EditOrderPriceState extends State<EditOrderPrice> {

  List allproducts;
  int tolalNewPrice = 0;
  var controller = StreamController<int>();
  final Firestore _db = Firestore.instance;
  bool isLoading = false;

  @override
  void dispose() { 
    controller.close();
    super.dispose();
  }


  calculateNewTotal(){
    tolalNewPrice = 0;
    for(var product in allproducts){
        tolalNewPrice += (int.parse(product['new_price']) * product['qty']);
    }
    controller.add(
      tolalNewPrice
    );
  
  }

  @override
  void initState() {
    allproducts = widget.productList;
    calculateNewTotal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Order"),
        actions: <Widget>[
          StreamBuilder(
            stream: controller.stream,
            builder: (context,snapshot){
              return FlatButton(child:Text('Rs. ${snapshot.data}',style: TextStyle(color: Colors.white),),onPressed: (){},);
            }),
          
          // IconButton(icon: Icon(Icons.save),onPressed: ()async{
          //   setState(() {
          //     isLoading = true;
          //   });
          //   await _db.collection('orders').document(widget.orderId).updateData({
          //     'products':allproducts,
          //     'price_modified':true,
          //     'new_total':tolalNewPrice.toString(),
          //     //'status':'approval',
          //   });
          //   Navigator.pop(context);
          // }),
           OutlineButton(
               borderSide: BorderSide(color: Colors.white),
               textColor: Colors.white,
               child: Text('Accept'),onPressed: ()async{
              setState(() {
                isLoading = true;
              });
              await _db.collection('orders').document(widget.orderId).updateData({
                'products':allproducts,
                'price_modified':true,
                'new_total':tolalNewPrice.toString(),
                //'status':'approval',
              });
              Navigator.pop(context);
          }),
         


        ],
      ),
      body: isLoading? Center(child: CircularProgressIndicator(),):ListView.builder(
        itemCount: allproducts.length,
        itemBuilder: (context,index){
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading:CircleAvatar(
                backgroundColor: Colors.black,
                child: Text("${allproducts[index]['qty']} x",style: TextStyle(color: Colors.white),),
              ),
              title: Text('- '+allproducts[index]['title']), 
              trailing: CircleAvatar(
                backgroundColor: Colors.white38,
                child: IconButton(icon: Icon(Icons.delete), onPressed: (){
                  allproducts.removeAt(index);
                  calculateNewTotal();
                  setState(() {
                    
                  });
                  
                },
                color: Colors.red
                ),
              ),
              subtitle: TextField(
                controller: TextEditingController(text:allproducts[index]['price']),
                keyboardType: TextInputType.number,
                onChanged: (value){
                  if(value.trim() != ''){
                    allproducts[index]['new_price'] = value;
                    calculateNewTotal();
                  }
                },
              )
        ),
          );
        },)
      
    );
  }
}