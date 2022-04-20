


import 'package:flutter/widgets.dart';

abstract class OrderEvent{

}



class LoadAllOrders extends OrderEvent{
  final String userId;
  LoadAllOrders({@required this.userId});

}