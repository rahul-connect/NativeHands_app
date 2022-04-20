import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './offer_screen.dart';
import './bottom_navbar.dart';
import '../../screens/customer/product_detail.dart';
import 'package:package_info/package_info.dart';
import '../../model/user.dart';
import '../../screens/customer/cart.dart';
import '../../screens/customer/customer_drawer.dart';
import '../../bloc/homeBloc/export_home_bloc.dart';
import 'all_categories.dart';
import 'product_swipe_screen.dart';
import '../../screens/update_app.dart';
import './search_page.dart';
import 'package:shimmer/shimmer.dart';

class CustomerHomeScreen extends StatefulWidget {
  final User user;
  CustomerHomeScreen({@required this.user});

  @override
  _CustomerHomeScreenState createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
   bool updateAvailable=false;

   String searchText = "";

   List productBanner = [];

   List dunnyImages = [
     {
        'title': "",
              'image': "https://i1.wp.com/www.5randomthings.com/wp-content/uploads/2017/10/handmade-products-in-india.jpg",
              'product':null,
     },
       {
        'title': "",
              'image': "https://image.freepik.com/free-photo/close-up-handmade-gift-with-clothing-pin_23-2148370082.jpg",
              'product':null,
     },
       {
        'title': "",
              'image': "https://leewebdesign.com/wp-content/uploads/2016/11/places-to-sell-your-handmade-850x476.jpg",
              'product':null,
     },
     

   ];

    String capitalize(value) {
      return "${value[0].toUpperCase()}${value.substring(1)}";
    }

   @override
   void initState() { 
     checkUpdate();
     getBannerImages();
     super.initState();
     
   }


   Future getBannerImages()async{
     Firestore.instance.collection('products').limit(3).getDocuments().then((snapshots){
       if(snapshots.documents.length > 0){
          snapshots.documents.forEach((product) {
            productBanner.add({
              'title':product['title'],
              'image':product['images'][0],
              'product':product,

            });
           });
           setState(() {
             
           });
       }else{
         productBanner = dunnyImages;
         setState(() {
             
           });
       }
     });
   }
 
  Future<void> checkUpdate()async{
     DocumentSnapshot latestupdate = await Firestore.instance.collection('update').document('checkupdateforapp').get();
     
     String latestapp =  latestupdate['buildNumber'];

     PackageInfo packageInfo = await PackageInfo.fromPlatform();
     String currentapp = packageInfo.buildNumber;

    
      if(int.parse(latestapp) > int.parse(currentapp)){
          setState(() {
            updateAvailable = true;
          });
         
      }
    
  }


  @override
  Widget build(BuildContext context) {
    var homeBloc = BlocProvider.of<HomeBloc>(context)..add(FetchCategoryEvent());

    return updateAvailable ? UpdateAppScreen() : Scaffold(
        drawer: CustomerDrawer(user:widget.user),
      backgroundColor: Colors.grey[50],
      bottomNavigationBar: BottomNavBar(user: widget.user,screen: 'home',),
      floatingActionButton: FloatingActionButton(
         heroTag: "help",
        backgroundColor: Colors.orangeAccent,
        onPressed: (){},
        child: Icon(Icons.help_outline,size: 35,
      ),),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.orangeAccent,
        title: Text("Native Hands"),
        centerTitle: true,
         actions: <Widget>[
          IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyCart(
                  user: widget.user,
                )));
              }),
        ],
       // leading: IconButton(icon: Icon(Icons.menu), onPressed: (){}),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey[50],
          child: Column(
            children: <Widget>[

              Container(
              
                child: productBanner.length < 1 ? Shimmer.fromColors(
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.white,
                  ),
                   baseColor: Colors.grey[200],
                    highlightColor: Colors.grey[350],): CarouselSlider(
                  
                height: 200.0,
                enableInfiniteScroll: true,
                autoPlay: true,
                items:  productBanner.map((product) {
                  return Builder(
                    builder: (BuildContext context) {
                      return InkWell(
                        onTap: (){
                          product['product'] != null ? Navigator.push(context, MaterialPageRoute(builder: (ctx)=>ProductDetail(product: product['product'], user: widget.user))): print("");
                        },
                                              child: Stack(
                                                children : [
                                                  Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 4.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[200]
                            ),
                            child: CachedNetworkImage(
                              imageUrl: product['image'],
                              height: 200,
                              fit: BoxFit.fill,
                              placeholder: (context, url) => Image.asset(
                                            "assets/images/placeholder.png",height: 200,),
                              ),
                          ),
                     

                          Positioned(
                            bottom: 10,
                            left: 5,
                              child: Container(
                                constraints: BoxConstraints(
                                  maxHeight: 50,
                                  minHeight: 30,
                                  minWidth: 230,
                                  maxWidth: 270
                                ),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              // height: 30,
                              // width: 250,
                    
                              color: Colors.black.withOpacity(0.5),
                              //alignment: Alignment.bottomLeft,
                              child: AutoSizeText(
                                product['title'],
                                 maxLines: 2,
                                  minFontSize: 20,
                                  maxFontSize: 25,
                              
                              style: TextStyle(
                                color: Colors.white,
                              //  fontSize: 25
                              ),),
                            ),
                          )
                                                ]
                        ),
                      );
                    },
                  );
                }).toList(),
              )
              ),

               Container(
                 height: 140,
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: [
                      Container(
            margin: EdgeInsets.only(bottom: 10),
            width: 86,
            height: 86,
            child: FloatingActionButton(
              heroTag: "999",
              shape: CircleBorder(),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>OfferScreen(user: widget.user, amount: 999)));
              },
              backgroundColor: Colors.white,
              child: Text("UNDER\n 999",style:TextStyle(color: Colors.black,),)
            )),

             Container(
            margin: EdgeInsets.only(bottom: 10),
            width: 86,
            height: 86,
            child: FloatingActionButton(
               heroTag: "4999",
              shape: CircleBorder(),
              onPressed: (){
                 Navigator.push(context, MaterialPageRoute(builder: (_)=>OfferScreen(user: widget.user, amount: 4999)));
              },
              backgroundColor: Colors.white,
              child: Text("UNDER\n 4999",style:TextStyle(color: Colors.black),)
            )),

             Container(
            margin: EdgeInsets.only(bottom: 10),
            width: 86,
            height: 86,
            child: FloatingActionButton(
               heroTag: "9999",
              shape: CircleBorder(),
              onPressed: (){
                 Navigator.push(context, MaterialPageRoute(builder: (_)=>OfferScreen(user: widget.user, amount: 9999)));
              },
              backgroundColor: Colors.white,
              child: Text("UNDER\n 9999",style:TextStyle(color: Colors.black),)
            )),


                   ],
                 )
               ),

            

              headerTopCategories(),

              // Latest Deals

               Container(
                 alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(left: 15, top: 0),
        child: Text("Recently Viewed", style: TextStyle(
    color: Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    fontFamily: 'Poppins')),
      ),

      SizedBox(height: 20.0,),

      Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        height: 200.0,
        child: StreamBuilder(
          stream: Firestore.instance.collection('users').document(widget.user.userId).collection('recent').orderBy('date',descending: true).limit(8).snapshots(),
          builder: (context,snapshot){
            if(snapshot.hasData){
              if(snapshot.data.documents.length < 1){
                return Center(
                  child: Text("No Products to show"),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                scrollDirection: Axis.horizontal,
               shrinkWrap: true,
               physics: BouncingScrollPhysics(),
                itemBuilder: (context,index){
                  var product = snapshot.data.documents[index];

                  return InkWell(
                    onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (ctx)=>ProductDetail(product: product, user: widget.user)));
                    },
                                      child: Container(
      width: 170.0,
      height: 180,
      padding: EdgeInsets.all(0),
      margin: EdgeInsets.only(right: 15.0),
      decoration: BoxDecoration(
         color: Colors.white,
         borderRadius: BorderRadius.circular(15.0),

      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
        
          Expanded(child: Center(
            child: CachedNetworkImage(
                            imageUrl: product['images'][0],
                            height: 200,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Image.asset(
                                          "assets/images/placeholder.png",height: 200,),
                            ), 
            
          )),

          ListTile(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (ctx)=>ProductDetail(product: product, user: widget.user)));
            },
            title: Text(product['title'],overflow: TextOverflow.ellipsis,style: TextStyle(
              fontSize: 15.0,
  fontWeight: FontWeight.bold,
  color: Color(0xFF232323),
            ),),
            subtitle:  Text("Rs. ${product['price']}",style:  TextStyle(
        fontSize: 15.0,
  color: Color(0xFFB2B4C1),
            ),),
          ),
          
        ],
      ),
      
    ),
                  );
                });
            }
            return CircularProgressIndicator();

          }),
      ),

      SizedBox(height: 30.0,)

            ],
          ),
        ),
      ),

      
    );
  }
 
  
  Future<String> getCatImage(docId)async{

    QuerySnapshot fetchdata=  await Firestore.instance.collection('products').where('category',isEqualTo: docId.documentID).limit(1).getDocuments();
    fetchdata.documents.forEach((element) { 
        // print(docId['title']);
        // print(element.data['images'][0]);
        Firestore.instance.collection('category').document(docId.documentID).updateData({
          'icon':element.data['images'][0]
        });
    });
  }

  Widget headerTopCategories() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      sectionHeader('Categories', onViewMore: () {
        Navigator.push(context, MaterialPageRoute(builder: (ctx)=>AllCategories(user:widget.user )));
      }),
      Container(
        color:  Colors.grey[50],
        height: 140,
        child: FutureBuilder(
          future: Firestore.instance.collection('category').getDocuments(),
          builder: (context,snapshot){
            if(snapshot.hasData){
              if(snapshot.data.documents.length < 1){
                return Center(
                  child: Text("No Categories"),
                );

              }
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context,index) {
                  var cat = snapshot.data.documents[index];
                  if(cat["icon"]==''){

                      getCatImage(cat);
                 
                  }
                  return headerCategoryItem(cat['title'], cat['icon'], onPressed: () {

                    // navugate using cat.documentID
                    Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => BlocProvider<HomeBloc>(
                                  create: (context) => HomeBloc()
                                    ..add(FetchCategoryProducts(
                                        category: cat.documentID
                                            )),
                                  child: ProductSwipeScreen(
                                    user: widget.user,
                                    title:cat['title'],
                                  ))));
                  });
              
                }
                );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          })
        
        
      )
    ],
  );
}

Widget headerCategoryItem(String name, String catImage, {onPressed}) {
  return Container(
    margin: EdgeInsets.only(left: 4,right: 5),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(bottom: 10,left: 10),
            width: 86,
            height: 86,
            child: GestureDetector(
            //   shape: CircleBorder(),
            //  heroTag: name,
              onTap: onPressed,
           //   backgroundColor: Colors.white,
              child: catImage!=''? ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                              child: CachedNetworkImage(

                  fit: BoxFit.fill,
                  imageUrl:  
                  catImage,
                  //height: 50,width: 50,
                  placeholder: (context,url)=> SizedBox( height:150,child: Center(child: CircularProgressIndicator(),)),
                  ),
              ):Icon(Icons.category,size: 50,color: Colors.black,),
            )),
        Text(name + ' ›', style: TextStyle(
    color: Color(0xff444444),
    fontWeight: FontWeight.w700,
    fontFamily: 'Poppins'))
      ],
    ),
  );
}


Widget sectionHeader(String headerTitle, {onViewMore}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(
        margin: EdgeInsets.only(left: 15, top: 10),
        child: Text(headerTitle, style: TextStyle(
    color: Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    fontFamily: 'Poppins')),
      ),
      Container(
        margin: EdgeInsets.only(left: 15, top: 2),
        child: FlatButton(
          onPressed: onViewMore,
          child: Text('View all ›', style: TextStyle(
    color: Color(0xff444444),
    fontWeight: FontWeight.w700,
    fontFamily: 'Poppins')),
        ),
      )
    ],
  );
}


}
