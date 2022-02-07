import 'dart:convert';

import 'package:big_basket_vendor/constant/api.dart';
import 'package:big_basket_vendor/constant/constant.dart';
import 'package:big_basket_vendor/screens/product_list/add_product.dart';
import 'package:big_basket_vendor/screens/product_list/product_modalclass.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class ProductList extends StatefulWidget {
  final categoryid;
  final SubcategoryId;
  final categoryName;
  final subcategoryName;
  const ProductList({Key? key, this.categoryid, this.SubcategoryId, this.categoryName, this.subcategoryName}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  bool isLoading = true;
  late final productListModalclass;
  int? noProductFlag;
  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: backgroundColor,
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          openCloseDial: isDialOpen,
          backgroundColor: themeColor,
          overlayColor: Colors.grey,
          overlayOpacity: 0.6,
          spacing: 15,
          closeDialOnPop: true,
          spaceBetweenChildren: 15,
          closeManually: false,
          children: [
            SpeedDialChild(
                child:const Icon(Icons.add,color: Colors.white),
                label: 'ADD Products',
                labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                backgroundColor: themeColor,
                elevation: 10,
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddProduct()));
                }),

          ],
        ),
        appBar: AppBar(
          backgroundColor: themeColor,
          title: Column(
            children: [
              Text("product List",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, fontSize: 16)),
            ],
          ),
        ),
        body:isLoading == true?Center(child:
        loaderWidget(),) :noProductFlag == 1?Center(child:Image.asset("assets/images/no_product_found.png")): SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Text(
                    "Products (${productListModalclass.result.length.toString()})",
                    style:  GoogleFonts.assistant(fontWeight: FontWeight.w500),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12,horizontal: 10),
                        child: Text(widget.categoryName,
                            style: GoogleFonts.assistant(
                                fontWeight: FontWeight.bold, fontSize: fontBold)),
                      ),

                   const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 10,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                             vertical: 12,horizontal: 5),
                        child: Text(
                          widget.subcategoryName,
                          style: GoogleFonts.cherrySwash(
                            color: themeColor,
                              fontWeight: FontWeight.w500, fontSize: fontw500),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  color: backgroundColor,
                  child: dynamicListview(),
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
        itemCount: productListModalclass.result.length,
        //  itemCount: title.length,
        shrinkWrap: true,
         physics: const BouncingScrollPhysics(),

        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(paddingLess),
            child: Card(
              elevation: cardElevation,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(cardBorderRadius)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(

                        flex: 3,

                          child: SizedBox(
                           height: 100,
                            child: CachedNetworkImage(
                              placeholder: (context, url) =>  Center(child: Image.asset("assets/images/image_loader.gif")),
                              errorWidget: (context, url, error) =>Image.asset("assets/images/no_image_available.jpg"),

                              imageUrl: productListModalclass.result[index].imgs[0].imgpath,
                                fit: BoxFit.fitHeight,

                            ),
                          )),


                          Expanded(
                            flex:4,
                            child: Padding(
                              padding: const EdgeInsets.all(paddingMore),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(productListModalclass.result[index].name,style: GoogleFonts.poppins(
                                    fontSize: fontBold,fontWeight: FontWeight.w600
                                  ),),
                                  Text("Qty 1",style: GoogleFonts.poppins(
                                      fontSize: fontBold,fontWeight: FontWeight.w400
                                  ),),
                                  const SizedBox(height: 20,),
                                  Text("Total:${productListModalclass.result[index].opts[0].price}",style: GoogleFonts.poppins(
                                      fontSize: fontBold,fontWeight: FontWeight.w700,color: redColor
                                  ),),
                                ],
                              ),

                            ),
                          ),

                      Padding(
                        padding: const EdgeInsets.all(paddingMore),

                        child: Row(
                          children: const [
                            // Icon(Icons.mode_edit_outline_sharp,size: 18),
                            // SizedBox(width: 15,),
                            Icon(CupertinoIcons.delete,size: 18,)
                          ],
                        ),
                      )




                    ],
                  ),

                ],
              )),
          );

        },
      );
    });
  }

  getData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userID = prefs.getString("userId");
    debugPrint("$viewProductsApi?userid=$userID&subcategory=${widget.SubcategoryId}&category=${widget.categoryid}");

    var response = await http.get(Uri.parse("$viewProductsApi?userid=$userID&subcategory=${widget.SubcategoryId}&category=${widget.categoryid}"));
    var body = jsonDecode(response.body);
    debugPrint(body.toString());

    if(body["status"] == "400"){
      noProductFlag = 1;
    }else {
      noProductFlag=0;
      productListModalclass = productListModalclassFromJson(response.body);
    }

    isLoading = false;
    setState(() {});

  }
}
