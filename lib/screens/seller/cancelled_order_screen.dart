import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SellerCancelledOrderScreen extends StatefulWidget {
  final Stream cancelledStream;
  final Firestore firestore;
  final GlobalKey<ScaffoldState> scaffold;
  SellerCancelledOrderScreen(
      {@required this.cancelledStream,
      @required this.firestore,
      @required this.scaffold});

  @override
  _SellerCancelledOrderScreenState createState() =>
      _SellerCancelledOrderScreenState();
}

class _SellerCancelledOrderScreenState
    extends State<SellerCancelledOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.cancelledStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.documents.length == 0) {
              return Center(
                child: Text(
                  "No Cancelled Orders",
                  style: TextStyle(fontSize: 30.0),
                ),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.all(12),
                    decoration: BoxDecoration(border: Border.all()),
                    child: ListTile(
                      title: Center(
                        child: AutoSizeText(
                            snapshot.data.documents[index]['title'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                      ),
                      subtitle: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 20.0,
                          ),
                          Wrap(
                            children: <Widget>[
                              Text(
                                  "Quantity: ${snapshot.data.documents[index]['qty']}"),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                  "| Color: ${snapshot.data.documents[index]['color']}"),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "| Date: " +
                                    DateFormat.yMMMd().format(
                                      DateTime.parse(snapshot
                                          .data.documents[index]['date']
                                          .toDate()
                                          .toString()),
                                    ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Wrap(
                            children: <Widget>[
                              FutureBuilder(
                                  future: widget.firestore
                                      .collection('users')
                                      .document(snapshot.data.documents[index]
                                          ['userId'])
                                      .get(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
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
                                          child: Text(
                                            "Customer Name : " +
                                                snapshot.data['fullName'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ));
                                    }
                                    return CircularProgressIndicator();
                                  }),
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            'Rs. ' +
                                snapshot.data.documents[index]['price']
                                    .toString(),
                            style: TextStyle(fontSize: 30.0),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          RaisedButton(onPressed: (){
                            var newPrice = 0;
                            showDialog(
                context: context,
                builder: (ctxt) => new AlertDialog(
                  title: Text(snapshot.data.documents[index]['title']),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                          Text(
                                  "Quantity: ${snapshot.data.documents[index]['qty']}"),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                  " Color: ${snapshot.data.documents[index]['color']}"),
                                  TextFormField(
                                    initialValue: newPrice.toString(),
                                    decoration: InputDecoration(
                                      labelText: "New Price",
                                    ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value){
                                      newPrice = int.parse(value.trim());
                                    },
                                  ),

                    ],
                  ),
                  actions: <Widget>[
                    RaisedButton(onPressed: ()async{
                      if(newPrice>0){
                      await  widget.firestore.collection('orders').document(snapshot.data.documents[index].documentID).updateData({
                         'price':newPrice,
                         'status':'approval'
                       });
                        Navigator.pop(ctxt);
                      }
                    },
                    child: Text("Submit"),
                    color: Colors.teal,
                    textColor: Colors.white,
                    ),
                    SizedBox(width: 25.0,),

                    RaisedButton(onPressed: (){
                      Navigator.pop(ctxt);
                    },
                    child: Text("Cancel"),
                    ),
                  ],
                ),);
                          },child: Text("Enter New Price"),
                          color: Colors.orange,
                          textColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
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
