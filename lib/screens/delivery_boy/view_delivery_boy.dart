import 'dart:convert';

import 'package:big_basket_vendor/constant/api.dart';
import 'package:big_basket_vendor/constant/constant.dart';
import 'package:big_basket_vendor/screens/delivery_boy/view_delivery_modalclass.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ViewDeliveryBoy extends StatefulWidget {
  const ViewDeliveryBoy({Key? key}) : super(key: key);

  @override
  State<ViewDeliveryBoy> createState() => _ViewDeliveryBoyState();
}

class _ViewDeliveryBoyState extends State<ViewDeliveryBoy> {
  late final viewDeliveryModalclass;
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return isLoading == true?Center(child:
    loaderWidget(),) :Container(
       child: dynamicListview(),
    );
  }

  getData() async{

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

  Widget dynamicListview() {
    // print("this is findword $findWord");
    return LayoutBuilder(builder: (context, constraints) {
      return ListView.builder(
          itemCount: viewDeliveryModalclass.result.length,
          //  itemCount: title.length,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),

    itemBuilder: (context, index) {
    return Card(
      child: Column(
        children: [
          ListTile(title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(viewDeliveryModalclass.result![index].name,style: GoogleFonts.poppins(fontWeight: FontWeight.bold),),
          ),
          subtitle:Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(viewDeliveryModalclass.result![index].phone,style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 12),),
                Text(viewDeliveryModalclass.result![index].email,style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 12),),
              ],
            ),
          ),
          // trailing:  ElevatedButton(
          //   onPressed: () {
          //
          //   },
          //   child: Text("Assign",
          //       style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
          //   style: ElevatedButton.styleFrom(
          //       primary: themeColor,
          //       // padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          //       textStyle: GoogleFonts.poppins(
          //         // fontSize: 30,
          //           fontWeight: FontWeight.w500)),
          // ),
          ),
        ],
      ),
    );
    });
  }
    );
  }

}

