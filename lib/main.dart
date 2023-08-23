import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:native_admob_flutter/native_admob_flutter.dart';

import 'screen/Home.dart';
import 'screen/login.dart';
import 'screen/signup.dart';
import 'screen/splashView.dart';
import 'utils/AppTheme.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  Admob.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Master',
      theme: AppTheme.lightTheme, // define your theme
      debugShowCheckedModeBanner: false,
      home: SplashView(),
      routes: <String, WidgetBuilder>{
        // define the routes
        LoginScreen.routeName: (BuildContext context) => LoginScreen(),
        SignUpScreen.routeName: (BuildContext context) => SignUpScreen(),
        HomeScreen.routeName: (BuildContext context) => HomeScreen(),
      },
    );
  }
}
