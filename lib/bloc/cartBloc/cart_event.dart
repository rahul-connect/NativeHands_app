


import 'package:flutter/widgets.dart';

abstract class CartEvent{

}



class FetchCartItems extends CartEvent{
    final userId;
    FetchCartItems({@required this.userId});
}


class RemoveItem extends CartEvent{
  final cartItemId;
  final userId;
  RemoveItem({@required this.cartItemId,this.userId});
}



class OrderNowPressed extends CartEvent{
  final userId;
  final String totalAmount;
  final String paymentId;
  final String orderId;
  final String paymentMode; // Cash or Online
  OrderNowPressed({@required this.userId,@required this.totalAmount,this.paymentId,this.orderId,this.paymentMode});
}