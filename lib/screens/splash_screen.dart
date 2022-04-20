import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white10,
        ),
        child: Center(
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 25,
                left: 25,
                child: Image.asset(
                  'assets/images/native_hands_logo.png',      
                  width: 200.0,
                  height: 200,
                ),
              ),
              SizedBox(
                width: 250,
                height: 250,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
