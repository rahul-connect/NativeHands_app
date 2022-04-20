import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../model/user.dart';
import 'admin_drawer.dart';
import 'assign_order.dart';

class SellerAssignOrder extends StatefulWidget {
  final User user;
  SellerAssignOrder(this.user);
  @override
  _SellerAssignOrderState createState() => _SellerAssignOrderState();
}

class _SellerAssignOrderState extends State<SellerAssignOrder> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); 
 Firestore _firestore = Firestore.instance;
 int _selectedIndex = 0;


 void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget screens() {
    List<Widget> _widgetOptions = <Widget>[
      assignPendingOrders(),
     acceptedOrders(),
    ];

    return _widgetOptions[_selectedIndex];
  }
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: AdminDrawer(user: widget.user,),
      appBar: AppBar(
        title: Text('Assign Seller'),
      ),
      body: screens(),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.teal,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            title: Text('Pending'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            title: Text('Assigned'),
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.format_align_center),
          //   title: Text('Delivered'),
          // ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),

    );
  }


  Widget assignPendingOrders(){
    return StreamBuilder(
      stream: _firestore.collection('orders').where('delivered_by',isEqualTo: []).where('status',isEqualTo: 'pending').orderBy('date',descending: true).snapshots(),
      builder: (context,snapshot){
        if(snapshot.connectionState==ConnectionState.waiting){
          return CircularProgressIndicator();
        }else if(snapshot.hasData){
          if(snapshot.data.documents.length == 0){
             return Center(child:Text("No Orders to Assign"));
          }else{
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
                                 child: Wrap(
                                   children: <Widget>[
                                     Text("-  "+product['title']+' | '),
                                    SizedBox(width: 10.0,),
                                     Text('Qty: '+product['qty'].toString()+' | '),
                                     SizedBox(width: 10.0,),
                                     Text('Rs.'+product['price']),
                                   ],
                                   ),
                               ),
                 
                  ],
                ),
                SizedBox(height: 10.0,),

                Wrap(
                  children: <Widget>[
                       FutureBuilder(
                      future: _firestore.collection('users').document(snapshot
                    .data.documents[index]['userId']).get(),
                      builder: (context,snapshot){
                            if(snapshot.hasData){
              
              return InkWell(
                onTap: (){
                  _scaffoldKey.currentState.showBottomSheet(
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
                Text("Total Amount: Rs. "+ snapshot.data.documents[index]['total'],style: TextStyle(
                  fontSize: 18.0
                ),),
                SizedBox(height: 15.0,),


                Container(
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(onPressed: ()async{
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AssignSellerPendingOrder(orderId: snapshot.data.documents[index].documentID,)));
      
                  },
                  child: Text("Assign now"),
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
          }
        }
        return Center(child: CircularProgressIndicator());
      });
  }




    Widget acceptedOrders(){
    return StreamBuilder(
      stream: _firestore.collection('orders').where('status',isEqualTo: 'pending').where('seller_assigned',isEqualTo: true).orderBy('date',descending: true).snapshots(),
      builder: (context,snapshot){
        if(snapshot.connectionState==ConnectionState.waiting){
          return CircularProgressIndicator();
        }else if(snapshot.hasData){
          if(snapshot.data.documents.length == 0){
             return Center(child:Text("All orders are Accepted"));
          }else{
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
                      future: _firestore.collection('users').document(snapshot
                    .data.documents[index]['userId']).get(),
                      builder: (context,snapshot){
                            if(snapshot.hasData){
              
              return InkWell(
                onTap: (){
                  _scaffoldKey.currentState.showBottomSheet(
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

                Wrap(
                  children: <Widget>[
                       FutureBuilder(
                      future: _firestore.collection('users').document(snapshot
                    .data.documents[index]['delivered_by'][0]).get(),
                      builder: (context,snapshot){
                            if(snapshot.hasData){
              
              return InkWell(
                onTap: (){
                  _scaffoldKey.currentState.showBottomSheet(
                    (context)=> Container(
                      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
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
                    )
                  );
                  
                },
                child: Text("Seller Details : "+ snapshot.data['fullName'],style: TextStyle(
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
                
                


               snapshot.data.documents[index]['status'] != 'pending'? Container(
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(onPressed: ()async{
                  await _firestore.collection('orders').document(snapshot.data.documents[index].documentID).updateData({
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
                ) : RaisedButton(onPressed: (){},child: snapshot.data.documents[index]['price_modified'] == true ? Text("Not Accepted by Buyer"):Text('Not Accepted by Seller'),)

                  ],
                ),
              ),
                            );
                      });
          }
        }
        return Center(child: CircularProgressIndicator());
      });
  }


}