import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class CustomerDeliveredOrderScreen extends StatefulWidget {
  final Stream deliveredStream;
  final Firestore firestore;
  final scaffold;
  CustomerDeliveredOrderScreen({@required this.deliveredStream,@required this.scaffold,@required this.firestore});
  @override
  _CustomerDeliveredOrderScreenState createState() => _CustomerDeliveredOrderScreenState();
}

class _CustomerDeliveredOrderScreenState extends State<CustomerDeliveredOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
          stream: widget.deliveredStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.documents.length == 0) {
                return Center(
                  child: Text(
                    "No Delivered Orders",
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

                                //for(var seller in snapshot.data.documents[index]['delivered_by'])
                                 if(snapshot.data.documents[index]['delivered_by'] != '')...[
                                FutureBuilder(
                                  future: widget.firestore.collection('users').document(snapshot.data.documents[index]['delivered_by'][0]).get(),
                                  builder: (context,snapshot){
                                    if(snapshot.hasData){
                                      return InkWell(
                                          onTap: () {
                                            widget.scaffold.currentState
                                                .showBottomSheet((context) =>
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 30,
                                                              vertical: 30),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        20),
                                                                topRight: Radius
                                                                    .circular(
                                                                        20)),
                                                        color: Colors.blueGrey,
                                                      ),
                                                      height: 250,
                                                      child: ListView(
                                                        children: <Widget>[
                                                          Text(
                                                            "Name : " +
                                                                snapshot.data[
                                                                    'fullName'],
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          SizedBox(
                                                            height: 10.0,
                                                          ),
                                                          Text(
                                                              "Phone : " +
                                                                  snapshot.data[
                                                                      'phone'],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                          SizedBox(
                                                            height: 10.0,
                                                          ),
                                                          Text(
                                                              "Company : " +
                                                                  snapshot.data[
                                                                      'company'],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                          SizedBox(
                                                            height: 10.0,
                                                          ),
                                                          Text(
                                                              "GST No : " +
                                                                  snapshot.data[
                                                                      'gstNo'],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                          SizedBox(
                                                            height: 10.0,
                                                          ),
                                                          Text(
                                                              'Address : ' +
                                                                  snapshot.data[
                                                                      'address'],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                        ],
                                                      ),
                                                    ));
                                          },
                                          child: Center(
                                            child: Text(
                                              "Delivered by : " +
                                                  snapshot.data['fullName'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )); 
            
                                    } 
                                    return Center(child: CircularProgressIndicator());
                                  },
                                )],
                                SizedBox(height: 10.0,),
                                Center(
                                  child: Text(
                              " Delivered on : "+
                              DateFormat.yMMMd().format(
                                      DateTime.parse(snapshot
                                          .data.documents[index]['delivered_date']
                                          .toDate()
                                          .toString()),
                                    ),
                            ),
                                ),
                            
                          ],
                        ),
                        trailing: CircleAvatar(
                            child: snapshot.data.documents[index]['price_modified']?Text(snapshot.data.documents[index]['new_total']):Text(snapshot.data.documents[index]['total'])),
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