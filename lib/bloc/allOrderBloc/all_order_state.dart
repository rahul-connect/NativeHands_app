import 'package:flutter/widgets.dart';

abstract class AllOrderState {

}


class AllOrderScreenInitial extends AllOrderState{

}


class SellerAllOrdersFetched extends AllOrderState{
  final Stream allOrderPending;
  final Stream allOrderApproved;
  final Stream allOrderDelivered;

  SellerAllOrdersFetched({@required this.allOrderPending,@required this.allOrderApproved,@required this.allOrderDelivered});
  
}