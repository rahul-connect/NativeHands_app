import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/loginBloc/login_export_bloc.dart';
import 'inputWidget.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _phoneNumber = TextEditingController();
  TextEditingController _otpCode = TextEditingController();
  bool enterOtp = false;


  @override
  void dispose() {
    _phoneNumber.clear();
    _phoneNumber.dispose();
    _otpCode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);

    return Column(
      children: <Widget>[
        Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height / 2.3),
        ),
       enterOtp ? otpScreen(loginBloc,_otpCode) :
        Column(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 40, bottom: 10),
                  child: Text(
                    "Phone Number",
                    style: TextStyle(fontSize: 16, color: Color(0xFF999A9A)),
                  ),
                ),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: <Widget>[
                    InputWidget(30.0, 0.0, _phoneNumber),
                    Padding(
                        padding: EdgeInsets.only(right: 50),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Padding(
                              padding: EdgeInsets.only(top: 40),
                              child: Text(
                                'Enter your phone number to login/signup...',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: Color(0xFFA0A0A0), fontSize: 12),
                              ),
                            )),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: ShapeDecoration(
                                shape: CircleBorder(),
                                gradient: LinearGradient(
                                 colors:
                                   signInGradients,
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight),
                              ),
                              child: ImageIcon(
                                AssetImage("assets/images/mobile.png"),
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 50),
            ),
            BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                if (state is LoginInitialState) {
                  return InkWell(
                    onTap: () {
                
                      if (_phoneNumber.text.trim().isNotEmpty) {
                        loginBloc.add(LoginButtonPressed(
                            phoneNumber: _phoneNumber.text));
                            setState(() {
                              enterOtp = true;
                            });
                      }


                    },
                    child:
                        roundedRectButton("Submit", signInGradients, false),
                  );
                }

                return CircularProgressIndicator();
              },
            ),
          ],
        )
      ],
    );
  }

  Widget otpScreen(loginBloc,_otpCode){
  
  return Padding(
        padding: const EdgeInsets.symmetric(horizontal:30.0),
        child: Column(
          children: <Widget>[
            CircularProgressIndicator(backgroundColor: Colors.red,),
            SizedBox(height: 10.0,),
            Text("If not automatically detects then type below.."),
            SizedBox(height: 30.0,),
            TextField(
              controller: _otpCode,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(border: OutlineInputBorder(),labelText: "Enter OTP here..." ),
          ),

            Container(
                margin: EdgeInsets.only(top:20.0),
              child: RaisedButton(
                  onPressed: () {
                    if(_otpCode.text.trim() != ""){
                     loginBloc.add(CheckOtpEvent(otpValue: _otpCode.text));
                    }

                  },
                  child: Text("LOGIN",style: TextStyle(fontSize:20.0),),
                  color: Colors.green,
                  textColor: Colors.white,
                ),
              ),
                 SizedBox(height: 10.0,),

                 OutlineButton(onPressed: (){
                    loginBloc.add(ResetLogin());
                    setState(() {
                        enterOtp = false;
                      });
                     
                    
                 },child:Text("Reset"))
          ],
        ),
      );
}


}





Widget roundedRectButton(
    String title, List<Color> gradient, bool isEndIconVisible) {
  return Builder(builder: (BuildContext mContext) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Stack(
        alignment: Alignment(1.0, 0.0),
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(mContext).size.width / 1.7,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              gradient: LinearGradient(
                 colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
            ),
            child: Text(title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500)),
            padding: EdgeInsets.only(top: 16, bottom: 16),
          ),
          Visibility(
            visible: isEndIconVisible,
            child: Padding(
                padding: EdgeInsets.only(right: 10),
                child: ImageIcon(
                  AssetImage("assets/ic_forward.png"),
                  size: 30,
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
  });
}

const List<Color> signInGradients = [
  Color(0xFF0EDED2),
  Color(0xFF03A0FE),
];

const List<Color> signUpGradients = [
  Color(0xFFFF9945),
  Color(0xFFFc6076),
];
