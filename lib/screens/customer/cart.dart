import 'dart:convert';
import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import './razor_pay_keys.dart';
import '../../model/user.dart';
import '../../bloc/cartBloc/export_cart_bloc.dart';
import 'my_account.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http_auth/http_auth.dart' as http_auth;
import 'package:crypto/crypto.dart';



class MyCart extends StatefulWidget {
  final User user;
  MyCart({@required this.user});
  @override
  _MyCartState createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {

  bool cartEmpty = true;
  int totalAmount = 0;
  
  Razorpay _razorpay;
  String order_id='';
  bool loading =false;

  String selectedPayment;
  List<DropdownMenuItem> paymentOption = [
   DropdownMenuItem(child: Text('Cash on Delivery'),value: 'cash', ),
  // DropdownMenuItem(child: Text('Online Payment'),value: 'online', ),
];

  


  String rapzorpay_paymentId='';
  String razorpay_orderId='';
  String razorpay_signature;


  @override
  void initState() {
      selectedPayment = paymentOption[0].value;
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  void _handlePaymentError(PaymentFailureResponse response){
    print(response.code);
    if(response.code.toString()=='1'){
      // Some response code for Network Error
    }else if(response.code.toString()=='2'){
     // Payment Cancelled
     
    }
     setState(() {
        loading = false;
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>MyCart(user: widget.user,)));
}
void _handlePaymentSuccess(PaymentSuccessResponse response){
  // var bytes1 = utf8.encode(response.orderId);
  // Digest digest1 = sha256.convert(bytes1);
  // var bytes2 = utf8.encode(response.paymentId);
  // Digest digest2 = sha256.convert(bytes2);
  // var generated_signature  = Hmac(sha256,[int.parse(razorpay_secret)]);

  // if (generated_signature == response.signature) {
  //   print("payment is successful");
  // }

  rapzorpay_paymentId = response.paymentId;
  razorpay_orderId = response.orderId;
  razorpay_signature = response.signature;

}


void _handleExternalWallet(ExternalWalletResponse response){
  print('Wallet Name '+ response.walletName);
}

getTotalAmount()async{
  var finalAmount=0;

  var value = await Firestore.instance.collection('users').document(widget.user.userId).collection('cart').getDocuments();
    for(var product in value.documents){
              int productPrice = product['price'] * product['qty'];
              finalAmount += productPrice;
              }
            
              return finalAmount;
              

}

Future<String> getOrderID() async{
  int getFinalAmount = await getTotalAmount();
  var recieptId = Random().nextInt(8);
 var value = await Firestore.instance.collection('users').document(widget.user.userId).collection('cart').getDocuments();
    for(var product in value.documents){
              int productPrice = int.parse(product['price']) * product['qty'];
              totalAmount += productPrice;
              }

  var url = 'https://api.razorpay.com/v1/orders/';
    var data = {
  'amount': (getFinalAmount * 100).toString(),
  'currency': 'INR',
  'receipt': 'rcptid #'+recieptId.toString(),
  'payment_capture': '1',
};

      var client = http_auth.BasicAuthClient(razorpaykey, razorpaySecret);
      var response = await client.post(url,body: data);
      var reponse = json.decode(response.body);
      print(response.body);
      print("AMount: $totalAmount");
      return reponse['id'];

}

  Future launchPayment() async {
  var options = {
  'key': razorpaykey,
  'amount': totalAmount * 100,
  'name': 'Mandi Essentials',
  'description': 'Pay to Mandi Essentials',
  "currency": "INR",
  "order_id": "$order_id",
  'prefill': {
  "name": "${widget.user.fullName}",
  "email": "example@gmail.com",
  'contact': '${widget.user.phoneNo}',
  },
  'method': { 'netbanking': true, 'card': true, 'wallet': false, 'upi': true },
  'external': {
  'wallets': []
  }
  };
  try{
  _razorpay.open(options);

  while(rapzorpay_paymentId.isEmpty){
    await Future.delayed(Duration(seconds: 1));
  }

  }catch(e){
  debugPrint(e);
  return;
  }
  }


  @override
  void dispose() { 
    _razorpay.clear();
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
     final cartBloc = BlocProvider.of<CartBloc>(context)..add(FetchCartItems(userId: widget.user.userId));
  
     GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
     
      key: _scaffoldKey,
      bottomNavigationBar: _buildBottomNavigationBar(cartBloc,_scaffoldKey,widget.user),
      //drawer: CustomerDrawer(user: widget.user,),
      appBar: AppBar(
        backgroundColor: Color(0xFFFAFAFA),
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF3a3737),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        title:Text("My Cart",style: TextStyle(color: Colors.black),),
        centerTitle:true,
        // bottom: PreferredSize(child: Column(
        //   children: [
        //     Row(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
               
        //         FlatButton.icon(onPressed: (){
                
        //           launch("tel://9986550777");
        //         }, icon:Text("For any Enquiry :",style: TextStyle(color: Colors.black),), label: Text("9986550777",style: TextStyle(color: Colors.black),)),
              
        //       ],
        //     ),
        //   ],
        // ), preferredSize: Size.fromHeight(25.0)),
      ),
      body: BlocListener<CartBloc,CartState>(
        listener: (context,state){
          if(state is ItemRemovedSucess){
            Scaffold.of(context).showSnackBar(SnackBar(content: Text('Item removed Successfully !'),duration: Duration(seconds: 2),));
          }else if(state is OrderNowSuccess){
            Scaffold.of(context).showSnackBar(SnackBar(content: Text('Order Placed Successfully !'),duration: Duration(seconds: 3),));
          }
        },
              child: BlocBuilder<CartBloc,CartState>(builder: (context,state){
          if(state is CartInitial){
            return Center(
              child: CircularProgressIndicator(),
            );
          }else if(state is ItemsFetchedSuccess){
            return StreamBuilder(
              stream: state.cartItems,
              builder: (context,snapshot){
                if(snapshot.hasData){
              
                  if(snapshot.data.documents.length == 0){
                    cartEmpty = true;
                    return Center(
                      child: Text("Cart is Empty",style: TextStyle(fontSize: 30.0),),
                    );
                  }

                  cartEmpty = false;
                 
                  return loading?Center(child: CircularProgressIndicator(),) : Container(
                     padding: EdgeInsets.all(15),
                      
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                                                  child: ListView.builder(
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (context,index){
                              var item = snapshot.data.documents[index];

                              return CartItem(
                              
                                productName: item['title'],
                                 productPrice: item['price'],
                                  productImage: item['image'],
                                   productCartQuantity: item['qty'],
                                   userID: widget.user.userId,
                                   documentID: item.documentID,
                                   cartBloc:cartBloc,
                                  
                                   );

                            
                        
                          }),
                        ),
                SizedBox(
                  height: 10,
                ),
                TotalCalculationWidget(userId: widget.user.userId, totalAmount: totalAmount,),

                // SizedBox(
                //   height: 10,
                // ),
                // Container(
                //   padding: EdgeInsets.only(left: 5),
                //   child: Text(
                //     "Payment Method",
                //     style: TextStyle(
                //         fontSize: 20,
                //         color: Color(0xFF3a3a3b),
                //         fontWeight: FontWeight.w600),
                //     textAlign: TextAlign.left,
                //   ),
                // ),
                // SizedBox(
                //   height: 10,
                // ),
                PaymentMethodWidget(),
                      ],
                    ),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
            });
          }else if(state is OrderingState){
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(height: 20.0,),
                  Text("Wait while your order is being placed"),
                ],
              ),
            );
          }else if(state is OrderNowSuccess){
            cartEmpty = true;

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: Lottie.asset('animations/success-tick.json'),
                  ),
                  //Icon(Icons.thumb_up,size: 50.0,color: Colors.orange,),
                  SizedBox(height: 20.0,),
                  Text("Thank you for shopping with us"),
                  SizedBox(height: 20.0,),
                  //Text("Order will be Delivered within 2-4 hrs"),
                ],
              ),
            );
          }else{
            return Center(
              child: Text("ERROR --- Unknown bloc State"),
            );
          }
        }),
      ),
      
    );
  }

    _buildBottomNavigationBar(Bloc cartBloc,_scaffoldKey,User user) {
    return Container(
      
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      child: RaisedButton(
        onPressed: () async{
          var finalTotalAmount = await getTotalAmount();
        
          if(user.address.trim() !=''){
                    if(user.fullName.trim() == ''){
                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyAccount(user: user,navigateToCart: true,)));
                       return;
                    }
                     if(!cartEmpty){
                       // Change minimun Order amount to 500 after testing payment
                       if(finalTotalAmount < 500 && widget.user.role=='customer'){
                          _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Minimum Order Amount Rs.500 !'),duration: Duration(seconds: 3),));
                       }else if(selectedPayment=='cash'){
                          cartBloc.add(OrderNowPressed(userId: widget.user.userId,totalAmount: finalTotalAmount.toString(),orderId:razorpay_orderId,paymentId: rapzorpay_paymentId,paymentMode: "cash"));
                        }else{
                             setState(() {
                         loading =true;
                       });
                      order_id =  await getOrderID();
                     // print("Order ID : $order_id");
                      if(order_id != null){
                         await launchPayment();
                        if(razorpay_orderId.isNotEmpty && rapzorpay_paymentId.isNotEmpty){
                        // setState(() {
                        //   loading = false;
                        // });
                        cartBloc.add(OrderNowPressed(userId: widget.user.userId,totalAmount: finalTotalAmount.toString(),orderId:razorpay_orderId,paymentId: rapzorpay_paymentId,paymentMode: "online"));
                      }else{
                        print("Payment Id and order Id null ERROR");
                      }
                      }else{
                        print("Order id ERROR");
                      }
                    
                        }
                    

          }else{
            _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Add atleast one product !'),duration: Duration(seconds: 3),));
          }
          }else{
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyAccount(user: user,navigateToCart: true,)));
          }
          
        },
        color: Color(0xFF3EA653),
         child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
           children: <Widget>[
              Icon(
              Icons.shopping_basket,
              color: Colors.white,
              size: 28,
            ),
            SizedBox(
              width: 10.0,
            ),

             Text(
                  "Order Now",
                  style: TextStyle(color: Colors.white,fontSize: 23.0),
                ),
           ],
         ), 
  // Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //         DropdownButton(
  //   value: selectedPayment,
  //   iconEnabledColor: Colors.white,
  //   style: TextStyle(
  //      color: Colors.black87,
  //     fontSize: 16.0,
  //     fontWeight: FontWeight.bold
  //   ),
  //   underline: Container(
  //     height: 1,
  //     color: Colors.white,
  //   ),
  //   onChanged: (newValue) {
  //     setState(() {
  //       selectedPayment = newValue;
  //     });
  //   },
  //   items: paymentOption,
  // ),
  // SizedBox(width: 25.0,),
  // Column(
  //   mainAxisAlignment: MainAxisAlignment.center,
  //   crossAxisAlignment: CrossAxisAlignment.center,
  //   children: <Widget>[

  //       Row(
  //         children: <Widget>[
  //              Icon(
  //             Icons.shopping_basket,
  //             color: Colors.white,
  //             size: 18,
  //           ),
  //           SizedBox(
  //             width: 5.0,
  //           ),
  //           Text(
  //             "Order Now",
  //             style: TextStyle(color: Colors.white,fontSize: 18.0),
  //           ), 
  //         ],
  //       ),

  //   ],
  // ),


        
  //         ],
  //       ),

      ),
    );
  }


}



// New Ui 



class PaymentMethodWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color(0xFFfae3e2).withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 1,
          offset: Offset(0, 1),
        ),
      ]),
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 10, right: 30, top: 10, bottom: 10),
          child: Row(
            children: <Widget>[

              Container(
                alignment: Alignment.center,
                child: Image.asset('assets/images/debit_card.png')
              ),
              SizedBox(width: 8,),
              Text(
                "Cash on Delivery",
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF3a3a3b),
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.left,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TotalCalculationWidget extends StatefulWidget {
   String userId;
   int totalAmount;

   TotalCalculationWidget({Key key, this.userId, this.totalAmount}) : super(key: key);

  @override
  _TotalCalculationWidgetState createState() => _TotalCalculationWidgetState();
}

class _TotalCalculationWidgetState extends State<TotalCalculationWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color(0xFFfae3e2).withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 1,
          offset: Offset(0, 1),
        ),
      ]),
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 25, right: 30, top: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Total",
                style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF3a3a3b),
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              ),
               StreamBuilder(
          stream: Firestore.instance.collection('users').document(widget.userId).collection('cart').snapshots(),
          builder: (context,snapshot){
            if(snapshot.hasData){
            
              widget.totalAmount=0;
              for(var product in snapshot.data.documents){
              int productPrice = product['price'] * product['qty'];
              widget.totalAmount += productPrice;
              }
              return  Text(
                "Rs. ${widget.totalAmount}",
                style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF3a3a3b),
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              );
            } 
            return SizedBox.shrink();
          }
          
          ),
           
            ],
          ),
        ),
      ),
    );
  }
}

class PromoCodeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(left: 3, right: 3),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Color(0xFFfae3e2).withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ]),
        child: TextFormField(
          decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFe6e1e1), width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFe6e1e1), width: 1.0),
                  borderRadius: BorderRadius.circular(7)),
              fillColor: Colors.white,
              hintText: 'Add Your Promo Code',
              filled: true,
              suffixIcon: IconButton(
                  icon: Icon(
                    Icons.local_offer,
                    color: Color(0xFFfd2c2c),
                  ),
                  onPressed: () {
                    debugPrint('222');
                  })),
        ),
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  String productName;
  int productPrice;
  String productImage;
  int productCartQuantity;
  String documentID;
  String userID;
  var cartBloc;

  CartItem({
    Key key,
    @required this.productName,
    @required this.productPrice,
    @required this.productImage,
    @required this.productCartQuantity,
    @required this.documentID,
    @required this.userID,
    @required this.cartBloc
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color(0xFFfae3e2).withOpacity(0.3),
          spreadRadius: 1,
          blurRadius: 1,
          offset: Offset(0, 1),
        ),
      ]),
      child: Card(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Center(
                        child: CachedNetworkImage(
                imageUrl:  
                productImage?? 'https://icon-library.com/images/no-picture-available-icon/no-picture-available-icon-1.jpg',
                height: 110,
                width: 110,
                placeholder: (context,url)=> SizedBox( height:150,child: Center(child: CircularProgressIndicator(),)),
                ),
                        
                      
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        SizedBox(width: 20,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 130.0,
                              child: AutoSizeText( 
                                "$productName",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                maxFontSize: 17,
                                minFontSize: 17,
                      
                                style: TextStyle(
                  
                                    color: Color(0xFF3a3a3b),
                                    fontWeight: FontWeight.w400
                                    ),
                                     textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              child: Text(
                                "Rs. $productPrice",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFF3a3a3b),
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        InkWell(
                          onTap: (){
                             cartBloc.add(RemoveItem(cartItemId: documentID,userId: userID));
                          },
                                                  child: Container(
                            alignment: Alignment.centerRight,
                            child: Image.asset('assets/images/ic_delete.png',width: 25,height: 25,),
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      alignment: Alignment.centerRight,
                      child: AddToCartMenu(productCartQuantity,documentID,userID),
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }
}


class AddToCartMenu extends StatelessWidget {
  int productCounter;
  String itemID;
  String userID;

  AddToCartMenu(this.productCounter,this.itemID,this.userID);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            onPressed: () {
              if(productCounter > 1){
                  Firestore.instance.collection('users').document(userID).collection('cart').document(itemID).updateData({
                'qty': productCounter - 1,
              });
              }
 

            },
            icon: Icon(Icons.remove),
            color: Colors.black,
            iconSize: 18,
          ),
          InkWell(
            onTap: () => print('hello'),
            child: Container(
              width: 60.0,
              height: 35.0,
              decoration: BoxDecoration(
                color: Color(0xFFfd2c2c),
                border: Border.all(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Center(
                child: Text(
                  ' $productCounter ',
                  style: new TextStyle(
                      fontSize: 12.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
                 Firestore.instance.collection('users').document(userID).collection('cart').document(itemID).updateData({
                'qty': productCounter + 1,
              });
            },
            icon: Icon(Icons.add),
            color: Color(0xFFfd2c2c),
            iconSize: 18,
          ),
        ],
      ),
    );
  }
}