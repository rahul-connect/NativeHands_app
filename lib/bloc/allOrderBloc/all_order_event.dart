
import 'package:flutter/material.dart';

abstract class AllOrderEvent{

}



class SellerLoadAllOrders extends AllOrderEvent{
   final String sellerId;
   SellerLoadAllOrders({@required this.sellerId});

}