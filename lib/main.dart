import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:taskapp/utils/Constants.dart';
// import 'package:native_admob_flutter/native_admob_flutter.dart';

import 'screen/Home.dart';
import 'screen/login.dart';
import 'screen/signup.dart';
import 'screen/splashView.dart';
import 'utils/AppTheme.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
    appId: apiKey ,
    apiKey: apiKey,
    messagingSenderId: 'your_messaging_sender_id',
    projectId: 'task-app-3001e',
    databaseURL: 'https://task-app-3001e.firebaseio.com',
    storageBucket: 'your_storage_bucket',
    authDomain: 'your_auth_domain',
    measurementId: 'your_measurement_id',
  ),
  );
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
