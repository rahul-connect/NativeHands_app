

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ProductImageView extends StatelessWidget {
   final String image;
  ProductImageView({@required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
            elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: PhotoView(imageProvider: CachedNetworkImageProvider(image),loadingBuilder: (context,event){
              return Image.asset('assets/images/placeholder.png');
            },),
          ),
      ),
       
      
    );
  }
}