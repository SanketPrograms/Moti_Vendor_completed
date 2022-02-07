import 'dart:convert';

import 'package:big_basket_vendor/constant/api.dart';
import 'package:big_basket_vendor/constant/constant.dart';
import 'package:big_basket_vendor/constant/singleton.dart';
import 'package:big_basket_vendor/screens/dashboard/bottom_navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool hidePassword = true;
  bool savePassword = false;
  bool registerBtnLoader = false;
  String? username;
  String? password;
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    getPassword();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/login_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: ListView(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height / 3),
                  welcomeTextWidget(),
                  textControllerWidget(),
                  const SizedBox(
                    height: 60,
                  ),
                  registerBtnLoader == true
                      ? const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 0.5,
                          ),
                        )
                      : loginBtn()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget welcomeTextWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical:20 ),
      child: Text(
        "Welcome",
        textAlign: TextAlign.left,
        style: GoogleFonts.lora(
            textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 25.0,
                fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget textControllerWidget() {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5),
            child: TextField(
              style: const TextStyle(fontSize: 16, color: Colors.white70),
              controller: mobileNumberController,
               inputFormatters: [LengthLimitingTextInputFormatter(10)],
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyanAccent),
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
              // inputFormatters: [LengthLimitingTextInputFormatter(10)],
              obscureText: hidePassword,


              // keyboardType:
              //     const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyanAccent),
                  ),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                      icon: Icon(
                        CupertinoIcons.eye,
                        color: hidePassword == true
                            ? Colors.grey
                            : Colors.cyanAccent,
                      )),
                  // prefixIcon: Icon(Icons.smartphone_outlined),
                  hintText: 'Password',
                  hintStyle: TextStyle(fontSize: 14, color: Colors.grey)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: [
                Transform.scale(
                  scale: 0.6,
                  child: CupertinoSwitch(
                      activeColor: Colors.cyanAccent,
                      // inactiveThumbColor: Colors.white,
                      // inactiveTrackColor: Colors.white70,
                      thumbColor: Colors.white,
                      trackColor: Colors.black,
                      value: savePassword,
                      onChanged: (val) {
                        setState(() {
                          savePassword = !savePassword;
                        });
                      }),
                ),
                Text(
                  "Remember Me",
                  style: GoogleFonts.poppins(color: Colors.white70),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget loginBtn() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  registerBtnLoader = true;
                  sendData(context);
                });
                if (savePassword == true) {
                  setPassword(mobileNumberController.text,
                      passwordController.text, savePassword);
                } else {
                  setPassword("", "", false);
                }
              },
              child: Text("Login",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                  primary: redColor,
                  // padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: GoogleFonts.poppins(
                      // fontSize: 30,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ],
    );
  }

  setPassword(mobileNo, password, switchValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userPassword", password.toString());
    prefs.setString("userNumber", mobileNo.toString());
    prefs.setBool("remember_me", switchValue);
  }

  getPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      password = prefs.getString("userPassword");
      username = prefs.getString("userNumber");
      savePassword = prefs.getBool("remember_me") ?? false;

      mobileNumberController.text = username!;
      passwordController.text = password!;
    });
  }

  sendData(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final dataBody = {
      "phone": mobileNumberController.text.toString(),
      "password": passwordController.text.toString(),
    };
    var response = await http.post(Uri.parse(loginApi), body: dataBody);
    var body = jsonDecode(response.body);
    debugPrint(body.toString());
    debugPrint(body["status"].toString());
    if (response.statusCode == 200) {
      if (body["success"] == 1) {
        setState(() {
          registerBtnLoader = false;

          prefs.setBool("isLoggedIn",true);
          prefs.setString("userId",body["result"]["id"]);
          prefs.setString("email",body["result"]["email"]);
          prefs.setString("name",body["result"]["name"]);


          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DashBoardNew(),
              ));
        });
      } else {
        //todo:comment this line after testing
        if (body["error"] == "User Not Found") {
          setState(() {
            registerBtnLoader = false;
          });
          Singleton.showmsg(context, "Message", "Invalid User Please Register");
        } else {
          setState(() {
            registerBtnLoader = false;
          });
          Singleton.showmsg(context, "Message", "Invalid User");
        }
      }

      debugPrint(body.toString());
    } else {
      setState(() {
        registerBtnLoader = false;
      });
      Singleton.showmsg(context, "Message", body["error"]);
    }
  }
}
