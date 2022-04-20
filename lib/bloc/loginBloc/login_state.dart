import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';


abstract class LoginState{


}


class LoginInitialState extends LoginState{

}



class NumberSubmitted extends LoginState{

}


class LoginSuccess extends LoginState{
   final FirebaseUser user;
  LoginSuccess({@required this.user});


}


class LoginFailed extends LoginState{
  final String msg;

  LoginFailed({@required this.msg});


}