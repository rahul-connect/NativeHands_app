import 'package:flutter/material.dart';
import './search_screen.dart';
import '../../model/user.dart';
import '../../screens/customer/home_screen.dart';
import '../../screens/customer/profile_page.dart';
import '../../screens/customer/wishlist_screen.dart';


class BottomNavBar extends StatelessWidget {
  final User user;
  final String screen;
  BottomNavBar({this.user,this.screen});
  
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.grey[500],
      shape: CircularNotchedRectangle(),
      child: Container(
        height: 50,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                  onTap: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>CustomerHomeScreen(user: user)));
                  },
                child: Icon(Icons.home,size: 40, color: screen=='home'? Colors.orangeAccent:Colors.white,)),


               GestureDetector(
                  onTap: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>SearchScreen(user: user)));
                  },
                 child: Icon(Icons.search,size: 40, color: screen=='search'? Colors.orangeAccent:Colors.white,)),

               SizedBox.shrink(),
               
                GestureDetector(
                  onTap: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>WishlistScreen(user: user)));
                  },
                  child: Icon(Icons.favorite_border,size: 40, color: screen=='wishlist'? Colors.orangeAccent:Colors.white,)),

                  
                 GestureDetector(
                   onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>ProfileScreen(user: user)));
                   },
                   child: Icon(Icons.person,size: 40, color: screen=='profile'? Colors.orangeAccent:Colors.white,)),
            ],
          ),
        ),
      ),
      
    );
  }
}