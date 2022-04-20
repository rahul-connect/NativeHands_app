import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/user.dart';
import '../../bloc/allOrderBloc/export_all_order_bloc.dart';
import 'approved_order_screen.dart';
import 'delivered_order_screen.dart';
import 'drawer.dart';
import 'pending_order_screen.dart';
import './cancelled_order_screen.dart';

class AllOrder extends StatefulWidget {
  final User user;
  AllOrder({this.user});
  @override
  _AllOrderState createState() => _AllOrderState();
}

class _AllOrderState extends State<AllOrder> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
Firestore _firestore = Firestore.instance;
 int _selectedIndex = 0;



  Widget screens(pendingStream,approvedStream,deliveredStream) {
    List<Widget> _widgetOptions = <Widget>[

      SellerPendingOrderScreen(firestore: _firestore,pendingStream: pendingStream,scaffold: _scaffoldKey,user:widget.user),
      SellerApprovedOrderScreen(firestore: _firestore,approvedStream: approvedStream,scaffold: _scaffoldKey,user:widget.user),
     SellerDeliveredOrderScreen(firestore: _firestore,deliveredStream: deliveredStream,scaffold: _scaffoldKey,user:widget.user),

    ];
    return _widgetOptions[_selectedIndex];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var allOrderBloc = BlocProvider.of<AllOrderBloc>(context)
      ..add(SellerLoadAllOrders(sellerId: widget.user.userId));

    return Scaffold(
      key: _scaffoldKey,
      drawer: SellerDrawer(user: widget.user,),
      appBar: AppBar(
        title: Text("All Orders"),
      ),
      body: BlocBuilder<AllOrderBloc, AllOrderState>(
        builder: (context, state) {
          if (state is AllOrderScreenInitial) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is SellerAllOrdersFetched) {
            return screens(state.allOrderPending,state.allOrderApproved,state.allOrderDelivered,);
          }
          return Text("SONTHING WENT WRONG ! ERROR ");
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.teal,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[

          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            title: Text('Pending'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            title: Text('Accepted'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_align_center),
            title: Text('Delivered'),
          ),

        
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}