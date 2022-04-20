import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AssignSellerPendingOrder extends StatefulWidget {
  final String orderId;
  AssignSellerPendingOrder({@required this.orderId});

  @override
  _AssignSellerPendingOrderState createState() => _AssignSellerPendingOrderState();
}

class _AssignSellerPendingOrderState extends State<AssignSellerPendingOrder> {
    Firestore _firestore = Firestore.instance;
   String assignedTo = '';
 List<DropdownMenuItem> allSellers = [];
 GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
 bool loading=false;
 var body;

 @override
  void initState() {
    fetchSellers();
    body = getOrderDetail();
    super.initState();
  }

  Future<void> fetchSellers() async{
    var sellers = await Firestore.instance.collection('users').where('role', isEqualTo: 'seller').getDocuments();
     for (var seller in sellers.documents) {
      allSellers.add(DropdownMenuItem(value: seller.documentID, child: Text(seller['company']==''?seller['phone']:seller['company'])));
   }
   if(allSellers.length > 0){
      setState(() {
      assignedTo = allSellers[0].value;
  });
   }
  }

  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(

      ),
      body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  body,
                   Text("Select Seller",style: TextStyle(fontSize: 20.0,fontStyle: FontStyle.italic),),
                       allSellers.isEmpty? CircularProgressIndicator(): DropdownButton(
                         style: TextStyle(
                             color: Colors.black,
                             fontWeight: FontWeight.bold,
                             fontSize: 19),
                         value: assignedTo,
                         items: allSellers,
                         onChanged: (selectedValue) {
                           setState(() {
                             assignedTo = selectedValue;
                           });
                         }),
                         SizedBox(height: 40.0,),
                         
                             loading?CircularProgressIndicator(): Container(
                               margin: EdgeInsets.symmetric(horizontal: 25.0),
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(onPressed: ()async{
                    setState(() {
                      loading =true;
                    });
                  await _firestore.collection('orders').document(widget.orderId).updateData({
                    'status':'pending',
                    'delivered_by': [assignedTo],
                    'seller_assigned':true,
                  });
                  setState(() {
                    loading = false;
                  });
                  Navigator.pop(context);
                  },
                  child: Text("Submit"),
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
  }



   getOrderDetail(){
     return FutureBuilder(
          future: _firestore.collection('orders').document(widget.orderId).get(),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(),
              );
            }else if(snapshot.hasData){
                return Container(
              margin: EdgeInsets.all(12),
              // decoration: BoxDecoration(
              //   border: Border.all()
              // ),
              child: ListTile(
                
                title:      Center(
                  child: Text(
                        "Ordered Date: "+
                        DateFormat.yMMMd().format(
                  DateTime.parse(snapshot
                      .data['date']
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
              for(var product in snapshot.data['products'])
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
                    .data['userId']).get(),
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
                Text("Total Amount: Rs. "+ snapshot.data['total'],style: TextStyle(
                  fontSize: 18.0
                ),),
                
               SizedBox(
                     height: 10.0,
                   ),


                  ],
                ),
              ),
                            );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          });
  }


}