import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../model/user.dart';


class SellerApprovedOrderScreen extends StatefulWidget {

  final Stream approvedStream;
  final Firestore firestore;
   final GlobalKey<ScaffoldState> scaffold;
    final User user;

  SellerApprovedOrderScreen({@required this.approvedStream,@required this.firestore,@required this.scaffold,@required this.user});
  @override
  _SellerApprovedOrderScreenState createState() => _SellerApprovedOrderScreenState();
}

class _SellerApprovedOrderScreenState extends State<SellerApprovedOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
          stream: widget.approvedStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.documents.length == 0) {
                return Center(
                  child: Text(
                    "No Accepted Orders",
                    style: TextStyle(fontSize: 30.0),
                  ),
                );
              }
              return ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        return Container(
              margin: EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all()
              ),
              child: ListTile(
                
                title:      Center(
                  child: Text(
                        "Ordered Date: "+
                        DateFormat.yMMMd().format(
                  DateTime.parse(snapshot
                      .data.documents[index]['date']
                      .toDate()
                      .toString()),
              ),
                      ),
                ),
                subtitle: Column(
                  children: <Widget>[
                SizedBox(height: 20.0,),
                Wrap(
                  children: <Widget>[
              for(var product in snapshot.data.documents[index]['products'])
                               Padding(
                                 padding: const EdgeInsets.only(top:8.0),
                                 child: Row(
                                   children: <Widget>[
                                     Container(
                                       width: 115,
                                       child: Text("-  "+product['title'])),
                                    SizedBox(width: 5.0,),
                                    
                                     Container(
                                       width: 50,
                                       child: Text(' Qty: '+product['qty'].toString())),
                                     SizedBox(width: 5.0,),

                                     Container(
                                       width: 60,
                                       child:  snapshot.data.documents[index]['price_modified']? Column(
                                       children: <Widget>[
                                         product['price']!=product['new_price'] ? Column(
                                           children: <Widget>[
                                              Text('Rs.'+product['price'],style: TextStyle(
                                           decoration: TextDecoration.lineThrough,
                                         ),),
                                         Text('Rs.'+product['new_price'],style: TextStyle(fontWeight: FontWeight.bold),),
                                           ],
                                         ):Text('Rs.'+product['price']),
                                        
                                       ],
                                     ):Text('Rs.'+product['price']),
                                     
                                     ),   

                                     SizedBox(width: 5.0,),
                                     snapshot.data.documents[index]['price_modified']?Text("| Rs.${product['qty'] * int.parse(product['new_price'])}"):Text("| Rs.${product['qty'] * int.parse(product['price'])}"),
                                   ],
                                   ),
                               ),
                 
                  ],
                ),
                SizedBox(height: 10.0,),

                Wrap(
                  children: <Widget>[
                       FutureBuilder(
                      future: widget.firestore.collection('users').document(snapshot
                    .data.documents[index]['userId']).get(),
                      builder: (context,snapshot){
                            if(snapshot.hasData){
              
              return InkWell(
                onTap: (){
                  widget.scaffold.currentState.showBottomSheet(
                    (context)=> Container(
                      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                        color: Colors.blueGrey,
                      
                      ),
                  
                        height: 250,
                      child: ListView(
                    
                        children: <Widget>[

                          Text("Name : " + snapshot.data['fullName'],style: TextStyle(color: Colors.white),),
                          SizedBox(height: 10.0,),
                           Text("Phone : " + snapshot.data['phone'],style: TextStyle(color: Colors.white)),
                            SizedBox(height: 10.0,),
                            Text('Address : ' + snapshot.data['address'],style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    )
                  );
                  
                },
                child: Text("Customer Name : "+ snapshot.data['fullName'],style: TextStyle(
                  fontWeight: FontWeight.bold
                ),));
                            } 
                            return CircularProgressIndicator();
                    }),
                  ],
                ),
                SizedBox(height: 15.0,),
                snapshot.data.documents[index]['price_modified']? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Total Amount: Rs.",style: TextStyle(fontSize: 20),),
                    Text(snapshot.data.documents[index]['total'],style: TextStyle(fontSize: 20,decoration: TextDecoration.lineThrough),),
                    SizedBox(width: 5.0,),
                    Text(snapshot.data.documents[index]['new_total'],style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold,color: Colors.black),),
                  ],
                ):Text("Total Amount: Rs. "+ snapshot.data.documents[index]['total'],style: TextStyle(
                  fontSize: 18.0
                ),),
                SizedBox(height: 15.0,),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(onPressed: ()async{
                  await widget.firestore.collection('orders').document(snapshot.data.documents[index].documentID).updateData({
                    'status':'delivered',
                    'delivered_date':DateTime.now(),
                  });
                  },
                  child: Text("Delivered"),
                  color: Colors.teal,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)
                  ),
                  ),
                )

                  ],
                ),
              ),
                            );
                      });
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          });
  }
}