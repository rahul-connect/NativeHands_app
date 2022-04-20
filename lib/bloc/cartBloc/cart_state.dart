

import 'package:flutter/widgets.dart';

abstract class CartState{


}


class CartInitial extends CartState{


}


class ItemsFetchedSuccess extends CartState{
  final Stream cartItems;
  ItemsFetchedSuccess({@required this.cartItems});

}


class ItemRemovedSucess extends CartState{

}

class OrderingState extends CartState{}


class OrderNowSuccess extends CartState{


}