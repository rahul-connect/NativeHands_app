

import 'package:flutter/widgets.dart';

abstract class HomeEvent{

}



class FetchCategoryEvent extends HomeEvent{
  
}


class FetchCategoryProducts extends HomeEvent{
  final String category;

  FetchCategoryProducts({@required this.category});

}