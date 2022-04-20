import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/user.dart';
import '../../bloc/accountBloc/export_account_bloc.dart';
import 'cart.dart';
import 'customer_drawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_map_location_picker/generated/i18n.dart' as location_picker;
import 'package:google_map_location_picker/google_map_location_picker.dart';

class MyAccount extends StatefulWidget {
  final User user;
   final bool navigateToCart;
  MyAccount({@required this.user,this.navigateToCart = false});
  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  TextEditingController _fullName = TextEditingController();
  TextEditingController _phoneNo = TextEditingController();
  TextEditingController _company = TextEditingController();
  TextEditingController _gstNo = TextEditingController();
  TextEditingController _address = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  LocationResult _pickedLocation;

  void saveDetails() {
    if (_formKey.currentState.validate()) {
      BlocProvider.of<AccountBloc>(context).add(UpdateDetail(
        fullName: _fullName.text,
        company: _company.text,
        gstNo: _gstNo.text,
        address: _address.text,
        userId: widget.user.userId,
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
      drawer: CustomerDrawer(user: widget.user),
      appBar: AppBar(
        title: Text("My Account"),
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
                  labelText: "Full Name",
                  icon: Icon(Icons.person)),
            ),
            // SizedBox(
            //   height: 20.0,
            // ),
            // TextFormField(
            //   validator: (value) {
            //     if (value.trim().isEmpty) {
            //       return "Field required";
            //     }
            //     return null;
            //   },
            //   controller: _company,
            //   decoration: InputDecoration(
            //       border: OutlineInputBorder(),
            //       labelText: "Company",
            //       icon: Icon(Icons.work)),
            // ),
            // SizedBox(
            //   height: 20.0,
            // ),
            // TextFormField(
            //   validator: (value) {
            //     if (value.trim().isEmpty) {
            //       return "Field required";
            //     }
            //     return null;
            //   },
            //   controller: _gstNo,
            //   decoration: InputDecoration(
            //       border: OutlineInputBorder(),
            //       labelText: "GST No",
            //       icon: Icon(Icons.local_atm)),
            // ),
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
              controller: _address,
              maxLines: 5,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Delivery Address",
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
//              FlatButton.icon(onPressed: ()async{
//                   LocationResult result = await showLocationPicker(
//                       context, "",
//                       initialCenter: LatLng(31.1975844, 29.9598339),
// //                      automaticallyAnimateToCurrentLocation: true,
// //                      mapStylePath: 'assets/mapStyle.json',
//                       myLocationButtonEnabled: true,
//                       layersButtonEnabled: true,
//                       // countries: ['AE', 'NG']

// //                      resultCardAlignment: Alignment.bottomCenter,
//                     );
//                     print("result = $result");
//                     setState(() => _pickedLocation = result);
       
//              }, icon: Icon(Icons.map), label: Text("Select Address in Map")),
//              SizedBox(
//               height: 20.0,
//             ),
//             Container(
//               height: 200,
//               width: double.infinity,
//               child: GoogleMap(initialCameraPosition: CameraPosition(target: LatLng(26.42966295763224, 91.62768479436636),zoom: 11.0,)),

//             ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: BlocListener<AccountBloc, AccountState>(
                listener: (context, state) {
                  if (state is DetailUpdatedSuccess) {
                    // Show Snackbar
                    widget.user.fullName = _fullName.text;
                    widget.user.company = _company.text;
                    widget.user.gstNo = _gstNo.text;
                    widget.user.address = _address.text;
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text('Account details Updated Successfully !'),
                      duration: Duration(seconds: 2),
                    ));
                    if(widget.navigateToCart){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyCart(user: widget.user,)));
                    }
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
                          "Update Details",
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
