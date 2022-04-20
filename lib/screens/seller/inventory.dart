import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../model/user.dart';

import 'alert_notification.dart';
import 'drawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import './edit_product.dart';

class InventoryScreen extends StatefulWidget {
  final User user;
  InventoryScreen(this.user);

  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  Firestore _firestore = Firestore.instance;

  @override
  void initState() {
    newOrderNotification(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SellerDrawer(user: widget.user),
      appBar: AppBar(
        title: Text("Inventory Management"),
      ),
      body: StreamBuilder(
          stream: _firestore.collection("products").where('sellerId',isEqualTo: widget.user.userId).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.documents.length > 0) {
                return ListView.separated(
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      var product = snapshot.data.documents[index];
                      return ListTile(
                        leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: CachedNetworkImage(
                              fit: BoxFit.fill,
                              imageUrl: snapshot.data.documents[index]['images']
                                  [0],
                              placeholder: (context, uri) {
                                return Icon(Icons.image);
                              },
                              errorWidget: (context, url, error) => Icon(
                                Icons.error,
                                color: Colors.black,
                              ),
                            )),
                        title: Text(product['title']),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProductScreen(
                                          productId: snapshot
                                              .data.documents[index].documentID,
                                        )));
                          },
                          color: Colors.teal,
                        ),


                      );
                    });
              } else {
                return Center(child: Text("No Product Uploaded"));
              }
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
