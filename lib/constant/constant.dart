import 'package:flutter/material.dart';

const fontw500 = 12.0;
const fontBold = 14.0;
const cardBorderRadius = 8.0;
const cardElevation = 2.0;
const paddingLess = 2.0;
const paddingMore = 10.0;
const loaderScale = 5.0;
const sizedBoxHeight = 10.0;
const sizedBoxlessHeight = 4.0;
String applicationName = "Moti Confectionary";

Color themeColor = Colors.green.shade400;
Color backgroundColor = Colors.blueGrey.shade50;
Color redColor = Colors.redAccent.shade200;
Color lightFontColor = Colors.black54;

loaderWidget(){
  return Image.asset("assets/images/loading_page.gif",scale: loaderScale,);
}
