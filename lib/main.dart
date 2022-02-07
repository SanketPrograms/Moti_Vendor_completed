import 'package:big_basket_vendor/constant/constant.dart';
import 'package:big_basket_vendor/screens/dashboard/bottom_navigation.dart';
import 'package:big_basket_vendor/screens/login_screen/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  var status = false;
  status = prefs.getBool('isLoggedIn') ?? false;
  runApp(MaterialApp(

    color: themeColor,
    // routes: {
    //   "/login": (context) => Login(),
    // },
      debugShowCheckedModeBanner: false,
      home: status == true ? DashBoardNew() : Login()));
}
