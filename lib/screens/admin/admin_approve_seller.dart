import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../model/user.dart';


class AdminAprrovSeller extends StatefulWidget {
  final User user;
  AdminAprrovSeller({ this.user});
  @override
  _AdminAprrovSellerState createState() => _AdminAprrovSellerState();
}

class _AdminAprrovSellerState extends State<AdminAprrovSeller> {
   Firestore _firestore = Firestore.instance;
   GlobalKey<ScaffoldState> scaffold = GlobalKey<ScaffoldState>();
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffold,
      appBar: AppBar(
        title: Text("Seller Approval"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: _firestore.collection('users').where('role',isEqualTo: 'seller').where('verified',isEqualTo: false).snapshots(),
        builder: (contex,snapshot){
          if(snapshot.hasData){
            if(snapshot.data.documents.length < 1){
              return Center(
                child: Text("No Seller request"),
              );
            }else{
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context,index){
                  var user = snapshot.data.documents[index];
                  return ListTile(
                   
                    title: InkWell(
                      onTap:  (){
                  scaffold.currentState.showBottomSheet(
                    (context)=> Container(
                      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                        color: Colors.blueGrey,
                      
                      ),
                  
                        height: 250,
                      child: ListView(
                    
                        children: <Widget>[

                          Text("Name : " + user['fullName'],style: TextStyle(color: Colors.white),),
                          SizedBox(height: 10.0,),
                           Text("Phone : " + user['phone'],style: TextStyle(color: Colors.white)),
                            SizedBox(height: 10.0,),
                            Text('Address : ' + user['address'],style: TextStyle(color: Colors.white)),
                            SizedBox(height: 10.0,),
                            Text('Company : ' + user['company'],style: TextStyle(color: Colors.white)),
                            SizedBox(height: 10.0,),
                            Text('GST : ' + user['gstNo'],style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    )
                  );
                  
                },
                      child: Text(user['fullName']??'Name not mentioned')),
                    subtitle: Text(user['phone']),
                    trailing: Wrap(
                      children: <Widget>[
                        RaisedButton.icon(
                          color: Colors.green,
                          label: Text("Approv",style: TextStyle(color: Colors.white),),
                          icon: Icon(Icons.check_circle,color: Colors.white,), onPressed: ()async{
                              await _firestore.collection('users').document(user['userId']).updateData({
                                'verified':true,
                              });
                          }),
                        IconButton(icon: Icon(Icons.cancel,color: Colors.red), onPressed: ()async{
                          await _firestore.collection('users').document(user['userId']).updateData({
                                'role':'customer',
                                 'verified':false,
                              });

                        })
                      ],
                    ),
                  );
                });
            }
          }
          return Center(
            child: CircularProgressIndicator(),
          );

      }),
      
    );
  }
}