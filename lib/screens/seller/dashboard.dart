import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/user.dart';
import '../../bloc/dashboardBloc/export_dashboard_bloc.dart';
import '../../screens/update_app.dart';
import 'alert_notification.dart';
import 'drawer.dart';
import 'package:package_info/package_info.dart';

class DashBoard extends StatefulWidget {
   final User user;
   DashBoard({this.user});

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  bool updateAvailable=false;

  @override
  void initState() { 
    checkUpdate();
    newOrderNotification(context);
    super.initState();
    
  }

    Future<void> checkUpdate()async{
     DocumentSnapshot latestupdate = await Firestore.instance.collection('update').document('checkupdateforapp').get();
     
     String latestapp =  latestupdate['buildNumber'];

     PackageInfo packageInfo = await PackageInfo.fromPlatform();
     String currentapp = packageInfo.buildNumber;

      if(int.parse(latestapp) > int.parse(currentapp)){
        print("Update");
          setState(() {
            updateAvailable = true;
          });
      }
  }

 

  @override
  Widget build(BuildContext context) {
    var dashboardBloc = BlocProvider.of<DashboardBloc>(context)..add(LoadAnalyticsEvent(sellerId: widget.user.userId));


    return updateAvailable ? UpdateAppScreen() :  Scaffold(
      drawer: SellerDrawer(user: widget.user,),
      appBar: AppBar(
        title: Text("Dashboard"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.power_settings_new),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacementNamed('/auth');
              }),
        ],
      ),
      body: BlocBuilder<DashboardBloc,DashboardState>(
        builder: (context,state){
          if(state is DashboardInitial){
            return Center(
              child: CircularProgressIndicator(),
            );

          }else if(state is AnalyticsLoaded){
            return ListView(
          children: <Widget>[
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(color: Colors.teal)),
              borderOnForeground: true,
              margin: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      "New Orders",
                      style: TextStyle(fontSize: 20.0, color: Colors.teal),
                    ),
                    SizedBox(height: 10.0,),
                    Text(state.countPendingOrders.toString(),style: TextStyle(fontSize: 20.0, color: Colors.teal),),
                  ],
                ),
              ),
            ),

             Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(color: Colors.teal)),
              borderOnForeground: true,
              margin: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Accepted Orders",
                      style: TextStyle(fontSize: 20.0, color: Colors.teal),
                    ),
                    SizedBox(height: 10.0,),
                    Text(state.countApprovedOrders.toString(),style: TextStyle(fontSize: 20.0, color: Colors.teal),),
                  ],
                ),
              ),
            ),

             Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(color: Colors.teal)),
              borderOnForeground: true,
              margin: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Delivered Orders",
                      style: TextStyle(fontSize: 20.0, color: Colors.teal),
                    ),
                    SizedBox(height: 10.0,),
                    Text(state.countDeliveredOrders.toString(),style: TextStyle(fontSize: 20.0, color: Colors.teal),),
                  ],
                ),
              ),
            ),

            //  Card(
            //   elevation: 4,
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(20.0),
            //       side: BorderSide(color: Colors.teal)),
            //   borderOnForeground: true,
            //   margin: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            //   child: Padding(
            //     padding: const EdgeInsets.all(20.0),
            //     child: Column(
            //       children: <Widget>[
            //         Text(
            //           "Total Customers",
            //           style: TextStyle(fontSize: 20.0, color: Colors.teal),
            //         ),
            //         SizedBox(height: 10.0,),
            //         Text(state.countTotalCustomers.toString(),style: TextStyle(fontSize: 20.0, color: Colors.teal),),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        );
          }
        },
               
      ),
    );
  }
}
