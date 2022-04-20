

import 'package:flutter/widgets.dart';

abstract class OrderState {

}


class OrderScreenInitial extends OrderState{

}


class OrdersFetchedSuccess extends OrderState{
  final Stream orderPending;
  final Stream approvalOrders;
  final Stream deliveredOrders;


  OrdersFetchedSuccess({@required this.orderPending,@required this.approvalOrders,@required this.deliveredOrders});
  
}