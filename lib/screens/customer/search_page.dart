import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/user.dart';
import '../../screens/customer/product_detail.dart';


class SearchPage extends StatelessWidget {

  final String searchText;
  final User user;
  SearchPage(this.searchText,this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xFF3EA653),
        title: Text('Results'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: Firestore.instance.collection('products').where('title', isGreaterThanOrEqualTo: searchText)
                        .where('title', isLessThan: searchText +'z').getDocuments(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            if(snapshot.data.documents.length < 1){
              return Center(
                child: Text("No product found",style: TextStyle(fontSize: 20),),
              );
            }

                return GridView.builder(
                      padding: EdgeInsets.all(10),
                      itemCount: snapshot.data.documents.length,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 300.0,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10,
                        childAspectRatio: 640 / 978
                            //MediaQuery.of(context).size.height / 978,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProductDetail(
                                  product: snapshot.data.documents[index],
                                  user: user,
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
                                      color: Colors.teal,
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductDetail(
                                                      product: snapshot.data
                                                          .documents[index],
                                                          user: user,
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

          return Center(
            child: CircularProgressIndicator(),
          );
      
      })
      
    );
  }
}