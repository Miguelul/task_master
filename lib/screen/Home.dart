import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:taskapp/screen/Settings.dart';
import 'package:taskapp/screen/TodoCompletedTask.dart';
import 'package:taskapp/screen/TodoTask.dart';
import 'package:taskapp/utils/AppGlobal.dart';
import 'package:taskapp/utils/AppTheme.dart';

PageController ?_pageController;
int _page = 0;

class HomeScreen extends StatefulWidget
{
  static const String routeName = "/home";
  @override
  HomeScreenState createState() => HomeScreenState();

  showRecipesTab()
  {
    _pageController!.jumpToPage(1);
  }
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin  {

  TextStyle tabStyle = TextStyle(fontFamily: 'HelveticaNeueRegular', fontSize: 12.0, color: AppTheme.tabUnselected);
  TextStyle tabSelectedStyle = TextStyle(fontFamily: 'HelveticaNeueRegular', fontSize: 12.0, color: AppTheme.tabSelected);

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: 0);

    setState(() {
      _page=0;
    });

    _initFlutterNotification();

    if(Platform.isIOS)
      {
        _notificationPermission();
      }

    initializeDateFormatting();

    /*var format = DateFormat.yMd('fr_FR');
    var dateString = format.format(DateTime.now());

    var format2 = DateFormat.yMd('en_IN');
    var dateString2 = format2.format(DateTime.now());

    print("================="+dateString+"=========="+dateString2+"============="+
        format.pattern.toString()+"===================="+format2.pattern+"============"+Intl.getCurrentLocale().toString());*/

    //DateTime selectedDate=DateTime.parse("4/14/2020");



    print("============"+DateFormat.yMd().add_Hm().parse("4/14/2020 18:50").toString());

  }

  // ignore: missing_return
  Future onSelectNotification(String? payload)
  async {
    try{
      /*showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("ALERT"),
          content: Text("CONTENT: $payload"),
        ));*/
    }
    catch(Exception){}
  }

  Future onDidReceiveLocalNotification(int ?id, String ?title, String ?body, String? payload) async
  {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title!),
        content: Text(body!),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
             /* Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SecondScreen(payload),
                ),
              );*/
            },
          )
        ],
      ),
    );
  }

  _initFlutterNotification()
  {
    AppGlobal.flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    //var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var android = AndroidInitializationSettings('drawable/ic_notification_app_icon');
    //var android = AndroidInitializationSettings('app_icon');
    var iOS = IOSInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initSettings = InitializationSettings(android: android, iOS: iOS);
    AppGlobal.flutterLocalNotificationsPlugin.initialize(initSettings,onSelectNotification: onSelectNotification);
  }

  _notificationPermission() async
  {
    await AppGlobal.flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }


  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }



  void navigationTapped(int page) {
    _pageController!.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {

    //Locale tempLocale=Localizations.localeOf(context);
    //print("================="+tempLocale.languageCode+"====="+tempLocale.countryCode);

    return WillPopScope(
        onWillPop: () => _exitApp(context),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: _pageController,
            onPageChanged: onPageChanged,
            children: <Widget>[
              TodoTask(),
              TodoCompleteTask(),
              Settings()
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
              elevation: 15,
              backgroundColor: AppTheme.appWhite,
              type: BottomNavigationBarType.fixed,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Image(
                      image: AssetImage("assets/images/ic_to_do.png"),
                      color: _page==0?AppTheme.tabSelected:AppTheme.tabUnselected,
                      height: 30,
                      width: 30,
                    ),
                    activeIcon: Column(
                      children: <Widget>[
                        SizedBox(height: 10,),
                        Text("Task",style: _page==0?tabSelectedStyle:tabStyle),
                      ],
                    ),
                ),
                BottomNavigationBarItem(
                    icon: Image(
                      image: AssetImage("assets/images/ic_complete_task.png"),
                      color: _page==1?AppTheme.tabSelected:AppTheme.tabUnselected,
                      height: 30,
                      width: 30,
                    ),
                    activeIcon: Column(
                      children: <Widget>[
                        SizedBox(height: 10,),
                        Text("Completed Task",style: _page==1?tabSelectedStyle:tabStyle),
                      ],
                    ),
                ),
                BottomNavigationBarItem(
                    icon: Image(
                      image: AssetImage("assets/images/ic_settings.png"),
                      color: _page==2?AppTheme.tabSelected:AppTheme.tabUnselected,
                      height: 30,
                      width: 30,
                    ),
                    activeIcon: Column(
                      children: <Widget>[
                        SizedBox(height: 10,),
                        Text("Settings",style: _page==2?tabSelectedStyle:tabStyle),
                      ],
                    ),
                ),
              ],
              currentIndex: _page,
              onTap: navigationTapped,
              ),
            )
    );
  }

  Future<bool> _exitApp(BuildContext context) async
  {
    //return false;
    return Future.value(true);
  }
}