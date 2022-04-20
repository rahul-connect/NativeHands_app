
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerService{
   final Firestore db = Firestore.instance;


  //  Stream fetchAllProducts() async*{
  //     yield* db.collection('products').snapshots();
  //  }

  Future fetchAllCategories() async{
    var categories =  db.collection('category').getDocuments();
    return categories;
  }


   Stream fetchCategoryProducts({categoryID}) async*{
     yield* db.collection('products').where('category',isEqualTo:categoryID ).snapshots();
   }





   Stream fetchCartItems(userId) async*{
     yield* db.collection('users').document(userId).collection('cart').snapshots();

   }


   void deleteCartItem(cartItemId,userId) async{
      await db.collection('users').document(userId).collection('cart').document(cartItemId).delete(); 
      
    }


    Future<void> orderNow(userId,totalAmount,razorpay_orderId,razorpay_paymentId,paymentMode)async{
      List<Map> products = [];
      List<String> sellers=[];
      Map sellerTotal={};


       await db.collection('users').document(userId).collection('cart').getDocuments().then((orderItem){
             orderItem.documents.forEach((itemDetail){
               var sellerId = itemDetail.data['sellerId'];


              // Uncomment if you want to populate sellers automatically accordind to product
              //  if(sellers.contains(sellerId)==false){
              //     sellers.add(sellerId);
              //  }   
               
           
              if(sellerId != itemDetail.data['sellerId']){
                  sellerId = itemDetail.data['sellerId'];     
              }

               products.add({
                 'productId':itemDetail.data['productId'],
                 'qty':itemDetail.data['qty'],
                 'price': itemDetail.data['price'].toString(),
                 'new_price':itemDetail.data['price'].toString(),
                 'title': itemDetail.data['title'],
                 'sellerId':itemDetail.data['sellerId'],
                 'seller_status':'pending',
                 'available':true,
               });

               sellerTotal.update(sellerId, (value){
                int total = value['total'];
                total+= itemDetail.data['price']*itemDetail.data['qty'];
                return {
                  'total':total,
                  'status':''
                };
              },ifAbsent: ()=>{
                  'total': itemDetail.data['price']*itemDetail.data['qty'],
                  'status':'',
              });


               db.collection('users').document(userId).collection('cart').document(itemDetail.documentID).delete();              
             });
       });

       
               await db.collection('orders').add({
                 'userId':userId,
                 'products': products,
                 'status' : "pending",
                 'date':DateTime.now(),
                 'delivered_date':'',
                 'delivered_by':sellers,
                 'total':totalAmount.toString(),
                 'razorpay_orderId':razorpay_orderId,
                 'razorpay_paymentId':razorpay_paymentId,
                 'payment_mode':paymentMode,
                 'payment_status':'',
                 'seller_total':sellerTotal,
                 'price_modified':false,
                 'seller_assigned':false,
                 'new_total':totalAmount.toString()
               });
       
    }

    Future<void> updateCustomerDetails({userId,fullName,company,gstNo,address,becomeSeller}) async{
      await db.collection('users').document(userId).updateData({
        'fullName':fullName,
        'company':company,
        'gstNo':gstNo,
        'address':address,
        'role': becomeSeller ? 'seller' : 'customer',
      });

    }


       Stream fetchPendingOrders({userId}) async*{
     yield* db.collection('orders').where('userId', isEqualTo: userId).where('status',isEqualTo: 'pending').orderBy('date',descending: true)
    .snapshots();
   }


   
         Stream fetchAcceptedOrders({userId}) async*{
     yield* db.collection('orders').where('userId', isEqualTo: userId).where('status',isEqualTo: 'accepted').orderBy('date',descending: true)
    .snapshots();
   }


   
         Stream fetchDeliveredOrders({userId}) async*{
     yield* db.collection('orders').where('userId', isEqualTo: userId).where('status',isEqualTo: 'delivered').orderBy('date',descending: true)
    .snapshots();
   }



   







}