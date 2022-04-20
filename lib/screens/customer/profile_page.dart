import 'package:flutter/material.dart';
import './contact_form.dart';
import '../../model/user.dart';
import 'bottom_navbar.dart';

class ProfileScreen extends StatelessWidget {
  final User user;
  ProfileScreen({@required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(user: user,screen: 'profile',),
        floatingActionButton: FloatingActionButton(
         heroTag: "help",
        backgroundColor: Colors.orangeAccent,
        onPressed: (){},
        child: Icon(Icons.help_outline,size: 35,
      ),),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Hello, ${user.fullName.toUpperCase()}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
    
      ),
      body: Card(
              child: ListView(
          children: [
            ListTile(
              title: Text('Profile'),

            ),
             ListTile(
              title: Text('Purchases'),
              
            ),
             ListTile(
              title: Text('Shop gift cards'),
              
            ),

             ListTile(
              title: Text('Help'),
              
            ),

            Divider(),
             ListTile(
              title: Text('Contact Us'),
              onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>ContactForm(user:user))),
              
            ),
            ListTile(
              title: Text('Join our Community'),
              
            ),
          ],
        ),
      ),
      
    );
  }
}