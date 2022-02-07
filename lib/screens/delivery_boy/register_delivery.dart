import 'dart:convert';

import 'package:big_basket_vendor/constant/api.dart';
import 'package:big_basket_vendor/constant/constant.dart';
import 'package:big_basket_vendor/constant/singleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RegisterDeliveryBoy extends StatefulWidget {
  const RegisterDeliveryBoy({Key? key}) : super(key: key);

  @override
  State<RegisterDeliveryBoy> createState() => _RegisterDeliveryBoyState();
}

class _RegisterDeliveryBoyState extends State<RegisterDeliveryBoy> {
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  bool registerBtnLoader = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,

      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20,),

            textFieldWidget(),
            SizedBox(height: 50,),
            registerBtnLoader == true
                ? const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 0.5,
                    ),
                  )
                : registerBtn()
          ],
        ),
      ),
    );
  }

  Widget textFieldWidget() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5),
          child: TextField(
            style: const TextStyle(fontSize: 16, color: Colors.white70),
            controller: nameController,
            decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                label: Text(
                  'Full Name',
                  style: GoogleFonts.poppins(
                      fontSize: 12,color: Colors.white
                  ),
                ),
                // prefixIcon: Icon(Icons.smartphone_outlined),
                hintText: 'Delivery Boy Name',
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5),
          child: TextField(
            style: const TextStyle(fontSize: 16, color: Colors.white70),
            controller: emailController,
            decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyanAccent),
                ),
                label: Text(
                  'Email Id',
                  style: GoogleFonts.poppins(fontSize: 12,color:Colors.white),
                ),
                // prefixIcon: Icon(Icons.smartphone_outlined),
                hintText: 'Delivery Boy Email',
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey)),
          ),
        ),
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: 30.0, vertical: 5),
          child: TextField(
            style:  TextStyle(fontSize: 16, color: Colors.white70),
            controller: mobileNumberController,
            inputFormatters: [LengthLimitingTextInputFormatter(10)],
            keyboardType:  TextInputType.numberWithOptions(decimal: true),
            decoration:  InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                label: Text(
                  'Delivery Boy Number',
                  style: GoogleFonts.poppins(fontSize: 12,color:Colors.white),
                ),
                // prefixIcon: Icon(Icons.smartphone_outlined),
                hintText: 'Mobile Number',
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5),
          child: TextField(
            style: const TextStyle(fontSize: 16, color: Colors.white70),
            controller: passwordController,
            decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyanAccent),
                ),
                label: Text(
                  'Password',
                  style: GoogleFonts.poppins(fontSize: 12,color:Colors.white),
                ),
                // prefixIcon: Icon(Icons.smartphone_outlined),
                hintText: 'Delivery Boy Password',
                hintStyle: const TextStyle(fontSize: 14, color: Colors.grey)),
          ),
        ),
      ],
    );
  }

  Widget registerBtn() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  // registerBtnLoader = true;
                  // sendData(context);
                  registerDeliveryBor();
                });
              },
              child: Text("Register",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
              style: ElevatedButton.styleFrom(
                  primary: themeColor,
                  // padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: GoogleFonts.poppins(
                      // fontSize: 30,
                      fontWeight: FontWeight.w500)),
            ),
          ),
        ),
      ],
    );
  }

  registerDeliveryBor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userID = prefs.getString("userId");
    final dataBody = {
      "userid": userID,
      "name": nameController.text,
      "email": emailController.text,
      "phone": mobileNumberController.text.toString(),
      "password": passwordController.text,
    };
    var response =
        await http.post(Uri.parse(registerDeliveryBoyApi), body: dataBody);
    var body = jsonDecode(response.body);
    if(body["success"]==1){
      setState(() {
        nameController.clear();
        emailController.clear();
        mobileNumberController.clear();
        passwordController.clear();
      });
      Singleton.showmsg(context, "Message", "Delivery Boy Added Successfully");
    }
    else{
      Singleton.showmsg(context, "Message", "Something Went Wrong");

    }

    debugPrint(body.toString());
  }
}
