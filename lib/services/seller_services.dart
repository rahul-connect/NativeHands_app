


import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';

import 'package:flutter/material.dart';

class SellerService{
   final Firestore _db = Firestore.instance;
   List<String> _imageUrl = [];
   var _pickType = FileType.image;


   Future<void> addCatgeory(String title,String userId)async {
     await _db.collection('category').add({
       'title':title,
       'userId':userId,
       'icon':'',
     });
   }




   
  Future<void> uploadToFireStorage({String title,String description,List colors,Map<String, String> paths,String category,int price,String sellerId}) async{
    
   bool uploadSuccess;

   paths.forEach((fileName,filePath) async{
    int length = paths.length;
    //String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    
    await upload(fileName,filePath);

    if(length == _imageUrl.length){
     await uploadProduct(
      title: title,
      description: description,
      imageUrl:_imageUrl,
      category:category,
      price:price,
      sellerId:sellerId,
    );

    uploadSuccess = true;
    
    }else{
     
    }
   
  });

  while(uploadSuccess==null){

    await Future.delayed(Duration(seconds: 1));
  }

 // print("Status of UPLOADING = $uploadSuccess");

  }

  Future<void> upload(fileName, filePath) async {
    String _extension = fileName.toString().split('.').last;

    StorageReference storageRef =
        FirebaseStorage.instance.ref().child("products/$fileName");
    final StorageUploadTask uploadTask = storageRef.putFile(
      File(filePath),
      StorageMetadata(
        contentType: '$_pickType/$_extension',
      ),
    );
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
     _imageUrl.add(downloadUrl);

  }


  Future<void> uploadProduct({String title,description,imageUrl,category,price,sellerId}) async{
     
 

      List<String> caseSearchList = List();

  // String temp = "";
  // for (int i = 0; i < title.length; i++) {
  //   temp = temp + title[i];
  //   caseSearchList.add(temp);
  // }  

     List<String> splitList =title.split(" ");
     for(int i=0;i<splitList.length;i++){
       for(int y=1; y < splitList[i].length+1;y++){
          caseSearchList.add(splitList[i].substring(0,y).toLowerCase());
       }
     }
      
       await _db.collection("products").add({
        "title": title,
        "description": description,
        "images": imageUrl,
        "category":category,
        "price":price,
        "sellerId":sellerId,
        'available':true,
        "date": DateTime.now(),
        'searchIndex':caseSearchList,
      });
  }



  Future getCategories(){
    return _db.collection('category').getDocuments();
  }


       Stream fetchAllPendingOrders({@required sellerId}) async*{
     yield* _db.collection('orders').where('status',isEqualTo: 'pending').where('delivered_by',arrayContains: sellerId).orderBy('date',descending: true)
    .snapshots();
   }



     Stream fetchAllAcceptedOrders({@required sellerId}) async*{
     yield* _db.collection('orders').where('status',isEqualTo: 'accepted').where('delivered_by',arrayContains: sellerId).orderBy('date',descending: true)
    .snapshots();
   }


     Stream fetchAllDeliveredOrders({@required sellerId}) async*{
     yield* _db.collection('orders').where('status',isEqualTo: 'delivered').where('delivered_by',arrayContains: sellerId).orderBy('delivered_date',descending: true)
    .snapshots();
   }

     Stream fetchAllCancelledOrders() async*{
     yield* _db.collection('orders').where('status',isEqualTo: 'cancelled').orderBy('date',descending: true)
    .snapshots();
   }

   



   Future<int> countPendingOrders(sellerId) async{
     int pendingOrders = await _db.collection('orders').where('status',isEqualTo: 'pending').where('delivered_by', arrayContains: sellerId).where('price_modified', isEqualTo: false).getDocuments().then((doc){
        return(doc.documents.length);
     });
     return pendingOrders;
   }

   Future<int> countApprovedOrders(sellerId) async{
     int acceptedOrders = await _db.collection('orders').where('status',isEqualTo: 'accepted').where('delivered_by',arrayContains: sellerId).getDocuments().then((doc){
        return(doc.documents.length);
     });
     return acceptedOrders;
   }

   Future<int> countDeliveredOrders(sellerId) async{
     int deliveredOrders = await _db.collection('orders').where('status',isEqualTo: 'delivered').where('delivered_by',arrayContains: sellerId).getDocuments().then((doc){
        return(doc.documents.length);
     });
     return deliveredOrders;
   }

    Future<int> countTotalCustomer() async{
     int totalCustomers = await _db.collection('users').where('role',isEqualTo: 'customer').getDocuments().then((doc){
        return(doc.documents.length);
     });
     return totalCustomers;
   }







}