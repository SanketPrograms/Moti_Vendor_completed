import 'dart:convert';

import 'package:big_basket_vendor/constant/api.dart';
import 'package:big_basket_vendor/constant/constant.dart';
import 'package:big_basket_vendor/screens/order_history/order_modalclass.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: themeColor,
        title: Column(
          children: [
            Text("Notification",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500, fontSize: 16)),
          ],
        ),
      ),
      body: isLoading == true?Center(child:
      loaderWidget(),) :Container(
        color: backgroundColor,
        child: dynamicListview(),
      ),
    );
  }

  Widget dynamicListview() {
    // print("this is findword $findWord");
    return LayoutBuilder(builder: (context, constraints) {
      return ListView.builder(
        itemCount: 2,
        //  itemCount: title.length,
        shrinkWrap: true,
        //  physics: const ScrollPhysics(),
        itemBuilder: (context, index) {
          return  Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: cardElevation,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(cardBorderRadius)
                ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Order Received",style: GoogleFonts.poppins(
                          fontSize: fontBold,fontWeight: FontWeight.w600
                        ),),
                        Text("Qty 1",style: GoogleFonts.poppins(
                            fontSize: fontBold,fontWeight: FontWeight.w600
                        ),),
                      ],
                    ),
                    SizedBox(height: 2,),

                    Text("Product Name",style: GoogleFonts.poppins(
                        fontSize: fontBold,fontWeight: FontWeight.w600
                    ),),
                    SizedBox(height: 10,),

                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Date: 27-09-2021",style: GoogleFonts.poppins(
                            fontSize: fontw500,fontWeight: FontWeight.w500
                        ),),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Time: 01:29 Pm",style: GoogleFonts.poppins(
                                fontSize: fontw500,fontWeight: FontWeight.w500
                            ),),
                            Text("Total: 125RS",style: GoogleFonts.poppins(
                                fontSize: fontBold,fontWeight: FontWeight.w600,
                              color: redColor
                            ),),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  getData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userID = prefs.getString("userId");
    var response = await http.get(Uri.parse("$notificationApi?userid=$userID"));
    var body = jsonDecode(response.body);
    debugPrint(body.toString());
    final orderHistoryModalclass = orderHistoryModalclassFromJson(response.body);
    isLoading = false;
    setState(() {});

  }
}
