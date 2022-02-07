import 'dart:convert';

import 'package:big_basket_vendor/constant/api.dart';
import 'package:big_basket_vendor/constant/constant.dart';
import 'package:big_basket_vendor/screens/order_details/order_details.dart';
import 'package:big_basket_vendor/screens/order_history/order_modalclass.dart';
import 'package:big_basket_vendor/screens/product_list/product_modalclass.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TotalPendingOrder extends StatefulWidget {
  final modetype;
   TotalPendingOrder({Key? key, this.modetype}) : super(key: key);

  @override
  State<TotalPendingOrder> createState() => _TotalPendingOrderState();
}

class _TotalPendingOrderState extends State<TotalPendingOrder> {
  bool isLoading = true;

  late final orderHistoryModalclass;

  int? noProductFlag;


  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: themeColor,
        title: Column(
          children: [
            Text("Total Pending Order",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500, fontSize: 16)),
          ],
        ),
      ),
      body: isLoading == true?Center(child:
      loaderWidget(),) :noProductFlag == 1?Center(child:Image.asset("assets/images/no_product_found.png")):SingleChildScrollView(
        physics: const BouncingScrollPhysics(),

        child: Container(
          color: backgroundColor,
          child: dynamicListview(),
        ),
      ),
    );
  }

   Widget dynamicListview() {
     // print("this is findword $findWord");
     return LayoutBuilder(builder: (context, constraints) {
       return ListView.builder(
         itemCount: orderHistoryModalclass.result!.length,
         //  itemCount: title.length,
         shrinkWrap: true,
         physics: const BouncingScrollPhysics(),
         itemBuilder: (context, index) {
           return Column(
             children: [
               const SizedBox(height: 10,),
               GestureDetector(
                 onTap: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context)=> OrderDetails(orderId: orderHistoryModalclass.result![index].id),));

                 },
                 child: Padding(
                   padding: const EdgeInsets.all(2.0),
                   child: Card(
                     elevation: cardElevation,
                     shape: RoundedRectangleBorder(

                         borderRadius: BorderRadius.circular(cardBorderRadius)
                     ),
                     child: Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Column(
                         children: [

                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Text(
                                 orderHistoryModalclass.result![index].name,
                                 style: GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: 13),
                               ),

                               Text(
                                 orderHistoryModalclass.result![index].txnId,
                                 style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 12,color: Colors.grey),
                               ),
                             ],
                           ),
                           //    trailing: Icon(Icons.add_shopping_cart),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Column(
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   const SizedBox(height: sizedBoxlessHeight,),
                                   Text(
                                     "Qty:1",
                                     style: GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: 13),
                                   ),
                                   const SizedBox(height: sizedBoxlessHeight,),

                                   Padding(
                                     padding: const EdgeInsets.all(2.0),
                                     child: Text(
                                       "Rs."+orderHistoryModalclass.result![index].total,
                                       style: TextStyle(fontWeight: FontWeight.w500,color: redColor,fontSize: fontw500),
                                     ),
                                   ),
                                 ],
                               ),

                               Column(
                                 children: [

                                   Padding(
                                     padding: const EdgeInsets.all(1.0),
                                     child: Text(
                                       orderHistoryModalclass.result![index].dt.toString().split(" ").first,
                                       style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 12,color: Colors.grey),
                                     ),
                                   ),
                                   Padding(
                                     padding: const EdgeInsets.all(1.0),
                                     child: Text(
                                       orderHistoryModalclass.result![index].status??"",
                                       style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 12,color: Colors.grey),
                                     ),
                                   ),
                                 ],
                               ),

                             ],
                           ),

                         ],
                       ),
                     ),
                   ),
                 ),
               ),
             ],
           );
         },
       );
     });
   }

   getData() async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     final userID = prefs.getString("userId");
     var response = await http.get(Uri.parse("$viewOrderApi?userid=$userID&mode=${widget.modetype}"));
     var body = jsonDecode(response.body);
     debugPrint(body.toString());
     orderHistoryModalclass = orderHistoryModalclassFromJson(response.body);
     isLoading = false;
     setState(() {});

   }
}
