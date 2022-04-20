import 'package:flutter/material.dart';
import '../../screens/admin/admin_dashboard.dart';
import '../../screens/customer/home_screen.dart';
import '../../screens/customer/contact_us.dart';
import '../../bloc/allOrderBloc/export_all_order_bloc.dart';
import '../../bloc/uploadBloc/export_upload_bloc.dart';
import '../../model/user.dart';
import '../../screens/seller/all_orders.dart';
import '../../screens/seller/dashboard.dart';
import 'account_details.dart';
import 'category.dart';
import 'inventory.dart';
import 'upload_product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/categoryBloc/export_category_bloc.dart';
import 'package:url_launcher/url_launcher.dart';


class SellerDrawer extends StatelessWidget {
  final User user;
  SellerDrawer({ this.user});



  @override
  Widget build(BuildContext context) {
    return  Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(""),
              accountEmail: Text(""),
            ),
            ListTile(
              title: Text('Dashboard'),
              onTap: () {
               Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>DashBoard(user: user,)));
              },
            ),
         
             ListTile(
              title: Text('Category'),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>BlocProvider<CategoryBloc>(create: (context)=>CategoryBloc(),child: CategoryScreen(user: user,))));
              },
            ),
            ListTile(
              title: Text('Upload Product'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider<UploadBloc>(create: (context)=>UploadBloc(),child: UploadProduct(user:user)),
                  ),
                );
              },
            ),
             ListTile(
              title: Text('Manage Inventory'),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>InventoryScreen(user)));
              },
            ),

      

            ListTile(
              title: Text('All Orders'),
              onTap: () {
                   Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider<AllOrderBloc>(create: (context)=>AllOrderBloc(),child: AllOrder(user:user)),
                  ),
                );

              },
            ),
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
            if(user.role=='admin')...[
                ListTile(
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

              Divider(),
               ListTile(
              title: Text('My Account'),
              onTap: () {
                   Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SellerAccountDetail(user: user),
                  ),
                );

              },
            ),
            ListTile(
              title: Text('Privacy Policy'),
              onTap: () async{
                 const url = 'https://sites.google.com/view/streesareesapp';
                  if (await canLaunch(url)) {

                    await launch(url);
                  } else {
                    print('Could not launch $url');
                  }
                //  https://sites.google.com/view/streesareesapp

              },
            ),
                  ListTile(
              
              title: Text('Contact us'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>ContactUs()));
              },
            ),
          ],
        ),
      );
  }
}