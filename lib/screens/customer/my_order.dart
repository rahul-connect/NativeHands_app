import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/user.dart';
import '../../bloc/orderBloc/export_order_bloc.dart';
import 'customer_accepted_order_screen.dart';
import 'customer_delivered_order_screen.dart';
import 'customer_drawer.dart';

import 'customer_pending_order_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class MyOrderScreen extends StatefulWidget {
  final User user;
  MyOrderScreen({@required this.user});
  @override
  _MyOrderScreenState createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  int _selectedIndex = 0;
  Firestore _firestore = Firestore.instance;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget screens(pendingStream,approvalStream,deliveredStream) {
    List<Widget> _widgetOptions = <Widget>[
    CustomerPendingOrderScreen(pendingStream: pendingStream,),

      CustomerAcceptedOrderScreen(firestore: _firestore,acceptedStream:approvalStream,scaffold: _scaffoldKey,),
      CustomerDeliveredOrderScreen(deliveredStream: deliveredStream,firestore: _firestore,scaffold: _scaffoldKey,),
   

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
    var orderBloc = BlocProvider.of<OrderBloc>(context)
      ..add(LoadAllOrders(userId: widget.user.userId));

    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomerDrawer(user: widget.user),
      appBar: AppBar(
        title: Text("My Orders"),
        // bottom: PreferredSize(child: Column(
        //   children: [
        //     Row(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        
        //         FlatButton.icon(onPressed: (){
                
        //           launch("tel://9986550777");
        //         }, icon:Text("For any Enquiry :",style: TextStyle(color: Colors.white),), label: Text("9986550777",style: TextStyle(color: Colors.white),)),
                
        //       ],
        //     ),
          
        //   ],
        // ), preferredSize: Size.fromHeight(30.0)),
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderScreenInitial) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is OrdersFetchedSuccess) {
            return screens(state.orderPending,state.approvalOrders,state.deliveredOrders);
          }
          return Text("SONTHING WENT WRONG ! ERROR ");
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.teal,
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
