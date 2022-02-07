
import 'package:big_basket_vendor/constant/constant.dart';
import 'package:big_basket_vendor/screens/delivery_boy/register_delivery.dart';
import 'package:big_basket_vendor/screens/delivery_boy/view_delivery_boy.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class deliveryHomepage extends StatelessWidget {
  const deliveryHomepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: themeColor,
          title: Text("Delivery Boy",style: GoogleFonts.poppins(
            fontSize: 13,
          ),),
          bottom: TabBar(
            tabs: [
              Tab(text: "Delivery Boys",),
              Tab(text:"Register"),
            ],
          ),
        ),
        body: TabBarView(children: [
          ViewDeliveryBoy(),
          RegisterDeliveryBoy()
        ]),
      ),
    );
  }
}
