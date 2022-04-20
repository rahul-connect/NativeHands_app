


import 'package:flutter/widgets.dart';


abstract class AccountEvent {

}



class UpdateDetail extends AccountEvent{
  final String fullName;
  final String company;
  final String gstNo;
  final String address;
  final String userId;
  bool becomeSeller;

  UpdateDetail({ @required this.fullName,@required this.address,@required this.company, @required this.gstNo,@required this.userId,this.becomeSeller=false});

}