
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../model/user.dart';
import 'bottom_navbar.dart';
import 'cart.dart';
import 'customer_drawer.dart';
import 'product_detail.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';


class OfferScreen extends StatefulWidget {
  final User user;
  final int amount;
  OfferScreen({@required this.user,@required this.amount});

  @override
  _OfferScreenState createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {

  CardController controller;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
     
     key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.black,), onPressed: (){
          Navigator.pop(context);
        }),
        backgroundColor: Colors.transparent,
        title: Text("Under ${widget.amount}",style: TextStyle(color: Colors.black),),
        centerTitle: true,
        elevation: 0,
        actions: <Widget>[
          Stack(
            children: [
              IconButton(
              icon: Icon(Icons.shopping_cart,color: Colors.black,),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyCart(
                  user: widget.user,
                )));
              }),
      new Positioned(
        right: 10,
        top: 5,
        child: new Container(
          padding: EdgeInsets.all(1),
          decoration: new BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(6),
          ),
          constraints: BoxConstraints(
            minWidth: 14,
            minHeight: 14,
          ),
          child: StreamBuilder(
            stream:   Firestore.instance.collection('users').document(widget.user.userId).collection('cart').snapshots(),
            builder: (context,AsyncSnapshot snapshot){
              if(snapshot.data!=null){
                  return  Text(
            '${snapshot.data.documents.length}',
            style: new TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          );
              }
              return Text("");
            
            },
          ),
          
        
        ),
      )
            ],
          ),
          // IconButton(
          //     icon: Icon(Icons.shopping_cart,color: Colors.black,),
          //     onPressed: () {
          //       Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyCart(
          //         user: widget.user,
          //       )));
          //     }),



        ],
      ),
      body: FutureBuilder(
              future: Firestore.instance.collection('products').where('price',isLessThan: widget.amount).getDocuments(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                   if(snapshot.data.documents.length < 1){
                     return Center(
                       child: Text("No Product Available"),
                     );
                   }
                  return                       
                   GridView.builder(
                      padding: EdgeInsets.all(10),
                      itemCount: snapshot.data.documents.length,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 300.0,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10,
                        childAspectRatio: 640 / 978
                           // MediaQuery.of(context).size.height / 978,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: InkWell(
                            onTap: () async {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) {
                                 
                                  return  ProductDetail(
                                  product: snapshot.data.documents[index],
                                  user: widget.user,
                                );
                                }
                              ));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8.0),
                                      topRight: Radius.circular(8.0),
                                    ),
                                    child: CachedNetworkImage(
                                        imageUrl: snapshot.data.documents[index]
                                            ['images'][0],
                                        height: 150,
                                        fit: BoxFit.fill,
                                        // placeholder: (context,url)=> Image.asset("assets/images/placeholder.png"),
                                        placeholder: (context,url)=> SizedBox( height:150,child: Center(child: CircularProgressIndicator(),)),
                                        ),
                                        
                                        ),
                                SizedBox(height: 10),
                                SizedBox(
                                  height: 30,
                                  child: AutoSizeText(
                                    snapshot.data.documents[index]['title'],
                                    maxLines: 2,
                                    minFontSize: 13.0,
                                    maxFontSize: 16,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                               SizedBox(height: 6),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: RaisedButton(
                                      color: Colors.orangeAccent,
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductDetail(
                                                      product: snapshot.data
                                                          .documents[index],
                                                          user: widget.user,
                                                    )));
                                      },
                                      child: Text(
                                        "View",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                )
                              ],
                            ),
                          ),
                        );
                      });



                }

                return Center(child: CircularProgressIndicator());
              })
  
    );
  }
}
