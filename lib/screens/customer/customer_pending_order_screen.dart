import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http_auth/http_auth.dart' as http_auth;
import '../../screens/customer/customer_track_order.dart';

import 'razor_pay_keys.dart';


class CustomerPendingOrderScreen extends StatefulWidget {
  final Stream pendingStream;
  CustomerPendingOrderScreen({@required this.pendingStream});
  @override
  _CustomerPendingOrderScreenState createState() => _CustomerPendingOrderScreenState();
}

class _CustomerPendingOrderScreenState extends State<CustomerPendingOrderScreen> {
  bool loading = false;

  Future getRefund(paymentId) async{

  var url = 'https://api.razorpay.com/v1/payments/$paymentId/refund';
    var data = {

};
      var client = http_auth.BasicAuthClient(razorpaykey, razorpaySecret);
      var response = await client.post(url,body: data);
      var responseData = json.decode(response.body);
      print(responseData);

}


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
          stream: widget.pendingStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.documents.length == 0) {
                return Center(
                  child: Text(
                    "No Pending Orders",
                    style: TextStyle(fontSize: 30.0),
                  ),
                );
              }
              return loading ? Center(child: CircularProgressIndicator(),):ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all()
                      ),
                      child: ListTile(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>TrackOrderPage(snapshot.data.documents[index])));
                        },
                        title: Text(
                              " Ordered on : "+
                              DateFormat.yMMMd().format(
                                    DateTime.parse(snapshot
                                        .data.documents[index]['date']
                                        .toDate()
                                        .toString()),
                                  ),
                            ),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                              for(var product in snapshot.data.documents[index]['products'])
                               Padding(
                                 padding: const EdgeInsets.only(top:8.0),
                                 child: Wrap(
                                   children: <Widget>[
                                     Container(width: 130,child: Text("-  "+product['title'])),
                                    SizedBox(width: 5.0,),
                                     Container(width: 50,child: Text('Qty: '+product['qty'].toString())),
                                     SizedBox(width: 5.0,),
                                     snapshot.data.documents[index]['price_modified']? Container(
                                       child: 
                                         product['price']!=product['new_price'] ? Column(
                                           children: <Widget>[
                                                       Text('Rs.'+product['price'],style: TextStyle(
                                           decoration: TextDecoration.lineThrough,
                                         ),),
                                         Text('Rs.'+product['new_price'],style: TextStyle(fontWeight: FontWeight.bold),),
                                           ],
                                         ):Text('Rs.'+product['price']),
                               
                                       
                                     ):Text('Rs.'+product['price']),
                                   ],
                                   ),
                               ),
                                SizedBox(height: 10.0,),
                                snapshot.data.documents[index]['price_modified']?Container(margin: EdgeInsets.symmetric(vertical: 10.0),alignment: Alignment.center,child: Text('New Price : Rs.${snapshot.data.documents[index]['new_total']}',style: TextStyle(fontSize: 22.0,color: Colors.red,fontWeight: FontWeight.bold),)):SizedBox.shrink(),
                                snapshot.data.documents[index]['price_modified']? Container(
                                  margin: EdgeInsets.only(bottom: 10.0),
                                  alignment: Alignment.center,
                                  child: RaisedButton(child: Text("Accept",style: TextStyle(fontSize: 20),),onPressed: ()async{
                                       setState(() {
                                      loading = true;
                                    });
                               
                                   await Firestore.instance.collection('orders').document(snapshot.data.documents[index].documentID).updateData({
                                      'status':'accepted',
                                    });

                                       setState(() {
                                      loading = false;
                                    });
                                  },
                                  color: Colors.teal,
                                  textColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 50.0),
                                  ),
                                ):SizedBox.shrink(),
                                // Center(
                                //   child: RaisedButton(onPressed: ()async{
                                //     setState(() {
                                //       loading = true;
                                //     });
                               
                                //     if(snapshot.data.documents[index]['payment_mode'] == 'online'){
                                //       await getRefund(snapshot.data.documents[index]['razorpay_paymentId']);
                                //     }
                                //    await Firestore.instance.collection('orders').document(snapshot.data.documents[index].documentID).updateData({
                                //       'status':'cancelled',
                                //     });

                                //        setState(() {
                                //       loading = false;
                                //     });
                                   
                                //   },
                                //   child: Text("Cancel"),
                                //   ),
                                // ),
                                
                  



                          ],
                        ),
                        trailing: CircleAvatar(
                            child: Text(snapshot.data.documents[index]['total'],style: snapshot.data.documents[index]['price_modified']?TextStyle(
                              decoration: TextDecoration.lineThrough
                            ):TextStyle())),
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