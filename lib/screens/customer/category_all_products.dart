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


class CategoryProductScreen extends StatefulWidget {
  final User user;
  final title;
  CategoryProductScreen({@required this.user,this.title});

  @override
  _CategoryProductScreenState createState() => _CategoryProductScreenState();
}

class _CategoryProductScreenState extends State<CategoryProductScreen> {

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
                        print(MediaQuery.of(context).size.height);
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProductDetail(
                                  product: snapshot.data.documents[index],
                                  user: widget.user,
                                ),
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
              });
        } else {
          return Text("Something Went Wrong ! ERROR.");
        }
      }),
    );
  }
}
