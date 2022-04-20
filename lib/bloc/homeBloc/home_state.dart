

import 'package:flutter/widgets.dart';

abstract class HomeState {


}



class HomeInitialState extends HomeState{


}


class CategoryFetched extends HomeState{
  Future categories;

  CategoryFetched({@required this.categories});

}

class ProductsFetchedSuccess extends HomeState{
  final Stream allProducts;

  ProductsFetchedSuccess(this.allProducts);

}