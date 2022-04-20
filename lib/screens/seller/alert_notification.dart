
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();


void newOrderNotification(BuildContext context){

          _firebaseMessaging.configure(
            onMessage: (Map<String,dynamic> message) async{
              print("New Order Received");
              
                 await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                        content: ListTile(
                        title: Text(message['notification']['title']),
                        subtitle: Text(message['notification']['body']),
                        ),
                        actions: <Widget>[
                        FlatButton(
                            child: Text('Ok'),
                            onPressed: () {
                               Navigator.of(context).pop();
                                Navigator.of(context).pop();
                            },
                        ),
                    ],
                ),
            );

          
            },
               onLaunch: (Map<String,dynamic> message) async{
                 print(message);
            },
               onResume: (Map<String,dynamic> message) async{
                 print(message);
            },
          );
      

}