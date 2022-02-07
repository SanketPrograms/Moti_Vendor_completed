import 'dart:convert';

import 'package:big_basket_vendor/constant/api.dart';
import 'package:big_basket_vendor/constant/constant.dart';
import 'package:big_basket_vendor/constant/singleton.dart';
import 'package:big_basket_vendor/screens/delivery_boy/view_delivery_modalclass.dart';
import 'package:big_basket_vendor/screens/order_details/order_details_modalclass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OrderDetails extends StatefulWidget {
  final orderId;
  OrderDetails({Key? key, this.orderId}) : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  int? noProductFlag;
  bool isLoading = true;
  var deliveryID;
  late final viewDeliveryModalclass;

  late final orderHistoryModalclass;
  @override
  void initState() {
    // TODO: implement initState
    getData();
    getDeliveryBoyData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:backgroundColor,

      appBar: AppBar(
        backgroundColor: themeColor,
        title: Column(
          children: [

            Text("Order Details",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500, fontSize: 16)),
          ],
        ),
      ),
      body: isLoading == true
          ? Center(
              child: loaderWidget(),
            )
          : noProductFlag == 1
              ? Center(child: Image.asset("assets/images/no_product_found.png"))
              : SingleChildScrollView(
                 physics: BouncingScrollPhysics(),
                child: Container(
                    color: backgroundColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width:150,
                                child: Text(
                                  "Txn ID ${orderHistoryModalclass.result!.txnId}",
                                  style: GoogleFonts.poppins(
                                      color: lightFontColor, fontSize: fontw500),
                                ),
                              ),
                             Container(
                               width:150,

                               child: Text(
                                    "Total: ${orderHistoryModalclass.result!.total.split(".").first}",
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                      fontSize: 12
                                    ),
                                  ),
                             ),

                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                             Container(
                               width:150,

                               child: Text("Date:"+
                                  orderHistoryModalclass.result!.items[0].dt
                                      .toString()
                                      .split(" ")
                                      .first,
                                  style: GoogleFonts.poppins(
                                      color: lightFontColor, fontSize: fontw500),
                                ),
                             ),

         Container(
           width:150,

           child: Text("Time:"+
                orderHistoryModalclass.result!.items[0].dt
                    .toString()
                    .split(" ")
                    .last
                    .split(".")
                    .first,
              style: GoogleFonts.poppins(
                  color: lightFontColor, fontSize: fontw500),

        ),
         ),

                          ],
                        ),
                        dynamicListview(),
                        ElevatedButton(
                          onPressed: () {
                            _showMyDialog(context);
                          },
                          child: Text("Assign Delivery Boy",
                              style: GoogleFonts.poppins(fontSize: 12,fontWeight: FontWeight.w500)),
                          style: ElevatedButton.styleFrom(
                              primary: themeColor,
                              // padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                              textStyle: GoogleFonts.poppins(
                                // fontSize: 30,
                                  fontWeight: FontWeight.w500)),
                        ),

                      ],
                    ),
                  ),
              ),
    );
  }

  Widget dynamicListview() {
    // print("this is findword $findWord");
    return LayoutBuilder(builder: (context, constraints) {
      return ListView.builder(
        itemCount: orderHistoryModalclass.result!.items.length,
        //  itemCount: title.length,
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        //  physics: const ScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Name: ${orderHistoryModalclass.result!.items[index].pname}",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Price: ${orderHistoryModalclass.result!.items[index].price.toString().split(".").first}",
                              style: GoogleFonts.poppins(
                                  color: lightFontColor, fontSize: fontw500),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //    trailing: Icon(Icons.add_shopping_cart),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                "Qty:${orderHistoryModalclass.result!.items[index].qty}",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                "",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),

                    Divider(thickness: 1),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Total: ${orderHistoryModalclass.result!.items[index].total.split(".").first}",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold, color: redColor),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final userID = prefs.getString("userId");
    var response = await http.get(
        Uri.parse("$orderDetailsApi?userid=$userID&oid=${widget.orderId}"));
    var body = jsonDecode(response.body);
    debugPrint(body.toString());
    orderHistoryModalclass = productDetailsModalclassFromJson(response.body);
    if (body["status"] == "400" ||
        orderHistoryModalclass.result!.items!.isEmpty) {
      noProductFlag = 1;
    } else {
      noProductFlag = 0;
    }
    isLoading = false;
    setState(() {});
  }

  getDeliveryBoyData() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userID = prefs.getString("userId");
    var response = await http.get(Uri.parse("$viewDeliveryBoy?userid=$userID}"));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      debugPrint(data.toString());
      viewDeliveryModalclass = viewDeliveryModalclassFromJson(response.body);

      setState(() {
        isLoading = false;
      });

    }
  }

  _showMyDialog(context) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(

            title: Text(
              'Assign Delivery Boy!',
              style: GoogleFonts.poppins(
                  fontSize: 14, fontWeight: FontWeight.bold),
            ),
            content: Card(
              child: ListView.builder(
                  itemCount: viewDeliveryModalclass.result.length,
                  //  itemCount: title.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),

                  itemBuilder: (context, index) {
                    return Card(
                      child: Column(
                        children: [
                          ListTile(title:  Text(viewDeliveryModalclass.result![index].name,style: GoogleFonts.poppins(fontWeight: FontWeight.bold),),

                            subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(viewDeliveryModalclass.result![index].phone,style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 12),),
                                ],
                              ),

                            trailing:  ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  assignDeliveryBoy(viewDeliveryModalclass.result![index].id,viewDeliveryModalclass.result![index].name);
                                  Navigator.pop(context);
                                });
                              },
                              child: Text("Assign",
                                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                              style: ElevatedButton.styleFrom(
                                  primary: themeColor,
                                  // padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                                  textStyle: GoogleFonts.poppins(
                                    // fontSize: 30,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ],
                      ),
                    );
                  })
            )


          );
        });
  }

  assignDeliveryBoy(deliveryboyID,deliveryBoyName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userID = prefs.getString("userId");

    debugPrint("user_id$userID");
    debugPrint("delivery boy id$deliveryboyID");
    debugPrint("order id${widget.orderId}");
    final dataBody = {
      "userid": userID,
      "did": deliveryboyID,
      "oid": widget.orderId,

    };
    var response =
    await http.post(Uri.parse(assignDeliveryBoyApi), body: dataBody);
    var body = jsonDecode(response.body);

    debugPrint(body.toString());
    if(body["success"]==1){
      setState(() {

      });
      Singleton.showmsg(context, "Message", "Delivery Boy $deliveryBoyName\nAssigned Successfully!");
    }
    else{
      Singleton.showmsg(context, "Message", "Something Went Wrong");

    }

    debugPrint(body.toString());
  }
}
