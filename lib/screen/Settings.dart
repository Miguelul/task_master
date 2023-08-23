import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:package_info/package_info.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:share/share.dart';
import 'package:taskapp/model/User.dart' as mUser;
import 'package:taskapp/screen/AboutUs.dart';
import 'package:taskapp/screen/EditProfile.dart';
import 'package:taskapp/screen/login.dart';
import 'package:taskapp/utils/AppGlobal.dart';
import 'package:taskapp/utils/AppTheme.dart';
import 'package:taskapp/utils/Constants.dart';
import 'package:taskapp/utils/SharedPref.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ChangePassword.dart';

class Settings extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return SettingsState();
  }
}

class SettingsState extends State<Settings>
{
  final GoogleSignIn googleSignIn = GoogleSignIn();
  SharedPref sharedPref= SharedPref();

  TextStyle itemTitleStyle = TextStyle(fontFamily: 'AppLight', fontSize: 16.0, color: AppTheme.appBlack);
  TextStyle itemDescStyle = TextStyle(fontFamily: 'AppLight', fontSize: 14.0, color: AppTheme.appPlaceHolder);

  TextStyle titleStyle = TextStyle(fontFamily: 'AppLight', fontSize: 18.0, color: AppTheme.appWhite);

  TextStyle nameStyle = TextStyle(fontFamily: 'AppBold', fontSize: 18.0, color: AppTheme.appWhite);
  TextStyle emailStyle = TextStyle(fontFamily: 'AppLight', fontSize: 15.0, color: AppTheme.appWhite);

  late TextEditingController nameInputController;

  bool _saving=false;

  bool _showChangePasswordBlock=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    nameInputController = new TextEditingController();

    _showChangePasswordBlock=AppGlobal.userLoad.loginType=="Normal"?true:false;
  }

  loadSharedPrefs() async {
    try {
      mUser.User user = mUser.User.fromJson(await sharedPref.read("user"));

      setState(() {
        AppGlobal.userLoad = user;
      });
    }
    catch (Exception) {
    }
  }

  Widget getArrowImage()
  {
    return Image(
      image: AssetImage("assets/images/ic_down_arrow.png"),
      color: AppTheme.cardItemArrow,
      height: 20,
      width: 20,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:ModalProgressHUD(
        child:Container(
          decoration: BoxDecoration(
            color: AppTheme.appWhite
          ),
          child: Center(
            child: Column(
              children: <Widget>[

                Container(
                  padding: EdgeInsets.fromLTRB(10,0,10,0),
                  width: MediaQuery.of(context).copyWith().size.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppTheme.layer1,AppTheme.layer2,AppTheme.layer3]
                    ),
                  ),
                  child: Column(
                      children: <Widget>[
                        SizedBox(height: 50.0),
                        //Text("Settings",style: nameStyle,),
                        Stack(
                          children: <Widget>[
                            Align(
                                alignment: Alignment.centerRight,
                                child: new GestureDetector(
                                    onTap: () {

                                      sharedPref.saveBool(isLogin,false);
                                      //sharedPref.saveBool(isLoginType,false);

                                      mUser.User user=mUser.User();

                                      sharedPref.save("user",user);

                                      AppGlobal.flutterLocalNotificationsPlugin.cancelAll();

                                      if(AppGlobal.userLoad.loginType!.compareTo("Normal")==0)
                                      {
                                        signOutNormal();
                                      }
                                      else
                                      {
                                        signOutGoogle();
                                      }

                                    },
                                    child:Padding(
                                      padding: EdgeInsets.fromLTRB(0,0,5,0),
                                     child: Image(
                                       image: AssetImage("assets/images/ic_logout.png"),
                                       height: 25,
                                       width: 25,
                                     ),
                                    )
                                )
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text("Settings",style: titleStyle,),
                            )
                          ],
                        ),
                        SizedBox(height: 5),
                        GestureDetector(
                          onTap: () {
                            navigationChangeProfilePage();
                            //_openUserDialog(context);
                          },
                          child:Padding(
                            padding: EdgeInsets.fromLTRB(10, 20, 5, 20),
                            child:Row(
                              children: <Widget>[
                                (AppGlobal.userLoad.imagePath!.isEmpty || AppGlobal.userLoad.imagePath==null)?
                                Image(
                                  image: AssetImage("assets/images/ic_user_with_circle.png"),
                                  color: AppTheme.appPlaceHolder,
                                  height: 55,
                                  width: 55,
                                ):
                                Container(
                                  width: 55,
                                  height: 55,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                      fit: BoxFit.cover,
                                      image: new NetworkImage(AppGlobal.userLoad.imagePath!),
                                    )
                                  )
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(AppGlobal.userLoad.name!,style: nameStyle,),
                                        //SizedBox(height: 2,),
                                        Text(AppGlobal.userLoad.email!,style: emailStyle,),
                                      ]
                                  ),
                                ),
                                Container(
                                  height: 35,
                                  width: 35,
                                  decoration: new BoxDecoration(
                                    color: AppTheme.iconCircle,
                                    borderRadius: new BorderRadius.circular(20)
                                  ),
                                  child: Center(
                                    child: Image(
                                      image: AssetImage("assets/images/ic_pencil.png"),
                                      height: 15,
                                      width: 15,
                                    ),
                                  ),
                                ),


                              ],
                            )
                        ),
                        )
                      ]
                  ),
                ),



                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      margin: new EdgeInsets.fromLTRB(10,10,10,0), // Or set whatever you want
                      child:Column(
                        children: <Widget>[
                          SizedBox(height: 10),

                          Visibility(
                            visible: _showChangePasswordBlock,
                            child:  new GestureDetector(
                                onTap: () {
                                  navigationChangePasswordPage();
                                },
                                child: Card(
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  color: AppTheme.cardItemBack,
                                  elevation: 0,
                                  child:  Padding(
                                      padding: EdgeInsets.fromLTRB(10, 13, 10, 13),
                                      child:Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Text("Change Password",style: itemTitleStyle),
                                          ),
                                          getArrowImage(),
                                          /*RotatedBox(
                                              quarterTurns: 3,
                                              child: */
                                          //),
                                        ],
                                      )
                                  ),
                                )
                            ),
                          ),


                          new GestureDetector(
                              onTap: () {
                                _aboutUs();
                              },
                              child: Card(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                color: AppTheme.cardItemBack,
                                elevation: 0,
                                child:  Padding(
                                  padding: EdgeInsets.fromLTRB(10, 13, 10, 13),
                                  child:Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text("About Us",style: itemTitleStyle),
                                      ),
                                      getArrowImage(),
                                    ],
                                  )
                                ),
                              )
                          ),
                          new GestureDetector(
                              onTap: () {
                                _shareApp();
                              },
                              child: Card(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                color: AppTheme.cardItemBack,
                                elevation: 0,
                                child:  Padding(
                                    padding: EdgeInsets.fromLTRB(10, 13, 10, 13),
                                    child:Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text("Tell a Friend",style: itemTitleStyle),
                                        ),
                                        getArrowImage(),
                                      ],
                                    )
                                ),
                              )
                          ),
                          new GestureDetector(
                              onTap: () {
                                _contactUs();
                              },
                              child: Card(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                color: AppTheme.cardItemBack,
                                elevation: 0,
                                child:  Padding(
                                    padding: EdgeInsets.fromLTRB(10, 13, 10, 13),
                                    child:Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text("Contact Us",style: itemTitleStyle),
                                        ),
                                        getArrowImage(),
                                      ],
                                    )
                                ),
                              )
                          ),
                          new GestureDetector(
                              onTap: () {
                                _rateUs();
                              },
                              child: Card(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                color: AppTheme.cardItemBack,
                                elevation: 0,
                                child:  Padding(
                                    padding: EdgeInsets.fromLTRB(10, 13, 10, 13),
                                    child:Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text("Rate Us",style: itemTitleStyle),
                                        ),
                                        getArrowImage(),
                                      ],
                                    )
                                ),
                              )
                          ),
                          new GestureDetector(
                              onTap: () {
                                _privacyPolicy();
                              },
                              child: Card(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                color: AppTheme.cardItemBack,
                                elevation: 0,
                                child:  Padding(
                                    padding: EdgeInsets.fromLTRB(10, 13, 10, 13),
                                    child:Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text("Privacy Policy",style: itemTitleStyle),
                                        ),
                                        getArrowImage(),
                                      ],
                                    )
                                ),
                              )
                          ),

                        ],
                      )
                    ),
                  ),
                ),

                /*Divider(
                  color: AppTheme.tabUnselected,
                  thickness: 1,
                  height: 1,
                ),*/

              ],
            ),
          ),
        ), inAsyncCall: _saving ),
    );
  }

  void throwError(PlatformException error,BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error.message!),
    ));
  }

  _shareApp() async
  {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;

    String shareText="I have been using $appName and I think you might like it. "
        "Check it out on your phone: https://play.google.com/store/apps/details?id=$packageName";

    Share.share(shareText);
  }

  _contactUs()
  {
    var url = 'mailto:youremail@gmail.com';
    launch(url);
  }

  _privacyPolicy()
  {
    var url = 'https://www.example.com/privacypolicy.html';
    launch(url);
  }

  void _aboutUs() {
    Navigator.of(context).push(_createAddTaskRoute()).then((onValue) {

    });
  }

  Route _createAddTaskRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => AboutUsScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }

  _rateUs() async
  {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;

    RateMyApp rateMyApp = RateMyApp(
      preferencesPrefix: '$appName',
      minDays: 0,
      minLaunches: 20,
      remindDays: 7,
      remindLaunches: 10,
      googlePlayIdentifier: '$packageName',
      appStoreIdentifier: '1491556149',
    );

    rateMyApp.init().then((_) {

      print("==============CALL======================");

      //if (rateMyApp.shouldOpenDialog) {
        //print("==============CALL IF======================");
        rateMyApp.showRateDialog(
          context,
          title: 'Rate this app', // The dialog title.
          message: 'If you like this app, please take a little bit of your time to review it !\nIt really helps us and it shouldn\'t take you more than one minute.', // The dialog message.
          rateButton: 'RATE', // The dialog "rate" button text.
          noButton: 'NO THANKS', // The dialog "no" button text.
          laterButton: 'MAYBE LATER', // The dialog "later" button text.
          listener: (button) { // The button click listener (useful if you want to cancel the click event).
            switch(button) {
              case RateMyAppDialogButton.rate:
                print('Clicked on "Rate".');
                break;
              case RateMyAppDialogButton.later:
                print('Clicked on "Later".');
                break;
              case RateMyAppDialogButton.no:
                print('Clicked on "No".');
                break;
            }

            return true; // Return false if you want to cancel the click event.
          },
          //ignoreNativeDialog: false, // Set to false if you want to show the native Apple app rating dialog on iOS.
          dialogStyle: DialogStyle(), // Custom dialog styles.
          onDismissed: () => rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
          // actionsBuilder: (_) => [], // This one allows you to use your own buttons.
        );

        // Or if you prefer to show a star rating bar :

        /*rateMyApp.showStarRateDialog(
          context,
          title: 'Rate this app', // The dialog title.
          message: 'You like this app ? Then take a little bit of your time to leave a rating :', // The dialog message.
          actionsBuilder: (_, stars) { // Triggered when the user updates the star rating.
            return [ // Return a list of actions (that will be shown at the bottom of the dialog).
              FlatButton(
                child: Text('OK'),
                onPressed: () async {
                  print('Thanks for the ' + (stars == null ? '0' : stars.round().toString()) + ' star(s) !');
                  // You can handle the result as you want (for instance if the user puts 1 star then open your contact page, if he puts more then open the store page, etc...).
                  // This allows to mimic the behavior of the default "Rate" button. See "Advanced > Broadcasting events" for more information :
                  await rateMyApp.callEvent(RateMyAppEventType.rateButtonPressed);
                  Navigator.pop<RateMyAppDialogButton>(context, RateMyAppDialogButton.rate);
                },
              ),
            ];
          },
          ignoreIOS: false, // Set to false if you want to show the native Apple app rating dialog on iOS.
          dialogStyle: DialogStyle( // Custom dialog styles.
            titleAlign: TextAlign.center,
            messageAlign: TextAlign.center,
            messagePadding: EdgeInsets.only(bottom: 20),
          ),
          starRatingOptions: StarRatingOptions(), // Custom star bar rating options.
          onDismissed: () => rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
        );*/
      //}
    });
  }


  void signOutGoogle() async
  {
    await googleSignIn.signOut();

    print("User Sign Out");

    navigationWelcomePage();
  }

  void signOutNormal()
  {
    FirebaseAuth.instance.signOut();

    print("User Sign Out");

    navigationWelcomePage();
  }

  void navigationWelcomePage() {
    //Navigator.of(context).pushReplacementNamed(WelcomeScreen.routeName);
    Navigator.of(context).pushReplacement(_createWelcomeRoute());
  }

  Route _createWelcomeRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }

  void navigationChangePasswordPage() {
    Navigator.of(context).push(_createChangePasswordRoute());
  }

  Route _createChangePasswordRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => ChangePassword(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }

  void navigationChangeProfilePage() {
    Navigator.of(context).push(_createChangeProfileRoute()).then((onValue){
      loadSharedPrefs();
    });
  }

  Route _createChangeProfileRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => EditProfile(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }
}