import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/user.dart';
import 'cart.dart';
import 'product_detail.dart';
import '../../bloc/homeBloc/export_home_bloc.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';


class ProductSwipeScreen extends StatefulWidget {
  final User user;
  final title;
  ProductSwipeScreen({@required this.user,this.title});

  @override
  _ProductSwipeScreenState createState() => _ProductSwipeScreenState();
}

class _ProductSwipeScreenState extends State<ProductSwipeScreen> {

  CardController controller;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
     // drawer: CustomerDrawer(user:widget.user),
     key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios,color: Colors.black,), onPressed: (){
          Navigator.pop(context);
        }),
        title: Text("${widget.title}",style: TextStyle(color: Colors.black),),
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
      body: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
        if (state is HomeInitialState) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Loading Products...",
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
          );
        } else if (state is ProductsFetchedSuccess) {
          return StreamBuilder(
              stream: state.allProducts,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                   if(snapshot.data.documents.length < 1){
                     return Center(
                       child: Text("No Product Available"),
                     );
                   }
                  return Center(
          child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              child: new TinderSwapCard(
                
                  swipeUp: false,
                  swipeDown: false,
                  orientation: AmassOrientation.LEFT,
                  totalNum: snapshot.data.documents.length,
                  stackNum: 3,
                  swipeEdge: 4.0,
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                  maxHeight: MediaQuery.of(context).size.height,
                  minWidth: MediaQuery.of(context).size.width * 0.8,
                  minHeight: MediaQuery.of(context).size.width * 0.8,
                  cardBuilder: (context, index) => InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>ProductDetail(product: snapshot.data.documents[index], user: widget.user)));
                    },
                                      child: Card(
                       
                          child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Expanded(
                                       child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8.0),
                                          topRight: Radius.circular(8.0),
                                        ),
                                        child: CachedNetworkImage(
                                            imageUrl: snapshot.data.documents[index]
                                                ['images'][0],
                                          //  height: 220,
                                            fit: BoxFit.fill,
                                            // placeholder: (context,url)=> Image.asset("assets/images/placeholder.png"),
                                            placeholder: (context,url)=> SizedBox( height:150,child: Center(child: CircularProgressIndicator(),)),
                                            ),
                                            
                                            ),
                                  ),
                                  SizedBox(height: 10),
                                  SizedBox(
                                    height: 30,
                                    child: AutoSizeText(
                                      snapshot.data.documents[index]['title'],
                                      maxLines: 2,
                                      minFontSize: 14.0,
                                      maxFontSize: 20,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.bold,),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                   Center(child: Text('Rs. '+snapshot.data.documents[index]['price'].toString(),style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),)),
                                   SizedBox(height: 10),
                                ],
                              ),
                        ),
                  ),
                  cardController: controller = CardController(),
                  swipeUpdateCallback:
                      (DragUpdateDetails details, Alignment align) {
                    /// Get swiping card's alignment
                    if (align.x < 0) {
                      //Card is LEFT swiping  
                    } else if (align.x > 0) {
                      //Card is RIGHT swiping
                    }
                
                  },
                  swipeCompleteCallback:
                      (CardSwipeOrientation orientation, int index) async{
                    /// Get orientation & index of swiped card!
                        if(orientation==CardSwipeOrientation.RIGHT){
                           
                             try {
                    await Firestore.instance
                        .collection('users')
                        .document(widget.user.userId)
                        .collection('cart')
                        .add({
                      'productId':  snapshot.data.documents[index].documentID,
                      'image': snapshot.data.documents[index]['images'][0],
                      'title':  snapshot.data.documents[index]['title'],
                      'qty': 1,
                      'price': snapshot.data.documents[index]['price'],
                      'sellerId': snapshot.data.documents[index]['sellerId'],
                    });

                
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: new Text('Item Added to Cart',
                          style: TextStyle(color: Colors.green[200])),
                      duration: Duration(seconds: 2),
                    ));

                  } catch (e) {}

                  
                        }else if(orientation==CardSwipeOrientation.LEFT){
                            print("Swiped Left");
                        }else if(orientation==CardSwipeOrientation.RECOVER){

                        }
                  },
              ),
          ),
      );
                  
                  
                  
                  
                  //  GridView.builder(
                  //     padding: EdgeInsets.all(10),
                  //     itemCount: snapshot.data.documents.length,
                  //     gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  //       maxCrossAxisExtent: 300.0,
                  //       mainAxisSpacing: 10.0,
                  //       crossAxisSpacing: 10,
                  //       childAspectRatio: 640 / 978
                  //          // MediaQuery.of(context).size.height / 978,
                  //     ),
                  //     itemBuilder: (BuildContext context, int index) {
                  //       print(MediaQuery.of(context).size.height);
                  //       return Card(
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(8.0),
                  //         ),
                  //         child: InkWell(
                  //           onTap: () {
                  //             Navigator.of(context).push(MaterialPageRoute(
                  //               builder: (context) => ProductDetail(
                  //                 product: snapshot.data.documents[index],
                  //                 user: widget.user,
                  //               ),
                  //             ));
                  //           },
                  //           child: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.stretch,
                  //             children: <Widget>[
                  //               ClipRRect(
                  //                   borderRadius: BorderRadius.only(
                  //                     topLeft: Radius.circular(8.0),
                  //                     topRight: Radius.circular(8.0),
                  //                   ),
                  //                   child: CachedNetworkImage(
                  //                       imageUrl: snapshot.data.documents[index]
                  //                           ['images'][0],
                  //                       height: 150,
                  //                       fit: BoxFit.fill,
                  //                       // placeholder: (context,url)=> Image.asset("assets/images/placeholder.png"),
                  //                       placeholder: (context,url)=> SizedBox( height:150,child: Center(child: CircularProgressIndicator(),)),
                  //                       ),
                                        
                  //                       ),
                  //               SizedBox(height: 10),
                  //               SizedBox(
                  //                 height: 30,
                  //                 child: AutoSizeText(
                  //                   snapshot.data.documents[index]['title'],
                  //                   maxLines: 2,
                  //                   minFontSize: 13.0,
                  //                   maxFontSize: 16,
                  //                   overflow: TextOverflow.ellipsis,
                  //                   textAlign: TextAlign.center,
                  //                 ),
                  //               ),
                  //               SizedBox(height: 6),
                  //               Padding(
                  //                 padding: const EdgeInsets.symmetric(
                  //                     horizontal: 8.0),
                  //                 child: RaisedButton(
                  //                     color: Colors.teal,
                  //                     onPressed: () {
                  //                       Navigator.of(context).push(
                  //                           MaterialPageRoute(
                  //                               builder: (context) =>
                  //                                   ProductDetail(
                  //                                     product: snapshot.data
                  //                                         .documents[index],
                  //                                         user: widget.user,
                  //                                   )));
                  //                     },
                  //                     child: Text(
                  //                       "View",
                  //                       style: TextStyle(color: Colors.white),
                  //                     )),
                  //               )
                  //             ],
                  //           ),
                  //         ),
                  //       );
                  //     });



                }

                return Center(child: CircularProgressIndicator());
              });
        } else {
          return Text("Something Went Wrong ! ERROR.");
        }
      }),
    );
  }
}
