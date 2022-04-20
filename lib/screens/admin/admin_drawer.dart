import 'package:flutter/material.dart';
import './admin_edit_category.dart';
import '../../screens/seller/dashboard.dart';
import '../../screens/customer/home_screen.dart';
import '../../screens/admin/assign_seller.dart';
import '../../model/user.dart';
import 'admin_dashboard.dart';
import './admin_approve_seller.dart';
import 'admin_inventory.dart';

class AdminDrawer extends StatelessWidget {
  final User user;
  AdminDrawer({ this.user});

  @override
  Widget build(BuildContext context) {
    return  Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("(Admin Dashboard)"),
              accountEmail: Text(""),
            ),
            ListTile(
              title: Text('Dashboard'),
              onTap: () {
               Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>AdminDashboard(user: user,)));
              },
            ),
         
             ListTile(
              title: Text('Delete Category'),
              onTap: () {
                 Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>AdminEditCategory(user: user,)));
              },
            ),
  
             ListTile(
              title: Text('Edit Product'),
              onTap: () {
                 Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AdminInventoryManagement(user,)));
              },
            ),

              ListTile(
              title: Text('Approv Seller'),
              onTap: () {
                 Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AdminAprrovSeller(user: user,)));
              },
            ),

            //  ListTile(
            //   title: Text('Manage Inventory'),
            //   onTap: () {
               
            //   },
            // ),

           
              ListTile(
              title: Text('Assign Seller'),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>SellerAssignOrder(user)));
              },
            ),
            

            // ListTile(
            //   title: Text('All Orders'),
            //   onTap: () {
                   

            //   },
            // ),
            Divider(),
      

              ListTile(
              title: Text('Customer View'),
              onTap: () {
                   Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomerHomeScreen(user: user),
                  ),
                );

              },
            ),

               ListTile(
              title: Text('Seller View'),
              onTap: () {
                   Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DashBoard(user: user),
                  ),
                );

              },
            ),
 
          ],
        ),
      );
  }
}