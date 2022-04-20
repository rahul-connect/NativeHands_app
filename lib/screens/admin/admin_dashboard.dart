import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import '../../model/user.dart';
import '../update_app.dart';
import 'admin_drawer.dart';


class AdminDashboard extends StatefulWidget {

  final User user;
  AdminDashboard({@required this.user});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  bool updateAvailable=false;

  @override
  void initState() {
    checkUpdate();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return updateAvailable ? UpdateAppScreen() : Scaffold(
          drawer: AdminDrawer(user: widget.user,),
      appBar: AppBar(
        title: Text("Admin Dashboard"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.power_settings_new),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacementNamed('/auth');
              }),
        ],
      ),
      
    );
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
  
}