import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info/package_info.dart';
import 'package:shimmer/shimmer.dart';
import '../../model/user.dart';
import '../../screens/customer/cart.dart';
import '../../screens/customer/customer_drawer.dart';
import '../../bloc/homeBloc/export_home_bloc.dart';
import '../../screens/update_app.dart';
import './category_all_products.dart';

class AllCategories extends StatefulWidget {
  final User user;
  AllCategories({@required this.user});

  @override
  _AllCategoriesState createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories> {
   bool updateAvailable=false;

   @override
   void initState() { 
     checkUpdate();
     super.initState();
     
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
     // drawer: CustomerDrawer(user:widget.user),
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text("All Categories"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyCart(
                  user: widget.user,
                )));
              }),
        ],
      ),
      body: BlocBuilder<HomeBloc,HomeState>(
        builder: (context,state){
          if(state is HomeInitialState){
            return Center(
              child: CircularProgressIndicator(),
            );
          }else if(state is CategoryFetched){
            return FutureBuilder(
            future: state.categories,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                  itemCount: snapshot.data.documents.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  
                    ), 
                  itemBuilder: (context,index){
                      return InkWell(
                        onTap: () {
                         
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => BlocProvider<HomeBloc>(
                                  create: (context) => HomeBloc()
                                    ..add(FetchCategoryProducts(
                                        category: snapshot.data.documents[index].documentID
                                            )),
                                  child: CategoryProductScreen(
                                    user: widget.user,
                                    title: snapshot.data.documents[index]['title'],
                                  ))));
                        },
                        child: Container(
                          margin: EdgeInsets.all(10),
                          height: 300,
                         
                          child: Stack(
                            children: <Widget>[
                              FutureBuilder(
                                future: Firestore.instance.collection('products').where('category',isEqualTo: snapshot.data.documents[index].documentID).limit(1).getDocuments(),
                                builder: (context,asyncSnapshot){
                                  if(asyncSnapshot.connectionState==ConnectionState.waiting){
                                      //return Center(child: CircularProgressIndicator(backgroundColor: Colors.red));
                                      return Shimmer.fromColors(
                                        child: Container(
                                          height: double.infinity,
                                          width: double.infinity,
                                          color: Colors.red
                                        ), 
                                        baseColor: Colors.grey[200],
                                         highlightColor:  Colors.grey[350],);
                                  }
                                  else if(asyncSnapshot.hasData){
                                    if(asyncSnapshot.data.documents.length > 0){
                                      return ClipRRect(
                                         borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0),
                                    bottomLeft: Radius.circular(20.0),
                                    bottomRight: Radius.circular(20.0),
                                  ),

                                        child: CachedNetworkImage(
                                            imageUrl: asyncSnapshot.data.documents[0]['images'][0],
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.fill,
                                          placeholder: (context,url)=> Image.asset("assets/images/placeholder.png"),
                                      //  placeholder: (context,url)=> Center( child: SizedBox(height:150,child: CircularProgressIndicator(),)),
                                            ),
                                      );
                                    
                                    }else{
                                      return Container();
                                    }                                      
                                  }
                                
                                }),
                        //         Container(
                        // color: Color.fromRGBO(255, 255, 255, 0.56),
                        // ),

                              Positioned(
                                top: 70,
                                left: 5,
                                child: Container(
                                  width: 150,
                                  child: AutoSizeText(
                                    
                                  snapshot.data.documents[index]['title'],
                                  maxLines: 2,
                                  minFontSize: 20,
                                  textAlign: TextAlign.center,
                                  
                                  style: TextStyle(
                                     color: Colors.white,
                                     backgroundColor: Colors.black26,
                                     fontWeight: FontWeight.bold,
                                     
                                     ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            });
          }
        },
      ),
    );
  }
}
