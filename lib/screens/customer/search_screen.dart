import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import '../../model/user.dart';

import 'bottom_navbar.dart';
import 'product_detail.dart';


class SearchScreen extends StatefulWidget {
  final User user;
  SearchScreen({@required this.user});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  String searchString;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       bottomNavigationBar: BottomNavBar(user: widget.user,screen: 'search',),
      floatingActionButton: FloatingActionButton(
         heroTag: "help",
        backgroundColor: Colors.orangeAccent,
        onPressed: (){},
        child: Icon(Icons.help_outline,size: 35,
      ),),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Column(
        children: [
          Expanded(child: Column(
            children: [
              Container(
             
                padding: EdgeInsets.only(left:35,right: 35,top: 35),
                child: TextField(
                  onChanged: (value){
                    setState(() {
                      searchString = value.toLowerCase();
                    });
                  },
              controller: searchController,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear), onPressed: ()=>searchController.clear())
              ,hintText: "Search here",
              hintStyle: TextStyle(
                color: Colors.blueGrey
              )
              ),
            ),
              ),
                Expanded(child: StreamBuilder<QuerySnapshot>(
                  stream: (searchString == null || searchString.trim()=='')?Firestore.instance.collection('products').snapshots():Firestore.instance.collection('products').where('searchIndex',arrayContains: searchString).snapshots()
                  ,builder: (context,snapshot){
                     if(snapshot.hasError){
                       return Text("We got an Error : ${snapshot.error}");
                     }
                     switch(snapshot.connectionState){
                       case ConnectionState.waiting :return Lottie.asset('animations/loadingDot.json');
                       case ConnectionState.none:return Text("Oops no data Present");
                       case ConnectionState.done:return Text("we are done");
                       default:return ListView.builder(
                         itemCount: snapshot.data.documents.length,
                         itemBuilder: (context,index){
                           return ListTile(
                             onTap: (){
                               Navigator.push(context, MaterialPageRoute(builder: (_)=>ProductDetail(product: snapshot.data.documents[index], user: widget.user)));
                             },
                             title: Text(snapshot.data.documents[index]['title']),
                             leading: CircleAvatar(
                               child: CachedNetworkImage(
                                  placeholder: (context,url)=> Shimmer.fromColors(child: CircleAvatar(), baseColor:Colors.grey[200],highlightColor:  Colors.grey[350]),
                                 imageUrl: snapshot.data.documents[index]['images'][0]),
                             ),
                           );
                         },
                         
                       );
                     }
                  })),

            ],
          ))
        ],
      ),
      
    );
  }
}