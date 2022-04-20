import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:string_validator/string_validator.dart';
import '../../model/user.dart';
import 'product_image_view.dart';

class ProductDetail extends StatefulWidget {
  final DocumentSnapshot product;
  final User user;
  ProductDetail({@required this.product, @required this.user});

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int qty = 1;
  TextEditingController qtyController = TextEditingController();
  bool isLoading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool favourite=false;
 // String favouriteDoc='';

  Future getWishlist()async{
     var items = await Firestore.instance.collection('users').document(widget.user.userId).collection('wishlist').getDocuments();
  
       items.documents.forEach((product) {   
          if(product['productId']==widget.product.documentID){
            setState(() {
              favourite=true;
             // favouriteDoc=product.documentID;
            });
          }
       });
  }

  Future recentlyViewed()async{

    QuerySnapshot lastViewed = await Firestore.instance.collection('users').document(widget.user.userId).collection('recent').orderBy('date',descending: true).limit(1).getDocuments();
    if(lastViewed.documents.length>0){
    
       if(lastViewed.documents.first.data['title'] != widget.product.data['title']){
           Firestore.instance.collection('users').document(widget.user.userId).collection('recent').add({
                      'productId': widget.product.documentID,
                      'images':widget.product['images'],
                      'title': widget.product['title'],
                      'qty': qty,
                      'price':widget.product['price'],
                      'sellerId':widget.product['sellerId'],
                      'available':widget.product['available'],
                      'description':widget.product['description'],
                      'date':DateTime.now(),
     });
       }
    }else{
        Firestore.instance.collection('users').document(widget.user.userId).collection('recent').add({
                      'productId': widget.product.documentID,
                      'images':widget.product['images'],
                      'title': widget.product['title'],
                      'qty': qty,
                      'price':widget.product['price'],
                      'sellerId':widget.product['sellerId'],
                      'available':widget.product['available'],
                      'description':widget.product['description'],
                      'date':DateTime.now(),
     });
    }

   


  }

  @override
  void initState() {
    qtyController.text = qty.toString();
     recentlyViewed();
    getWishlist();
   
    super.initState();
  }

  void dispose() {
    qtyController.text = '1';
    qtyController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingActionButton(widget.product['available']),
      key: _scaffoldKey,
      //bottomNavigationBar: _buildBottomNavigationBar(widget.product['available']),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: Colors.black,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text("${widget.product['title']}",style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(4.0),
            child: Card(
                elevation: 4.0,
                child: Column(
                  children: <Widget>[
                    CarouselSlider.builder(
                        height: 300.0,
                        enableInfiniteScroll: true,
                        itemCount: widget.product['images'].length,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 2),
                        pauseAutoPlayOnTouch: Duration(seconds: 10),
                        enlargeCenterPage: true,
                        itemBuilder: (BuildContext context, int itemIndex) {
                          return InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductImageView(image: widget.product['images'][itemIndex],)));
                            },
                                                      child: Container(
                                  padding: EdgeInsets.all(8),
                                  width: MediaQuery.of(context).size.width,
                                  height: 800,
                                  child: CachedNetworkImage(
                                    imageUrl: widget.product['images'][itemIndex],
                                    fit: BoxFit.fill,

                                    placeholder: (context, url) => Image.asset(
                                        "assets/images/placeholder.png"),
                                  ),
                                  ),
                          );
                        }),
                    AutoSizeText(
                      widget.product['title'],
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
      
                    Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Rs. '+widget.product['price'].toString(),style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold),),
                      ],
                    ),

                    SizedBox(height: 10.0),
                    Text("Quantity:"),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 5.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              flex: 1,
                              child: IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () {
                                    setState(() {
                                      if (qty > 0) {
                                        qty--;
                                        qtyController.text = qty.toString();
                                      }
                                    });
                                  })),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: qtyController,
                              keyboardType: TextInputType.number,
                              decoration:
                                  InputDecoration(border: OutlineInputBorder()),
                              onChanged: (value) {
                                if (isNumeric(value)) {
                                  qty = int.parse(value);
                                } else {
                                  setState(() {});
                                }
                              },
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    setState(() {
                                      qty++;
                                      qtyController.text = qty.toString();
                                    });
                                  })),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 50.0,
                    ),

                    // Description
                    Text(
                      "Description",
                      style: TextStyle(fontSize: 20.0),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: AutoSizeText(
                        widget.product['description'],
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  ],
                ))),
      ),
    );
  }

  _buildBottomNavigationBar(bool available) {
    if(available){
        return Container(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      child: isLoading
          ? RaisedButton(
              onPressed: () {},
              color: Colors.teal,
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              ),
            )
          : RaisedButton(
              onPressed: () async {
                if (qty > 0) {
                  setState(() {
                    isLoading = true;
                  });

                  try {
                    await Firestore.instance
                        .collection('users')
                        .document(widget.user.userId)
                        .collection('cart')
                        .add({
                      'productId': widget.product.documentID,
                      'image':widget.product['images'][0],
                      'title': widget.product['title'],
                      'qty': qty,
                      'price':widget.product['price'],
                      'sellerId':widget.product['sellerId'],
                    });

                    setState(() {
                      isLoading = false;
                      qty = 1;
                      qtyController.text = qty.toString();
                    });
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: new Text('Item Added to Cart',
                          style: TextStyle(color: Colors.green[200])),
                      duration: Duration(seconds: 2),
                    ));
                  } catch (e) {}
                } else {
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: new Text('Quantity Required',
                        style: TextStyle(color: Colors.red[200])),
                    duration: Duration(seconds: 2),
                  ));
                }
              },
              color: Colors.teal,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      "ADD TO CART",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
    );
    }else{
      return Container(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      child: RaisedButton(
              onPressed: (){

              },
              color: Colors.grey,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      "Not Available",
                      style: TextStyle(color: Colors.white,fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
    );
    }
    
  }



   Widget floatingActionButton(bool available){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [

        if(available)...[

           isLoading
          ?  Container(
            width: 250,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.teal.shade500,
              borderRadius: BorderRadius.circular(50)
            ),
            child: Center(
              child: CircularProgressIndicator(backgroundColor: Colors.white)
            ),
          )
          :GestureDetector(
          onTap: ()async{
             if (qty > 0) {
                  setState(() {
                    isLoading = true;
                  });

                  try {
                    await Firestore.instance
                        .collection('users')
                        .document(widget.user.userId)
                        .collection('cart')
                        .add({
                      'productId': widget.product.documentID,
                      'image':widget.product['images'][0],
                      'title': widget.product['title'],
                      'qty': qty,
                      'price':widget.product['price'],
                      'sellerId':widget.product['sellerId'],
                    });

                    setState(() {
                      isLoading = false;
                      qty = 1;
                      qtyController.text = qty.toString();
                    });
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: new Text('Item Added to Cart',
                          style: TextStyle(color: Colors.green[200])),
                      duration: Duration(seconds: 2),
                    ));
                  } catch (e) {}
                } else {
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: new Text('Quantity Required',
                        style: TextStyle(color: Colors.red[200])),
                    duration: Duration(seconds: 2),
                  ));
                }
          },
          child: Container(
            width: 230,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.teal.shade500,
              borderRadius: BorderRadius.circular(50)
            ),
            child: Center(
              child: Text("Add to cart",style:TextStyle(
                fontSize: 20.0,fontWeight: FontWeight.w700,color: Colors.white
              )),
            ),
          ),
        ),

        ],
       



         FloatingActionButton(
           backgroundColor: Colors.grey[50],
              onPressed: ()async{
                if(favourite){
                   setState(() {
                    favourite=false;
                  });

                  Firestore.instance.collection('users').document(widget.user.userId).collection('wishlist').where('productId',isEqualTo: widget.product.documentID).getDocuments().then((value) => {
                    value.documents.forEach((element) {
                       Firestore.instance.collection('users').document(widget.user.userId).collection('wishlist').document(element.documentID).delete();
                    })
                  });
                 
                 

                }else{
                  setState(() {
                    favourite=true;
                  });

                   try {
                    await Firestore.instance
                        .collection('users')
                        .document(widget.user.userId)
                        .collection('wishlist')
                        .add({
                      'productId': widget.product.documentID,
                      'images':widget.product['images'],
                      'title': widget.product['title'],
                      'qty': qty,
                      'price':widget.product['price'],
                      'sellerId':widget.product['sellerId'],
                    });

                    // setState(() {
                    //   isLoading = false;
                    //   qty = 1;
                    //   qtyController.text = qty.toString();
                    // });

                  } catch (e) {}
                }

                
              
              },
              child: Icon(favourite?Icons.favorite:Icons.favorite_border,color: Colors.red,size: 30,),
            ),
      ],
    );
  }
}
