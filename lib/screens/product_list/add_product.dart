import 'dart:convert';
import 'dart:io';
import 'package:big_basket_vendor/constant/api.dart';
import 'package:big_basket_vendor/constant/constant.dart';
import 'package:big_basket_vendor/constant/singleton.dart';
import 'package:big_basket_vendor/screens/dashboard/bottom_navigation.dart';
import 'package:big_basket_vendor/screens/product_list/variant_modalclass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController productTitleController = TextEditingController();
  TextEditingController productDetailsController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  TextEditingController productAvailableStock = TextEditingController();
  TextEditingController productDiscountController = TextEditingController();
  List VariantsOptionDynamicNameList = [];

  var currentSelectedValue1;
  var currentSelectedValue2;
  var currentSelectedValue3;
  var selectVariants;
  bool visibleImage = false;
  bool visibleBtn = true;
  bool isLoading = true;
  var _image;
  ImagePicker picker = ImagePicker();
  late final getVariantsModalclass;
  var variantAdded;

  // List<String> deviceTypes = ["Mac", "Windows", "Mobile"];
  List<String> productStatus = ["Active", "DeActive"];
  List<String> categoryName = [];
  List<String> categoryImage = [];
  List<String> categoryId = [];
  List<String> subcategoryName = [];
  List<String> VariantsName = [];
  List<String> VariantsID = [];
  List<String> SubcategoryId = [];
  List<String> variantOptionsNameList = [];
  List<List<String>> variantOptionsdropdownName = [];
  List<List<String>> sendVariantID = [];
  List<List<String>> variantOptionshowName = [];
  List<String> sendPrice = [];
  List<String> variantOptionsIdList = [];
  String? CategoryID;
  String? SubCategoryID;
  String? variantid;
  List<String> selectvariantOptions = [];
  List<String> variantOptionsdropdownID = [];
  var variantOptionslength = 0;
  List<String> variantOptionsName3 = [];
  List<String> variantOptionsId3 = [];

  @override
  void initState() {
    // TODO: implement initState
    getCategoryData();
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    productTitleController.dispose();
    productDetailsController.dispose();
    productPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: themeColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(CupertinoIcons.xmark_circle)),
        title: Column(
          children: [
            Text("ADD Product",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500, fontSize: 14)),
          ],
        ),
      ),
      body: isLoading == true
          ? Center(
        child: loaderWidget(),
      )
          : SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),


            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2),
                    child: TextField(
                      controller: productTitleController,
                      decoration: InputDecoration(
                          hintText: "Enter Product Title",
                          labelText: "Product Title"),
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "Product Category",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  categoryDropdown(),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "Product Sub-Category",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  subCategoryDropdown(),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "Product Variants Type",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  VariantsDropdown(),
                  SizedBox(
                    height: 10,
                  ),
                  VariantsOptionDropdown(),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 5),

                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                            child: TextField(
                              keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                              controller: productPriceController,
                              decoration: const InputDecoration(

                                  hintText: "Price", labelText: "Price"),
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500, fontSize: 14),
                            ),
                          ),
                        ),

                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                               if(productPriceController.text.isEmpty){
                                 Singleton.showmsg(context, "Message", "Add Price for this variant");
                               }else {

                                 variantAdded = "1";
                                 debugPrint(
                                     "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" +
                                         selectvariantOptions.toString());
                                 debugPrint("cccccccccccccccc" +
                                     variantOptionsName3.toString());
                                 debugPrint("bbbbbbbbbbbbbbbbbbbbbbbbbbbbb" +
                                     variantOptionsId3.toString());

                                 List<String> s = [];
                                 for (int i = 0; i <
                                     variantOptionsName3.length; i++) {
                                   if (selectvariantOptions.contains(
                                       variantOptionsName3[i])) {
                                     s.add(variantOptionsId3[i]);
                                   }
                                 }

                                 debugPrint("sssssssssssssssssssss$s");

                                 sendVariantID.add(s);


                                 sendPrice.add(productPriceController.text);
                                 variantOptionshowName.add(selectvariantOptions);
                                 debugPrint("thissss isss output" +
                                     "vars:"+sendVariantID.toString());
                                 debugPrint("thissss isss sendPrice output" +
                                     "price:"+sendPrice.toString());

                                 debugPrint("thissss isss sendPrice output" +
                                     sendPrice.toString());
                                 // setState(() {


                                 variantOptionsName3.clear();
                                 productPriceController.clear();
                                 variantOptionsdropdownID.clear();
                                 selectvariantOptions.clear();
                                 VariantsOptionDynamicNameList.clear();
                                 variantOptionsdropdownName.clear();
                                 variantOptionsId3.clear();
                                 variantOptionslength = 0;
                                 setState(() {

                                 });
                               }
                              // });
                            },
                            child: Row(
                              children: [
                                Icon(CupertinoIcons.add),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Text("Add Variant",
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: themeColor,
                                // padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                                textStyle: GoogleFonts.poppins(
                                  // fontSize: 30,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Product Status",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                  ),
                  threeDropdown(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                    child: TextField(
                      controller: productDetailsController,
                      decoration: InputDecoration(
                          hintText: "Product Description",
                          labelText: "Product Detail"),
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          child: TextField(
                            controller: productAvailableStock,
                            decoration: InputDecoration(
                                hintText: "Avaiable Stock", labelText: "Quantity"),
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500, fontSize: 14),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          child: TextField(
                            controller: productDiscountController,
                            decoration: InputDecoration(
                                hintText: "Discount%", labelText: "Discount%"),
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500, fontSize: 14),
                          ),
                        ),
                      )
                    ],
                  ),
                  Visibility(
                    visible: visibleBtn,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 55.0, vertical: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            visibleImage = true;
                            visibleBtn = false;
                          });
                        },
                        child: Row(
                          children: [
                            Icon(Icons.camera_alt_outlined),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Text("Upload Image",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: themeColor,
                            // padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                            textStyle: GoogleFonts.poppins(
                              // fontSize: 30,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: visibleImage,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  _showPicker(context);
                                },
                                child: CircleAvatar(
                                  radius: 55,
                                  // backgroundColor: Color(0xffFDCF09),
                                  backgroundColor: Colors.transparent,
                                  child: _image != null
                                      ? ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(5),
                                    child: Image.file(
                                      _image,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.fill,
                                    ),
                                  )
                                      : Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                        BorderRadius.circular(5)),
                                    width: 100,
                                    height: 100,
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Expanded(
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(2.0),
                        //     child: Center(
                        //       child: GestureDetector(
                        //         onTap: () {
                        //           _showPicker(context);
                        //         },
                        //         child: CircleAvatar(
                        //           radius: 55,
                        //           // backgroundColor: Color(0xffFDCF09),
                        //           backgroundColor: Colors.transparent,
                        //           child: _image != null
                        //               ? ClipRRect(
                        //             borderRadius:
                        //             BorderRadius.circular(5),
                        //             child: Image.file(
                        //               _image,
                        //               width: 100,
                        //               height: 100,
                        //               fit: BoxFit.fill,
                        //             ),
                        //           )
                        //               : Container(
                        //             decoration: BoxDecoration(
                        //                 color: Colors.grey[200],
                        //                 borderRadius:
                        //                 BorderRadius.circular(5)),
                        //             width: 100,
                        //             height: 100,
                        //             child: Icon(
                        //               Icons.camera_alt,
                        //               color: Colors.grey[800],
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // Expanded(
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(2.0),
                        //     child: Center(
                        //       child: GestureDetector(
                        //         onTap: () {
                        //           _showPicker(context);
                        //         },
                        //         child: CircleAvatar(
                        //           radius: 55,
                        //           // backgroundColor: Color(0xffFDCF09),
                        //           backgroundColor: Colors.transparent,
                        //           child: _image != null
                        //               ? ClipRRect(
                        //             borderRadius:
                        //             BorderRadius.circular(5),
                        //             child: Image.file(
                        //               _image,
                        //               width: 100,
                        //               height: 100,
                        //               fit: BoxFit.fill,
                        //             ),
                        //           )
                        //               : Container(
                        //             decoration: BoxDecoration(
                        //                 color: Colors.grey[200],
                        //                 borderRadius:
                        //                 BorderRadius.circular(5)),
                        //             width: 100,
                        //             height: 100,
                        //             child: Icon(
                        //               Icons.camera_alt,
                        //               color: Colors.grey[800],
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50.0, vertical: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              _asyncFileUpload(_image);
                            },
                            child: Text("ADD Product",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold)),
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
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget categoryDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: FormField<String>(
        builder: (FormFieldState<String> state) {
          return InputDecorator(
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0))),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                hint: Text(
                  "Select Category",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, fontSize: 14),
                ),
                value: currentSelectedValue1,
                isDense: true,
                onChanged: (newValue) {
                  setState(() {
                    String? getcategoryID;
                    currentSelectedValue1 = newValue;
                    for (int i = 0; i < categoryName.length; i++) {
                      if (currentSelectedValue1 == categoryName[i]) {
                        getcategoryID = categoryId[i];

                        CategoryID = categoryId[i];
                      }
                      getsubcategoryData(getcategoryID);
                    }
                  });
                },
                items: categoryName.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget subCategoryDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: FormField<String>(
        builder: (FormFieldState<String> state) {
          return InputDecorator(
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0))),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                hint: Text(
                  "Select Sub-Category",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, fontSize: 14),
                ),
                value: currentSelectedValue2,
                isDense: true,
                onChanged: (newValue) {
                  setState(() {
                    currentSelectedValue2 = newValue;
                    for (int i = 0; i < categoryName.length; i++) {
                      if (currentSelectedValue2 == subcategoryName[i]) {
                        SubCategoryID = SubcategoryId[i];
                      }
                    }
                  });
                },
                items: subcategoryName.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget threeDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: FormField<String>(
        builder: (FormFieldState<String> state) {
          return InputDecorator(
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0))),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                hint: Text(
                  "Select Product Status",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, fontSize: 14),
                ),
                value: currentSelectedValue3,
                isDense: true,
                onChanged: (newValue) {
                  setState(() {
                    currentSelectedValue3 = newValue;
                  });
                },
                items: productStatus.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: GoogleFonts.poppins(
                          color: value == "Active" ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget VariantsDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: FormField<String>(
        builder: (FormFieldState<String> state) {
          return InputDecorator(
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0))),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                hint: Text(
                  "Select Variants",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, fontSize: 14),
                ),
                value: selectVariants,
                isDense: true,
                onChanged: (newValue) {
                  setState(() {
                    for (int i = 0; i < VariantsName.length; i++) {
                      if (newValue == VariantsName[i]) {
                        variantid = VariantsID[i];
                        variantOptionsApi(variantid, newValue, i);
                      }
                    }
                    selectVariants = newValue;
                  });
                },
                items: VariantsName.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget VariantsOptionDropdown() {
    return Column(
      children: List.generate(variantOptionslength, (index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: FormField<String>(
              builder: (FormFieldState<String> state) {
                return InputDecorator(
                  decoration: InputDecoration(
                      labelText:
                      '${VariantsOptionDynamicNameList[index]} Options',
                      labelStyle:
                      GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      hint: Text(
                        "${VariantsOptionDynamicNameList[index]} Option",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      value: selectvariantOptions[index],
                      isDense: true,
                      onChanged: (newValue) {
                        setState(() {
                          selectvariantOptions[index] = newValue!;

                          for (int i = 0; i < variantOptionsName3.length; i++) {
                            if (variantOptionsName3[i] ==
                                selectvariantOptions[index]) {
                              variantOptionsdropdownID[index] =
                              variantOptionsId3[i];
                            }
                          }
                        });
                      },
                      items:
                      variantOptionsdropdownName[index].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500, fontSize: 14),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }

  getCategoryData() async {
    var response = await http.get(Uri.parse(categoriesApi));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      categoryName.clear();
      categoryId.clear();

      for (int i = 0; i < data["result"].length; i++) {
        categoryName.add(data["result"][i]["name"]);
        categoryId.add(data["result"][i]["id"]);
      }

      setState(() {
        // addressID = prefs.getString('userAddress');
        getData();
        //isLoading = false;
      });
    } else {
      debugPrint("Error in the Api");
    }
  }

  getsubcategoryData(categoryid) async {
    var response =
    await http.get(Uri.parse("$subCategoriesApi?category=${categoryid}"));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      debugPrint(data.toString());

      subcategoryName.clear();
      SubcategoryId.clear();

      for (int i = 0; i < data["result"].length; i++) {
        subcategoryName.add(data["result"][i]["name"]);
        //  subcategoryImage.add(data["result"][i]["imgpath"]);
        SubcategoryId.add(data["result"][i]["id"]);
      }

      setState(() {
        //   SubcategoryLoading = false;
      });
    } else {
      debugPrint("Error in the Api");
    }
  }

  variantOptionsApi(variantId, VariantsName, index) async {
    List<String> variantOptionsName2 = [];
    List<String> variantOptionsId2 = [];

    var response =
    await http.get(Uri.parse("$variantsOptionApi?variant=$variantId"));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      debugPrint(data.toString());

      variantOptionsIdList.clear();

      for (int i = 0; i < data["result"].length; i++) {
        variantOptionsNameList.add(data["result"][i]["name"]);
        variantOptionsName2.add(data["result"][i]["name"]);
        variantOptionsName3.add(data["result"][i]["name"]);
        //  subcategoryImage.add(data["result"][i]["imgpath"]);
        variantOptionsIdList.add(data["result"][i]["id"]);
        variantOptionsId2.add(data["result"][i]["id"]);
        variantOptionsId3.add(data["result"][i]["id"]);
      }
      if (VariantsOptionDynamicNameList.contains(VariantsName)) {} else {
        VariantsOptionDynamicNameList.add(VariantsName);
        variantOptionsdropdownName.add(variantOptionsName2);
        variantOptionsdropdownID.add(variantOptionsId2[0]);
        selectvariantOptions.add(variantOptionsName2[0]);

        debugPrint(
            "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa${variantOptionsdropdownName
                .toString()}");
        variantOptionslength++;
      }
      setState(() {
        //   SubcategoryLoading = false;
      });
    } else {
      debugPrint("Error in the Api");
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }


  _imgFromGallery() async {
    XFile? image = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = File(image!.path);
    });
  }

  _imgFromCamera() async {
    XFile? image = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = File(image!.path);
    });
  }

  _asyncFileUpload(File file) async {


    if(variantAdded != "1"){
      Singleton.showmsg(context, "Message", "Please Add Variants");
    }
    else {
      String activeStatus = "";
      if (currentSelectedValue3 == "Active") {
        activeStatus = "1";
      } else {
        activeStatus = "0";
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final userID = prefs.getString("userId");

      //create multipart request for POST or PATCH method
      var request = http.MultipartRequest("POST", Uri.parse(addProductsApi));
      //add text fields
      request.fields["userid"] = userID.toString();
      request.fields["name"] = productTitleController.text.toString();
      request.fields["description"] = productDetailsController.text.toString();
      request.fields["stock"] = productAvailableStock.text.toString();
      request.fields["category"] = CategoryID.toString();
      request.fields["subcategory"] = SubCategoryID.toString();
      request.fields["status"] = activeStatus;
      request.fields["discount"] = productDiscountController.text;
      request.fields["variants"] = json.encode(sendVariantID);
      request.fields["price"] = json.encode(sendPrice);
      request.fields["pincodes"] = "700018";
      request.fields["findicator"] = "1";
      //create multipart using filepath, string or bytes
      var pic = await http.MultipartFile.fromPath("imgpath", file.path);
      //add multipart to request
      request.files.add(pic);
      var response = await request.send();

      debugPrint(response.toString() + "this is response");


      //Get the response from the server
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);

      debugPrint(responseString.toString());
      if (responseString.contains("Product Added Successfully")) {
        Navigator.of(context, rootNavigator: true).push(
            CupertinoPageRoute(builder: (context) =>
                DashBoardNew()));
        Singleton.showmsg(context, "Message", "Product Added SuccessFully");
      }
    }
  }

  getData() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // final userID = prefs.getString("userId");
    var response = await http.get(Uri.parse("$variantsApi"));
    var body = jsonDecode(response.body);
    debugPrint(body.toString());
    VariantsName.clear();
    getVariantsModalclass = getVariantsModalclassFromJson(response.body);
    for (int i = 0; i < getVariantsModalclass.result.length; i++) {
      VariantsName.add(getVariantsModalclass.result[i].name);
      VariantsID.add(getVariantsModalclass.result[i].id);
    }
    isLoading = false;
    setState(() {});
  }

  Widget dynamicListview() {
    // print("this is findword $findWord");
    return LayoutBuilder(builder: (context, constraints) {
      return ListView.builder(
          itemCount: variantOptionshowName.length,
          //  itemCount: title.length,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Column(
              children: [
                Row(
                  children: [
                    Text(variantOptionshowName[index].toString()),
                    Text(sendPrice[index]),
                  ],
                )
              ],
            );
          }
      );
    });
  }
}
