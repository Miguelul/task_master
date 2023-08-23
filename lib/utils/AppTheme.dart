import 'package:flutter/material.dart';

class AppTheme {
  static Color lightBG = Color(0xfff3f4f9);

  static Map<int, Color> myColor = {
    50: Color.fromRGBO(90, 80, 170, .1),
    100: Color.fromRGBO(90, 80, 170, .2),
    200: Color.fromRGBO(90, 80, 170, .3),
    300: Color.fromRGBO(90, 80, 170, .4),
    400: Color.fromRGBO(90, 80, 170, .5),
    500: Color.fromRGBO(90, 80, 170, .6),
    600: Color.fromRGBO(90, 80, 170, .7),
    700: Color.fromRGBO(90, 80, 170, .8),
    800: Color.fromRGBO(90, 80, 170, .9),
    900: Color.fromRGBO(90, 80, 170, 1),
  };

  static MaterialColor colorCustom = MaterialColor(0xFF5a50aa, myColor);

  static ThemeData lightTheme = ThemeData(
    backgroundColor: lightBG,
    primaryColor: colorCustom,
    primarySwatch: colorCustom,
    // accentColor:  colorCustom,
    // cursorColor: colorCustom,
    scaffoldBackgroundColor: lightBG,
    appBarTheme: AppBarTheme(
      elevation: 0,
      // Other AppBarTheme properties...
    ),
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.white,
        fontSize: 18,
        // fontWeight: FontWeight.w800,
        fontFamily: 'AppLight',
      ),
      // Other text styles...
    ),
  );

  static Color appColor = Color(0xff5a50aa);

  static Color appWhite = Color(0xffffffff);
  static Color appBlack = Color(0xff000000);
  static Color appGrey = Color(0xff848484);
  static Color appButton = Color(0xfff4a025);
  static Color appButtonGreen = Color(0xff4bab52);
  static Color appButtonGrey = Color(0xffD2D1D1);
  static Color appButtonRed = Color(0xffAB1919);
  static Color appPlaceHolder = Color(0xff979797);
  static Color appBackground = Color(0xffe9e9e9);

  static Color tabSelected = Color(0xff5a50aa);
  static Color tabUnselected = Color(0xffCAC9C9);

  static Color txtBlue = Color(0xff7eb8d3);
  static Color txtGrey = Color(0xff777777);

  static Color txtSearch = Color(0xffb4acdb);
  static Color iconCircle = Color(0xff413395);
  static Color cardItemBack = Color(0xfff3f2f8);
  static Color cardItemArrow = Color(0xff818086);

  static Color layer1 = Color(0xff5a50aa);
  static Color layer2 = Color(0xff5a50aa);
  static Color layer3 = Color(0xff5a50aa);

  static Color taskItemTitle = Color(0xff5a50aa);
  static Color taskItemDesc = Color(0xff909090);
  static Color taskItemTime = Color(0xffc1c4ca);
  static Color taskItemLine = Color(0xffebebeb);

  static Color greyBorder = Color(0xff676767);
  static Color lblColor = Color(0xff5a5a5a);

  static Color dashBorder = Color(0xff585274);
}
