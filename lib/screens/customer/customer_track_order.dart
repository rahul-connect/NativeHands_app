import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

TextStyle headingStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w700
);
TextStyle contentStyle = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w500,
  fontFamily: 'sfpro'
);
LinearGradient gradientStyle = LinearGradient(
   colors:[Color(0xfff3953b), Color(0xffe57509)],
   // stops: [0,1],
    begin: Alignment.topCenter,
     
);


class TrackOrderPage extends StatefulWidget {
  final DocumentSnapshot orderDetail;
  TrackOrderPage(this.orderDetail);



  @override
  _TrackOrderPageState createState() => _TrackOrderPageState();
}

class _TrackOrderPageState extends State<TrackOrderPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios,color: Colors.black,),
        ),
        title: Text("Track Order", style: TextStyle(
            color: Colors.black
        ),),
        actions: [
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: SingleChildScrollView(
              child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Order Id -  ${widget.orderDetail.documentID}", style: headingStyle.copyWith(fontSize: 18),),
              // Text("Order confirmed. Ready to pick", style: contentStyle.copyWith(
              //   color: Colors.grey,
              //   fontSize: 16
              // ),),
              Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                height: 1,
                color: Colors.grey,
              ),
             Stack(
         
               children: [
                 Container(
                   margin: EdgeInsets.only(left: 13, top: 50),
                   width: 4,
                   height: 300,
                   color: Colors.grey,
                 ),
                 Column(
                   children: [
                     if(widget.orderDetail['status']=='pending')...[
                        statusWidget('pending', "Pending", true),
                     statusWidget('confirmed', "Confirmed", false),
                     statusWidget('inprogress', "In Progress", false),
                     statusWidget('delivered', "Delivered", false),
                     ],
                      if(widget.orderDetail['status']=='accepted')...[
                        statusWidget('pending', "Pending", true),
                     statusWidget('confirmed', "Confirmed", true),
                     statusWidget('inprogress', "In Progress", true),
                     statusWidget('delivered', "Delivered", false),
                     ],
                     
                      if(widget.orderDetail['status']=='delivered')...[
                        statusWidget('pending', "Pending", true),
                     statusWidget('confirmed', "Confirmed", true),
                     statusWidget('inprogress', "In Progress", true),
                     statusWidget('delivered', "Delivered", true),
                     ],
                        if(widget.orderDetail['status']=='cancelled')...[
                        statusWidget('cancelled', "Cancelled", true),
                     statusWidget('confirmed', "Confirmed", false),
                     statusWidget('inprogress', "In Progress", false),
                     statusWidget('delivered', "Delivered", false),
                     ],
                    
                   ],
                 )
               ],
             ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                height: 1,
                color: Colors.grey,
              ),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Container(
              //       padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.all(Radius.circular(10)),
              //         border: Border.all(
              //           color: Colors.orange,
              //         )
              //       ),
              //       child: Text("Cancel Order", style: contentStyle.copyWith(
              //         color: Colors.orange
              //       ),),
              //     ),
              //     Container(
              //       padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              //       decoration: BoxDecoration(
              //           borderRadius: BorderRadius.all(Radius.circular(10)),

              //             color: Colors.orange,

              //       ),
              //       child: Text("My Orders", style: contentStyle.copyWith(
              //           color: Colors.white
              //       ),),
              //     ),
              //   ],
              // ),

            ],
          ),
        ),
      ),

    );
  }
  Container statusWidget(String img, String status, bool isActive)
  {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Container(
            height: 30,
            width: 30,

            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (isActive) ? Colors.orange : Colors.white,
              border: Border.all(
                color: (isActive) ? Colors.transparent : Colors.orange,
                width: 3
              )
            ),
          ),
          SizedBox(width: 50,),
          Column(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/$img.png"),
                        fit: BoxFit.contain
                    )
                ),
              ),
              Text(status, style: contentStyle.copyWith(
                  color: (isActive) ? Colors.orange : Colors.black
              ),)
            ],
          )
        ],
      ),
    );
  }
}