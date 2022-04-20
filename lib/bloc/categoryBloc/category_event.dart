

import 'package:flutter/widgets.dart';

abstract class CategoryEvent{


}



class AddCategory extends CategoryEvent{
  String title;
  String userId;
  AddCategory({@required this.title,@required this.userId});
}