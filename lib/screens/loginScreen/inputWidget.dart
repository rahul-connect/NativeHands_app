import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  final double topRight;
  final double bottomRight;
  final TextEditingController _phoneInput;

  InputWidget(this.topRight, this.bottomRight,this._phoneInput);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 40, bottom: 30),
      child: Container(
        width: MediaQuery.of(context).size.width - 40,
        child: Material(
          elevation: 10,
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(bottomRight),
                  topRight: Radius.circular(topRight))),
          child: Padding(
            padding: EdgeInsets.only(left: 40, right: 20, top: 10, bottom: 10),
            child: TextField(

              controller: _phoneInput,
              decoration: InputDecoration(
                prefix: Text('+91',style: TextStyle(color:Colors.black),),
                border: InputBorder.none,
                hintText: "Type here.......",
                hintStyle: TextStyle(color: Color(0xFFE1E1E1), fontSize: 14),
              ),
              keyboardType: TextInputType.phone,
            ),
          ),
        ),
      ),
    );
  }
}
