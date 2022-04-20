import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'background.dart';
import 'loginUi.dart';
import '../../bloc/loginBloc/login_export_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  final AuthService authService;
  LoginScreen({@required this.authService});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        body: BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(authService: authService),
          child: Stack(
            children: <Widget>[
              Background(),
              Login(),
            ],
          ),
        ));
  }
}
