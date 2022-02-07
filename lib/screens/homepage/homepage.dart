
import 'dart:convert';

import 'package:big_basket_vendor/constant/api.dart';
import 'package:big_basket_vendor/constant/constant.dart';
import 'package:big_basket_vendor/screens/homepage/home_modalclass.dart';
import 'package:big_basket_vendor/screens/homepage/total_pending_order.dart';
import 'package:big_basket_vendor/screens/order_history/order_history.dart';
import 'package:big_basket_vendor/screens/order_history/order_modalclass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
   HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  var userName;
  var userNumber;
late  final homeModalclass;
  List<String> orderType = ["Pending","Completed","Cancelled","Delivery Boy",""];
  @override
  void initState() {
    // TODO: implement initState
    getData();
    getUserData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: themeColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hello ${userName??""}",style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 16)),
            Text(
              userNumber??"",
              style: GoogleFonts.poppins(fontSize: 12),
            ),
          ],
        ),
      ),
      body: isLoading == true?Center(child:
      loaderWidget(),) :SingleChildScrollView(
        child: Container(
          color: backgroundColor,
          child:Column(
            children: [

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: cardElevation,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cardBorderRadius),),
                  child: ListTile(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>  TotalPendingOrder(modetype:"")));

                    },
                    title: Text("Total Orders",style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 14),),
                    trailing: SizedBox(height: 50,width: 50,child: Image.asset("assets/images/trolley.png")),
                    subtitle: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(homeModalclass.result!.torders.toString(),style: GoogleFonts.cookie(fontWeight: FontWeight.bold),),
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.yellow.shade700,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: cardElevation,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cardBorderRadius),),
                  child: ListTile(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>  TotalPendingOrder(modetype:"pending")));

                    },
                    title: Text("Total Pending Order",style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 14),),
                    trailing: SizedBox(height: 50,width: 50,child: Image.asset("assets/images/trolley.png")),
                    subtitle: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(homeModalclass.result!.porders.toString(),style: GoogleFonts.cookie(fontWeight: FontWeight.bold),),
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.yellow.shade700,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: cardElevation,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cardBorderRadius),),
                  child: ListTile(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>  TotalPendingOrder(modetype:"completed")));

                    },
                    title: Text("Total Completed Order",style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 14),),
                    trailing: SizedBox(height: 50,width: 50,child: Image.asset("assets/images/trolley.png")),
                    subtitle: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(homeModalclass.result!.dorders.toString(),style: GoogleFonts.cookie(fontWeight: FontWeight.bold),),
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.yellow.shade700,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: cardElevation,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cardBorderRadius),),
                  child: ListTile(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>  TotalPendingOrder(modetype:"cancelled")));

                    },
                    title: Text("Total Cancelled Order",style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 14),),
                    trailing: SizedBox(height: 50,width: 50,child: Image.asset("assets/images/trolley.png")),
                    subtitle: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(homeModalclass.result!.corders.toString(),style: GoogleFonts.cookie(fontWeight: FontWeight.bold),),
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.yellow.shade700,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: cardElevation,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cardBorderRadius),),
                  child: ListTile(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>  TotalPendingOrder(modetype:"tdboy")));

                    },
                    title: Text("Total Delivery Boy",style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 14),),
                    trailing: SizedBox(height: 50,width: 50,child: Image.asset("assets/images/trolley.png")),
                    subtitle: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(homeModalclass.result!.tdboy.toString(),style: GoogleFonts.cookie(fontWeight: FontWeight.bold),),
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.yellow.shade700,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: cardElevation,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cardBorderRadius),),
                  child: ListTile(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>  TotalPendingOrder(modetype:"tsales")));

                    },
                    title: Text("Total Sales",style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 14),),
                    trailing: SizedBox(height: 50,width: 50,child: Image.asset("assets/images/trolley.png")),
                    subtitle: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(homeModalclass.result!.tsales.toString(),style: GoogleFonts.cookie(fontWeight: FontWeight.bold),),
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.yellow.shade700,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final userID = prefs.getString("userId");
    var response = await http.get(Uri.parse("$homeApi?userid=$userID"));
    var body = jsonDecode(response.body);
    debugPrint(body.toString());
     homeModalclass = homeModalclassFromJson(response.body);
    isLoading = false;
    setState(() {});

  }

  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString("name");
      userNumber = prefs.getString("userNumber");


    });
  }


}
