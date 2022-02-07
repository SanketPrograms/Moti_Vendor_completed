import 'dart:convert';

import 'package:big_basket_vendor/constant/api.dart';
import 'package:big_basket_vendor/constant/constant.dart';
import 'package:big_basket_vendor/screens/login_screen/login_page.dart';
import 'package:big_basket_vendor/screens/my_account/get_user_profile.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  var isExpanded = false;
  bool savePassword = false;

       TextEditingController StoreNameController = TextEditingController();
       TextEditingController StoreNumberController = TextEditingController();
       TextEditingController StoreEmailController = TextEditingController();

       String? storeNumber;
       String? BankAccNo;
       String? BankAccName;
       String? BankIfsc;
       bool isLoading = true;
  _onExpansionChanged(bool val) {
    setState(() {
      isExpanded = val;
    });
  }

   // getUserData() async{
   //   SharedPreferences prefs = await SharedPreferences.getInstance();
   //   setState(() {
   //     StoreNameController.text = prefs.getString("name")??"";
   //     StoreNumberController.text = prefs.getString("userNumber")??"";
   //     StoreEmailController.text = prefs.getString("email")??"";
   //
   //   });
   //
   // }
@override
  void initState() {
    // TODO: implement initState
  // getUserData();
  getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Colors.transparent,
      bottomNavigationBar: GestureDetector(
        onTap: () async{
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool("isLoggedIn",false);
          Navigator.of(context,rootNavigator: true).push(CupertinoPageRoute(builder: (context) =>
              Login()));

        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 23.0,vertical: 4),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(Icons.logout,color: redColor,),
              ),
              SizedBox(width: 2,),
              Text("Logout",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, fontSize: 16)),

            ],
          ),
        ),
      ),
        appBar: AppBar(
        backgroundColor: themeColor,
        title: Column(
        children: [
        Text("My Account",
        style: GoogleFonts.poppins(
        fontWeight: FontWeight.w500, fontSize: 16)),
    ],
    ),
        ),
      body: isLoading == true
          ? Center(
        child: loaderWidget(),
      )
          :

      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: TextField(
                  controller: StoreNameController,
                  decoration: InputDecoration(
                      hintText: "Store Name",
                      labelText: "Store Name"),
                  style:
                  GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 14),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: TextField(
                  controller: StoreNumberController,
                  decoration: InputDecoration(
                      hintText: "Phone Number",
                      labelText: "Contact Number To Say Hello"),
                  style:
                  GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 14),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: TextField(
                  controller: StoreEmailController,
                  decoration: InputDecoration(
                      hintText: "Email Address",
                      labelText: "Mail Id"),
                  style:
                  GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 14),
                ),
              ),
               SizedBox(height: 20,),
              Row(
                children: [
                  Text("Store Mobile Number",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500, fontSize: 16)),
                ],
              ),
              Row(
                children: [
                  Text("Not Available",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500, fontSize: 14)),
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
                  ),                ],
              ),
              Divider(thickness: 1,),
              Row(
                children: [
                  Text("Payment Information",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500, fontSize: 14,color: Colors.grey)),
                ],
              ),
        ExpansionTile(
          onExpansionChanged: _onExpansionChanged,
          // IgnorePointeer propogates touch down to tile

          title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("Store Mobile Number (UPI)",style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500, fontSize: 14)),
          ]),
          children: [Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 38.0),
                child: Text(storeNumber.toString(),style: GoogleFonts.poppins(
        fontWeight: FontWeight.w500, fontSize: 14,color: Colors.grey)),
              ),
            ],
          )]
        ),
              ExpansionTile(
                  onExpansionChanged: _onExpansionChanged,
                  // IgnorePointeer propogates touch down to tile

                  title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text("Store Bank Account Name",style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500, fontSize: 14)),
                  ]),
                  children: [Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 38.0),
                        child: Text(BankAccName.toString(),style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500, fontSize: 14,color: Colors.grey)),
                      ),
                    ],
                  )]
              ),
              ExpansionTile(
                  onExpansionChanged: _onExpansionChanged,
                  // IgnorePointeer propogates touch down to tile

                  title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text("Store Bank Account Number",style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500, fontSize: 14)),
                  ]),
                  children: [Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 38.0),
                        child: Text(BankAccNo.toString(),style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500, fontSize: 14,color: Colors.grey)),
                      ),
                    ],
                  )]
              ),
              ExpansionTile(
                  onExpansionChanged: _onExpansionChanged,
                  // IgnorePointeer propogates touch down to tile

                  title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text("Store IFSC Code",style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500, fontSize: 14)),
                  ]),
                  children: [Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 38.0,vertical: 10),
                        child: Text(BankIfsc.toString(),style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500, fontSize: 14,color: Colors.grey)),
                      ),
                    ],
                  )]
              ),
              SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final userID = prefs.getString("userId");
    var response = await http.get(
        Uri.parse("$getProfileApi?userid=$userID"));
    var body = jsonDecode(response.body);
    debugPrint(body.toString());
    final getUserProfileModalclass = getUserProfileModalclassFromJson(response.body);


    storeNumber =  getUserProfileModalclass.result!.phone;
    BankAccNo = getUserProfileModalclass.result!.bankAccNo;
    BankAccName =  getUserProfileModalclass.result!.bankAccName;
    BankIfsc = getUserProfileModalclass.result!.ifscCode;
   StoreNumberController.text = getUserProfileModalclass.result!.phone!;

   StoreNameController.text = getUserProfileModalclass.result!.shopName!;
   StoreEmailController.text = getUserProfileModalclass.result!.email!;


    isLoading = false;
    setState(() {});
  }
}
