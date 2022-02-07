import 'dart:convert';

import 'package:big_basket_vendor/constant/api.dart';
import 'package:big_basket_vendor/constant/constant.dart';
import 'package:big_basket_vendor/screens/product_list/add_product.dart';
import 'package:big_basket_vendor/screens/product_list/product_list.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../constant/constant.dart';

class CategorySubCategory extends StatefulWidget{
  @override
  State<CategorySubCategory> createState() => _CategorySubCategoryState();
}

class _CategorySubCategoryState extends State<CategorySubCategory> {
  bool expand = false;
  bool SubcategoryLoading = true;


  int? tapped;
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);


  List<String> categoryName = [];
  List<String> BannerImageList = [];
  List<String> categoryImage = [];
  List<String> subcategoryName = [];
  List<String> fruitName = [];
  List<String> categoryId = [];
  List<String> SubcategoryId = [];
  var sendcategoryId ;
  var subList = [];
  String? addressID;

  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    getCategoryData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

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
              child:const Icon(Icons.add,color: Colors.white,),
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
      body:isLoading == true
          ? Center(child: loaderWidget())
          : Scaffold(
           appBar: AppBar(
             backgroundColor: themeColor,
             title: Text(applicationName,style: GoogleFonts.poppins(fontSize: fontw500),),
           ),

        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(

            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  debugPrint('List item $index tapped $expand');
                  setState(() {
                    sendcategoryId = categoryId[index];
                    SubcategoryLoading = true;
                    debugPrint(categoryId[index] + "this is id");
                    /// XOR operand returns when either or both conditions are true
                    /// `tapped == null` on initial app start, [tapped] is null
                    /// `index == tapped` initiate action only on tapped item
                    /// `!expand` should check previous expand action
                    getsubcategoryData(categoryId[index]);
                    expand = ((tapped == null) || ((index == tapped) || !expand)) ? !expand : expand;
                    /// This tracks which index was tapped
                    tapped = index;
                    debugPrint('current expand state: $expand');
                  });
                },
                /// We set ExpandableListView to be a Widget
                /// for Home StatefulWidget to be able to manage
                /// ExpandableListView expand/retract actions
                child: expandableListView(
                  index,
                  categoryName[index],

                  index == tapped? expand: false,
                ),
                // child: ExpandableListView(
                //   title: "Title $index",
                //   isExpanded: expand,
                // ),
              );
            },
            itemCount: categoryName.length,
          ),
        ),
      ),
    );
  }

  Widget expandableListView(int index, String title, bool isExpanded) {
    debugPrint('List item build $index $isExpanded');
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.0),
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(paddingLess),
                    child: Card(
                      //elevation: elevation_size,
                      child: Container(
                          height: 60,
                          child: ClipRRect(
                              borderRadius: new BorderRadius.only(
                                  topRight: Radius.circular(00.0),
                                  topLeft: Radius.circular(10.0)),
                              child: CachedNetworkImage(
                                errorWidget: (context, url, error) => Image.network(
                                    "https://t3.ftcdn.net/jpg/04/34/72/82/360_F_434728286_OWQQvAFoXZLdGHlObozsolNeuSxhpr84.jpg"),

                                placeholder: (context, url) => Center(
                                  child: Image.asset(
                                      "assets/images/image_loader.gif",scale: loaderScale,),
                                ),
                                imageUrl: categoryImage[index],

                                // width: MediaQuery.of(context).size.width/1.9,
                                fit: BoxFit.fill,
                              ))),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(title,
                        style: GoogleFonts.poppins(
                            fontSize: fontBold,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                IconButton(
                    icon: Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.black,
                          size: 18.0,
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        //   expandFlag = !expandFlag;

                        sendcategoryId = categoryId[index];
                        SubcategoryLoading = true;
                        debugPrint(categoryId[index] + "this is id");

                        /// XOR operand returns when either or both conditions are true
                        /// `tapped == null` on initial app start, [tapped] is null
                        /// `index == tapped` initiate action only on tapped item
                        /// `!expand` should check previous expand action
                        getsubcategoryData(categoryId[index]);
                        expand =
                        ((tapped == null) || ((index == tapped) || !expand))
                            ? !expand
                            : expand;

                        /// This tracks which index was tapped
                        tapped = index;
                        debugPrint('current expand state: $expand');
                      });
                    }),
              ],
            ),
          ),
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: ExpandableContainer(
              expanded: isExpanded,
              expandedHeight:  53.5*subcategoryName.length,
              child:  ListView.builder(
                //   shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,

                //  scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return SubcategoryLoading == true
                      ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.purple,
                        strokeWidth: 1,
                      ))
                      : Container(
                    decoration: BoxDecoration(
                        border:
                        Border.all(width: 1.0, color: Colors.white),
                        color: Colors.white),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            debugPrint(sendcategoryId.toString());
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductList(subcategoryName:subcategoryName[index],categoryName:categoryName[index],
                                        categoryid:categoryId[index],SubcategoryId:SubcategoryId[index]
                                    )));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              subcategoryName[index].toString(),
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontSize: 12),
                            ),
                          ),
                          // leading: Icon(
                          //   Icons.local_pizza,
                          //   color: Colors.black,
                          // ),

                          // leading: Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Text("       "),
                          // ),


                        ),
                        Divider(),
                      ],
                    ),
                  );
                },
                itemCount: subcategoryName.length,
              ),
            ),
          ),


        ],
      ),
    );
  }
  getCategoryData() async {

    var response = await http.get(Uri.parse(categoriesApi));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      categoryName.clear();
      categoryImage.clear();
      categoryId.clear();


      for (int i = 0; i < data["result"].length; i++) {
        categoryName.add(data["result"][i]["name"]);
        categoryImage.add(data["result"][i]["imgpath"]);
        categoryId.add(data["result"][i]["id"]);

      }



      setState(() {
        // addressID = prefs.getString('userAddress');

        isLoading = false;
      });
    } else {
      debugPrint("Error in the Api");
    }
  }
  getsubcategoryData(categoryid) async {
    var response = await http.get(Uri.parse("$subCategoriesApi?category=${categoryid}"));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      debugPrint(data.toString());

      // categoryName.clear();
      // categoryImage.clear();
      subcategoryName.clear();
      SubcategoryId.clear();

      var s = [];

      for (int i = 0; i < data["result"].length; i++) {
        subcategoryName.add(data["result"][i]["name"]);
        //  subcategoryImage.add(data["result"][i]["imgpath"]);
        SubcategoryId.add(data["result"][i]["id"]);

      }

      setState(() {
        SubcategoryLoading = false;
      });
    } else {
      debugPrint("Error in the Api");
    }
  }

}

class ExpandableContainer extends StatelessWidget {
  final bool expanded;
  final double collapsedHeight;
  final double expandedHeight;
  final Widget child;

  ExpandableContainer({
    required this.child,
    this.collapsedHeight = 0.0,
    this.expandedHeight = 200.0,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: screenWidth,
      height: expanded ? expandedHeight : collapsedHeight,
      child: Container(
        child: child,
        decoration:
        BoxDecoration(border: Border.all(width: 1.0, color: Colors.transparent)),
      ),
    );
  }

}