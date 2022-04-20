const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().functions);

var newData;

exports.newOrder = functions.firestore.document('orders/{orderId}').onCreate(async(snapshot,context)=>{
    if(snapshot.empty){
        console.log("No device");
        return;
    }
    var tokens = [

    ]

    newOrderDetail = snapshot.data();

    const deviceTokens = await admin.firestore().collection('users').where('role','==','seller').get();

    for(var token of deviceTokens.docs){
    
            tokens.push(token.data().device_token);
       
    }

    // We can also go through all the results like this instead of using for of
     //querySnapshot.forEach(function (documentSnapshot) {
    //var data = documentSnapshot.data();
    // do something with the data of each document.
  //}); OR 
  // get the data of all the documents into an array
// var data = querySnapshot.docs.map(function (documentSnapshot) {
//     return documentSnapshot.data();
//   });
  

    var payload = {
        notification:{
            title:'New Order Recieved',
            body: 'Check order section for more details',
            sound: 'default',
        },
        data:{
            message:'New Order Receieved',
            click_action: 'FLUTTER_NOTIFICATION_CLICK',
        }
    };

    try{
        const response = await admin.messaging().sendToDevice(tokens,payload);
    }catch(e){
        console.log(e);
    }
});
