import 'package:flutter/widgets.dart';

abstract class LoginEvent{


}


class LoginButtonPressed extends LoginEvent{
   final String phoneNumber;
  LoginButtonPressed({@required this.phoneNumber});



}

class ResetLogin extends LoginEvent{
  
}


class CheckOtpEvent extends LoginEvent{
  final String otpValue;
  CheckOtpEvent({@required this.otpValue});

}

class Logout extends LoginEvent{
  
}