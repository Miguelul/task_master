import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:taskapp/model/User.dart';
import 'package:taskapp/utils/AppGlobal.dart';
import 'package:taskapp/utils/Constants.dart';
import 'package:taskapp/utils/SharedPref.dart';


import 'Home.dart';
import 'login.dart';

class SplashView extends StatefulWidget
{
  static const String routeName = "/splashView";
  @override
  SplashViewState createState() => SplashViewState();
}

class SplashViewState extends State<SplashView>
{
  SharedPref sharedPref= SharedPref();

  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async {

    SharedPreferences pref=await SharedPreferences.getInstance();

    bool? _isLogin=pref.getBool(isLogin);

    if (_isLogin == null) {
      _isLogin = false;
    }

    if(_isLogin) {
      openHomePage();
    }
    else {
      openLoginPage();
    }
  }


  void openHomePage() {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    ));
  }

  void openLoginPage() {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    ));
  }


  @override
  void initState() {
    super.initState();

    loadSharedPrefs();

    startTime();
  }

  loadSharedPrefs() async {
    try {
      User user = User.fromJson(await sharedPref.read("user"));

      setState(() {
        AppGlobal.userLoad = user;
      });
    }
    catch (Exception) {}
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
          decoration: new BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/splash.png"),
              fit: BoxFit.cover
            )
          ),
          child: Center(
            child:Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                    image:AssetImage("assets/images/logo.png"),
                    height: 300,
                    width: 300,
                  ),
                ]
            )
          )
      ),
    );
  }
}