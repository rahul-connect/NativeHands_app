

import 'package:cloud_firestore/cloud_firestore.dart';

class User{
    String fullName;
     String company;
    final String phoneNo;
    final String role;
    final String userId;
     String gstNo;
     String address;
     bool verified;


  User({this.fullName, this.gstNo, this.phoneNo, this.role,this.userId,this.address,this.company,this.verified});

  factory User.fromJson(DocumentSnapshot snapshot){
      return User(
        fullName: snapshot.data['fullName'],
        company: snapshot.data['company'],
        phoneNo: snapshot.data['phone'],
        role: snapshot.data['role'],
        userId: snapshot.data['userId'],
        address: snapshot.data['address'],
        gstNo: snapshot.data['gstNo'],
        verified: snapshot.data['verified'] ?? false,
      );
    }

      Map<String,dynamic> toJson(User user){
      return {
        'fullName':user.fullName,
        'company':user.company,
        'phone':user.phoneNo,
        'role':user.role,
        'userId':user.userId,
        'address':user.address,
        'gstNo':user.gstNo,
        'verified':user.verified
      };

    }




    
}