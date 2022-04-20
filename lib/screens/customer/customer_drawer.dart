import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../screens/admin/admin_dashboard.dart';
import '../../screens/seller/dashboard.dart';
import '../../bloc/orderBloc/export_order_bloc.dart';
import '../../screens/customer/my_order.dart';
import '../../model/user.dart';
import 'become_seller.dart';
import 'cart.dart';
import 'contact_us.dart';
import 'home_screen.dart';
import 'my_account.dart';
import '../../bloc/accountBloc/export_account_bloc.dart';



class CustomerDrawer extends StatelessWidget {
  final User user;
  CustomerDrawer({this.user});

  @override
  Widget build(BuildContext context) {
    return  Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.orangeAccent),
                accountName: Text("${user.fullName}"),
                accountEmail: Text("${user.phoneNo}"),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.black,
                  backgroundImage: AssetImage('assets/images/native_hands_launcher.png'),
                ),
              ),
            ListTile(
               leading: Icon(Icons.home,),
              title: Text('Home'),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>CustomerHomeScreen(user: user,)));

              },
            ),

              ListTile(
               leading: Icon(Icons.shopping_cart,),
              title: Text('My Cart'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyCart(user: user,)));

              },
            ),
           

            ListTile(
               leading: Icon(Icons.shopping_basket),
              title: Text('My Orders'),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> BlocProvider<OrderBloc>(
                  create: (context)=>OrderBloc(),
                  child: MyOrderScreen(user: user,))));
              },
            ),

              ListTile(
                 leading: Icon(Icons.person),
              title: Text('My Account'),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>MyAccount(user: user,)));
              },
            ),

        

              ListTile(
                leading: Icon(Icons.power_settings_new),
              title: Text('Logout'),
              onTap: () {
                  Navigator.pop(context);
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacementNamed('/auth');
              
              },
            ),
            Divider(),
            (user.role=='seller' || user.role=='admin') && user.verified==true? 
                  ListTile(
                 leading: Icon(Icons.work),
              title: Text('Back to Seller View'),
              onTap: () {
               
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx)=>DashBoard(user: user,)));
              },
            ):SizedBox.shrink(),
            //  ListTile(
            //      leading: Icon(Icons.work),
            //   title: user.role=='seller' && user.verified == false ?Text('Waiting Seller Approval',style: TextStyle(color: Colors.red),): Text('Become a Seller'),
            //   onTap: () {
            //     Navigator.pop(context);
            //     user.role=='seller' && user.verified == false ?  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>CustomerHomeScreen(user: user,))) : Navigator.of(context).push(MaterialPageRoute(builder: (context)=>BecomeSellerScreen(user: user,)));
            //   },
            // ),
                  if(user.role=='admin')...[
                ListTile(
                   leading: Icon(Icons.person),
              title: Text('Admin View'),
              onTap: () {
                   Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminDashboard(user: user),
                  ),
                );

              },
            ),
            ],
            
            //   ListTile(
            //      leading: Icon(Icons.phone),
            //   title: Text('Contact us'),
            //   onTap: () {
            //     Navigator.pop(context);
            //     Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>ContactUs()));
            //   },
            // ),

          ],
        ),
      );
  }
}