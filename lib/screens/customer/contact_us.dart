import 'package:flutter/material.dart';


class ContactUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("")
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Image.asset('assets/images/contact.png'),
      ),
      
    );
  }
}

