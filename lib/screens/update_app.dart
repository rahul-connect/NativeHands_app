import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class UpdateAppScreen extends StatelessWidget {
  
  var url='https://play.google.com/store/apps/details?id=com.app.nativeHands';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 300,
              width: MediaQuery.of(context).size.width,
              child: Image.asset('assets/images/native_icon.png',fit: BoxFit.cover,)),
            Text('UPDATE YOUR APP NOW',style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
            Icon(Icons.arrow_downward),
            InkWell(
              onTap: ()async{
                    if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
              },
              child: Image.asset('assets/images/playstore.png',height: 150.0,)),
          ],
        ),
      ),
      
    );
  }
}