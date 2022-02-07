import 'dart:convert';
import 'dart:ui';

import 'package:big_basket_vendor/constant/api.dart';
import 'package:big_basket_vendor/constant/constant.dart';
import 'package:big_basket_vendor/screens/order_details/order_details.dart';
import 'package:big_basket_vendor/screens/order_history/order_modalclass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TotalOrderPending extends StatefulWidget {
  const TotalOrderPending({Key? key}) : super(key: key);

  @override
  State<TotalOrderPending> createState() => _TotalOrderPendingState();
}

class _TotalOrderPendingState extends State<TotalOrderPending> {
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  bool isLoading = true;
  int? noProductFlag;

  var orderHistoryModalclass;
  @override
  void initState() {
    // TODO: implement initState
    getData("");
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: themeColor,
          title: Column(
            children: [
              Text("Order History",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, fontSize: 16)),
            ],
          ),
        ),
      floatingActionButton: SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      openCloseDial: isDialOpen,
      backgroundColor: themeColor,
      overlayColor: Colors.grey,
      overlayOpacity: 0.6,
      spacing: 15,
      spaceBetweenChildren: 15,

      closeManually: false,
      children: [

        SpeedDialChild(
          //  child: Icon(Icons.pending_actions),
            label: 'Cancel',
            labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            backgroundColor: Colors.blue,
            elevation: 10,

            onTap: (){
              setState(() {
                getData("cancelled");
              });
            }
        ),
        SpeedDialChild(
           // child: Icon(Icons.),
            labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            label: 'Completed',
            onTap: (){

              setState(() {
                getData("completed");
              });
            }
        ),
        SpeedDialChild(
         //   child: Icon(Icons.copy),
            labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            label: 'Pending',
            onTap: (){
              //setState(() {

                getData("pending");

              //  });
            }
        ),
        SpeedDialChild(
          //  child: Icon(Icons.pending_actions),
            label: 'ALL',
            labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            backgroundColor: Colors.blue,
            elevation: 10,

            onTap: (){
              setState(() {
                getData("");
              });
            }
        ),
      ],
    ),
      body:isLoading == true?Center(child:
      loaderWidget(),) :noProductFlag == 1?Center(child:Image.asset("assets/images/no_product_found.png")):
      SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding:  const EdgeInsets.all(paddingMore),
              child: Text("Product (${orderHistoryModalclass.result.length.toString()})",style: const TextStyle(
                fontSize: fontBold,fontWeight: FontWeight.bold
              ),),
            ),
            Container(

              child:
                  dynamicListview(),

            ),
          ],
        ),
      ),
    );
  }
  // Navigator.push(context, MaterialPageRoute(builder: (context)=> OrderDetails(),));

  Widget dynamicListview() {

      return ListView.builder(
        itemCount: orderHistoryModalclass.result!.length,
        //  itemCount: title.length,
        shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
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

  }

  getData(String mode) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final userID = prefs.getString("userId");
    var response = await http.get(Uri.parse("$viewOrderApi?userid=$userID&mode=$mode"));
    var body = jsonDecode(response.body);
    debugPrint(body.toString());
    if(body["status"] == "400"){
      noProductFlag = 1;

    }else {
      noProductFlag = 0;

      orderHistoryModalclass = orderHistoryModalclassFromJson(response.body);
    }

      isLoading = false;
    setState(() {});

  }
}
