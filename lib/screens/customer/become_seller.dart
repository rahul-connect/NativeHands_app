import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/accountBloc/export_account_bloc.dart';
import '../../model/user.dart';


class BecomeSellerScreen extends StatefulWidget {
   final User user;
   BecomeSellerScreen({@required this.user});
  @override
  _BecomeSellerScreenState createState() => _BecomeSellerScreenState();
}

class _BecomeSellerScreenState extends State<BecomeSellerScreen> {
    TextEditingController _fullName = TextEditingController();
  TextEditingController _phoneNo = TextEditingController();
  TextEditingController _company = TextEditingController();
  TextEditingController _gstNo = TextEditingController();
  TextEditingController _address = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void saveDetails() {
    if (_formKey.currentState.validate()) {
      BlocProvider.of<AccountBloc>(context).add(UpdateDetail(
        fullName: _fullName.text,
        company: _company.text,
        gstNo: _gstNo.text,
        address: _address.text,
        userId: widget.user.userId,
        becomeSeller: true,
      ));
    }
  }

  @override
  void initState() {
    _fullName.text = widget.user.fullName;
    _phoneNo.text = widget.user.phoneNo;
    _company.text = widget.user.company;
    _gstNo.text = widget.user.gstNo;
    _address.text = widget.user.address;

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title:Text("Become a Seller"),
        centerTitle: true,
      ),
       body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(30),
          children: <Widget>[
            TextFormField(
              validator: (value) {
                if (value.trim().isEmpty) {
                  return "Field required";
                }
                return null;
              },
              controller: _fullName,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Owner Name",
                  icon: Icon(Icons.person)),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              validator: (value) {
                if (value.trim().isEmpty) {
                  return "Field required";
                }
                return null;
              },
              controller: _company,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Shop Name",
                  icon: Icon(Icons.work)),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              controller: _gstNo,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "GST No. (optional)",
                  icon: Icon(Icons.local_atm)),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              controller: _address,
              maxLines: 5,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Shop Address",
                  icon: Icon(Icons.home)),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              enabled: false,
              controller: _phoneNo,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Phone",
                enabled: false,
                icon: Icon(Icons.phone),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: BlocListener<AccountBloc, AccountState>(
                listener: (context, state) {
                  if (state is DetailUpdatedSuccess){
                    // Show Snackbar
                    widget.user.fullName = _fullName.text;
                    widget.user.company = _company.text;
                    widget.user.gstNo = _gstNo.text;
                    widget.user.address = _address.text;

                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text('You are a Seller Now!'),
                      duration: Duration(seconds: 2),
                    ));
                    Future.delayed(Duration(seconds: 2)).then((_){
                      Navigator.pop(context);
                      Navigator.of(context).pushReplacementNamed('/auth');
                    });
                    
    
                  }
                },
                child: BlocBuilder<AccountBloc, AccountState>(
                  builder: (context, state) {
                    if (state is AccountInitial) {
                      return FlatButton(
                        onPressed: () {
                          saveDetails();
                        },
                        child: Text(
                          "Submit",
                          style: TextStyle(fontSize: 20.0, color: Colors.white),
                        ),
                        color: Colors.teal,
                      );
                    } else if (state is DetailUpdating) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}