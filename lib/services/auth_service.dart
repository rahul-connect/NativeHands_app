import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class AuthService{
   final FirebaseAuth _firebaseAuth;
   final Firestore _firestore;
   String verificationId;
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

    
         Future _getDeviceToken() async{
          var deviceToken = await _firebaseMessaging.getToken();
          return deviceToken;
        }

   AuthService({FirebaseAuth firebaseAuth,Firestore firestore})
   : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
    _firestore = firestore ?? Firestore.instance;


    Stream<FirebaseUser> onAuthChange()async*{
      yield* _firebaseAuth.onAuthStateChanged;
    }



   Future sendOtpCode({String phoneNo}) async{
       final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId){
          this.verificationId = verId;
       };

        final PhoneCodeSent smsCodeSent = (String verId,[int forceCodeResend]){
          this.verificationId = verId;
         
        };

        final PhoneVerificationCompleted verifiedSuccess = (AuthCredential credential)async{
          // This callback will only execute if verification is done automatically
          AuthResult result = await _firebaseAuth.signInWithCredential(credential);
          FirebaseUser user = result.user;

          // CHeck if User already exists and whats its role
          final DocumentSnapshot userExists =  await _firestore.collection("users").document(user.uid).get();
    

          if(userExists.data == null){
            var deviceToken = await _getDeviceToken();

             await _firestore.collection("users").document(user.uid).setData({
              "fullName":"",
              "userId":user.uid,
              "role":"customer",
              "phone":user.phoneNumber,
              "address":"",
              "company":"",
              "gstNo":"",
              "device_token":deviceToken,
              "verified":false,
          });

         // print("New User Registered");

          }else{
           // print("User already Exists");
          }   

        //  print("OTP detected automatically");      

        };

        final PhoneVerificationFailed verifiedFailure = (AuthException exception){
          print(exception.message);
        };
        
        await _firebaseAuth.verifyPhoneNumber(phoneNumber: "+91"+phoneNo, timeout: Duration(seconds:30), verificationCompleted: verifiedSuccess, verificationFailed: verifiedFailure, codeSent: smsCodeSent, codeAutoRetrievalTimeout: autoRetrieve);

   }  


   Future<FirebaseUser> verifyOtpLogin({String smsOTP}) async{
        try {
            final AuthCredential credential = PhoneAuthProvider.getCredential(    
            verificationId: this.verificationId,    
            smsCode: smsOTP,    
            );    

            final AuthResult authResult = await _firebaseAuth.signInWithCredential(credential);    
            final FirebaseUser currentUser = authResult.user;

              // CHeck if User already exists and whats its role
          final DocumentSnapshot userExists =  await _firestore.collection("users").document(currentUser.uid).get();
    

          if(userExists.data == null){
            var deviceToken = await _getDeviceToken();
             await _firestore.collection("users").document(currentUser.uid).setData({
              "fullName":"",
              "userId":currentUser.uid,
              "role":"customer",
              "phone":currentUser.phoneNumber,
              "address":"",
              "company":"",
              "gstNo":"",
              "device_token":deviceToken,
               "verified":false,
          });

         // print("New User Registered");

          }
            return currentUser;

        }catch(e){
          return null;
        }


   }



    Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
    ]);
  }


  Future<DocumentSnapshot> getFirestoreUser(currentUser)async{
    DocumentSnapshot user =   await _firestore.collection("users").document(currentUser.uid).get();
   
    if(user.exists){
      return user;

    }else{
      await Future.delayed(Duration(seconds: 2));
      DocumentSnapshot newUserLogin =   await _firestore.collection("users").document(currentUser.uid).get();
       return newUserLogin;

    }
   

  }







}