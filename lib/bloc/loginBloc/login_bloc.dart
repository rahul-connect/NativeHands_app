import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import './login_event.dart';
import './login_state.dart';
import '../../services/auth_service.dart';


class LoginBloc extends Bloc<LoginEvent,LoginState>{

  final AuthService _authService;

  LoginBloc({@required AuthService authService}):
  assert(authService != null),
  _authService = authService;


  @override
  LoginState get initialState => LoginInitialState();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {

    if(event is LoginButtonPressed){
      final phoneNumber = event.phoneNumber.trim();
      await _authService.sendOtpCode(phoneNo: phoneNumber); 
      yield NumberSubmitted();
      
     

    }else if(event is CheckOtpEvent){
       final otp = event.otpValue.trim();
       
       FirebaseUser checkAuth = await _authService.verifyOtpLogin(smsOTP: otp).then((value){
          return value;
       });

       if(checkAuth != null){
         yield LoginSuccess(user: checkAuth);
       }



    }else if(event is Logout){
      _authService.signOut();
    }else if(event is ResetLogin){
      yield LoginInitialState();
    }

  }







}