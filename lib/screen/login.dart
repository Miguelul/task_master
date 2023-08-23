import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

// import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:taskapp/custom/KeyboardHideView.dart';
import 'package:taskapp/model/User.dart' as mUser;
import 'package:taskapp/utils/AppGlobal.dart';
import 'package:taskapp/utils/AppTheme.dart';
import 'package:taskapp/utils/Constants.dart';
import 'package:taskapp/utils/Regex.dart';
import 'package:taskapp/utils/SharedPref.dart';

import 'Home.dart';
import 'signup.dart';

class LoginScreen extends StatefulWidget
{
  static const String routeName = "/login";
  @override
  LoginScreenState createState() => LoginScreenState();
}


class LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin  {

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextStyle style = TextStyle(fontFamily: 'AppRegular', fontSize: 16.0, color: AppTheme.appWhite);


  bool isInternet=false;

  bool _saving = false;

  bool passwordHide = true;

  late TextEditingController emailInputController,passwordInputController;

  late TextEditingController emailForgotInputController;

  mUser.User userSave = mUser.User();
  SharedPref sharedPref= SharedPref();

  @override
  void initState() {
    super.initState();

    passwordHide = true;

    emailInputController = new TextEditingController();
    passwordInputController = new TextEditingController();
    emailForgotInputController = new TextEditingController();

    _checkInternet();


    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Got a new connectivity status!
      if (result == ConnectivityResult.mobile) {
        // I am connected to a mobile network.
        setState(() {
          isInternet=true;
        });
        print("==============I am connected to a mobile network.");

      } else if (result == ConnectivityResult.wifi) {
        // I am connected to a wifi network.
        setState(() {
          isInternet=true;
        });
        print("=========I am connected to a wifi network.");
      }
      else
      {
        setState(() {
          isInternet=false;
        });
        print("===========No internet connection!");
      }
    });
  }

  _checkInternet() async
  {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      setState(() {
        isInternet = true;
      });
      print("========I am connected to a mobile network.");
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      setState(() {
        isInternet = true;
      });
      print("=========I am connected to a wifi network.");
    }
    else
    {
      setState(() {
        isInternet = false;
      });
      print("===========No internet connection!");
    }
  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: new Builder(
          builder: (BuildContext context)
          {
            return ModalProgressHUD(
                child: KeyboardHideView(
                  child: SingleChildScrollView(
                    child: Container(
                        height: MediaQuery.of(context).copyWith().size.height,
                        width: MediaQuery.of(context).copyWith().size.width,
                        decoration: new BoxDecoration(
                          color: AppTheme.lightTheme.primaryColor,
                        ),
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Container(
                            child: Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  Container(
                                    height: MediaQuery.of(context).copyWith().size.height,
                                    width: MediaQuery.of(context).copyWith().size.width*0.8,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text("Hello", style: TextStyle(fontFamily: 'AppBold',
                                                  fontSize: 25.0, color: AppTheme.appWhite),),
                                              Text("Sign into your account", style: TextStyle(fontFamily: 'AppRegular',
                                                  fontSize: 16.0, color: AppTheme.appWhite),),
                                            ]
                                          )
                                        ),
                                        Expanded(
                                            flex: 6,
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  TextFormField(
                                                      controller: emailInputController,
                                                      obscureText: false,
                                                      style: style,
                                                      keyboardType: TextInputType
                                                          .emailAddress,
                                                      autocorrect: true,
                                                      cursorColor: AppTheme.appWhite,
                                                      enableSuggestions: true,
                                                      maxLines: 1,
                                                      textDirection: TextDirection
                                                          .ltr,
                                                      textInputAction: TextInputAction
                                                          .next,
                                                      textAlignVertical: TextAlignVertical
                                                          .center,
                                                      onChanged: (text) {

                                                      },
                                                      decoration: InputDecoration(
                                                        //suffixIcon: Icon(Icons.email),
                                                          labelText: "Email address",
                                                          labelStyle: style,
                                                          contentPadding: EdgeInsets
                                                              .fromLTRB(
                                                              5.0, 5.0, 5.0, 5.0),
                                                          //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                                          //hintText: 'Email address',
                                                          //border:OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                                                          border: new UnderlineInputBorder(
                                                              borderSide: new BorderSide(
                                                                color: AppTheme
                                                                    .appWhite,
                                                              )
                                                          ),
                                                          focusedBorder: new UnderlineInputBorder(
                                                              borderSide: new BorderSide(
                                                                color: AppTheme
                                                                    .appWhite,
                                                              )
                                                          ),
                                                          enabledBorder: new UnderlineInputBorder(
                                                              borderSide: new BorderSide(
                                                                color: AppTheme
                                                                    .appWhite,
                                                              )
                                                          )
                                                        //focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                                                      ),
                                                      focusNode: _emailFocus,
                                                      onFieldSubmitted: (term) {
                                                        _fieldFocusChange(
                                                            context, _emailFocus,
                                                            _passwordFocus);
                                                      }
                                                  ),
                                                  SizedBox(height: 20.0),
                                                  TextFormField(
                                                    controller: passwordInputController,
                                                    obscureText: passwordHide,


                                                    style: style,
                                                    //keyboardType: TextInputType.numberWithOptions(signed: false,decimal: false),
                                                    keyboardType: TextInputType
                                                        .visiblePassword,
                                                    autocorrect: true,
                                                    cursorColor: AppTheme.appWhite,
                                                    enableSuggestions: true,
                                                    maxLines: 1,
                                                    textDirection: TextDirection.ltr,
                                                    textInputAction: TextInputAction
                                                        .done,
                                                    textAlignVertical: TextAlignVertical
                                                        .center,
                                                    onChanged: (text) {

                                                    },
                                                    decoration: InputDecoration(
                                                        contentPadding: EdgeInsets
                                                            .fromLTRB(
                                                            5.0, 5.0, 5.0, 5.0),
                                                        labelText: 'Password',
                                                        labelStyle: style,
                                                        //border:OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                                                        border: new UnderlineInputBorder(
                                                            borderSide: new BorderSide(
                                                              color: AppTheme
                                                                  .appWhite,
                                                            )
                                                        ),
                                                        focusedBorder: new UnderlineInputBorder(
                                                            borderSide: new BorderSide(
                                                              color: AppTheme
                                                                  .appWhite,
                                                            )
                                                        ),
                                                        enabledBorder: new UnderlineInputBorder(
                                                            borderSide: new BorderSide(
                                                              color: AppTheme
                                                                  .appWhite,
                                                            )
                                                        ),
                                                      suffixIcon: IconButton(
                                                          icon:Icon(
                                                            passwordHide ? Icons.visibility : Icons.visibility_off,
                                                            color: AppTheme.appWhite,
                                                          ),
                                                          onPressed: () {
                                                            // Update the state i.e. toogle the state of passwordVisible variable
                                                            setState(()
                                                            {
                                                              passwordHide = !passwordHide;
                                                            });
                                                          }
                                                      ),
                                                    ),
                                                    focusNode: _passwordFocus,
                                                    onFieldSubmitted: (value) {
                                                      _passwordFocus.unfocus();
                                                      //_login();
                                                    },
                                                  ),
                                                  SizedBox(height: 10.0),
                                                  new GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        emailForgotInputController.text = "";
                                                      });

                                                      showDialog(context: context,builder: (BuildContext context2) {
                                                        return Dialog(
                                                          shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20.0)),
                                                          child: Container(
                                                            height: 240,
                                                            width: MediaQuery.of(context).copyWith().size.width,
                                                            child: Padding(
                                                              padding: const EdgeInsets
                                                                  .fromLTRB(25.0,10.0,25.0,10.0),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment
                                                                    .center,
                                                                crossAxisAlignment: CrossAxisAlignment
                                                                    .center,
                                                                children: [
                                                                  //SizedBox(height: 10.0),
                                                                  Text(
                                                                      "RECOVERY EMAIL",
                                                                      style: new TextStyle(
                                                                        fontSize: 16,
                                                                        color: AppTheme
                                                                            .appBlack,
                                                                        fontFamily: "AppRegular")),
                                                                  SizedBox(
                                                                      height: 20.0),
                                                                  TextFormField(
                                                                    controller: emailForgotInputController,
                                                                    obscureText: false,
                                                                    style: new TextStyle(
                                                                        fontSize: 22,
                                                                        color: AppTheme
                                                                            .appGrey,
                                                                        fontFamily: "AppRegular"),
                                                                    keyboardType: TextInputType
                                                                        .emailAddress,
                                                                    autocorrect: true,
                                                                    cursorColor: AppTheme
                                                                        .lightTheme
                                                                        .primaryColor,
                                                                    enableSuggestions: true,
                                                                    maxLines: 1,
                                                                    textDirection: TextDirection
                                                                        .ltr,
                                                                    textInputAction: TextInputAction
                                                                        .done,
                                                                    textAlignVertical: TextAlignVertical
                                                                        .center,
                                                                    onChanged: (
                                                                        text) {

                                                                    },
                                                                    decoration: InputDecoration(
                                                                      //suffixIcon: Icon(Icons.email),
                                                                      //labelText: "E-Mail",
                                                                      //labelStyle: new TextStyle(fontSize: 22,color: AppTheme.appGrey,fontFamily: "HelveticaNeueLightItalic"),
                                                                        hintText: "example@email.com",
                                                                        hintStyle: new TextStyle(
                                                                            fontSize: 22,
                                                                            color: AppTheme
                                                                                .appGrey,
                                                                            fontFamily: "AppRegular"),
                                                                        contentPadding: EdgeInsets
                                                                            .fromLTRB(
                                                                            5.0,
                                                                            5.0,
                                                                            5.0,
                                                                            5.0),
                                                                        //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                                                        //hintText: 'Email address',
                                                                        //border:OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                                                                        border: new UnderlineInputBorder(
                                                                            borderSide: new BorderSide(
                                                                              color: AppTheme
                                                                                  .greyBorder,
                                                                            )
                                                                        ),
                                                                        focusedBorder: new UnderlineInputBorder(
                                                                            borderSide: new BorderSide(
                                                                              color: AppTheme
                                                                                  .greyBorder,
                                                                            )
                                                                        ),
                                                                        enabledBorder: new UnderlineInputBorder(
                                                                            borderSide: new BorderSide(
                                                                              color: AppTheme
                                                                                  .greyBorder,
                                                                            )
                                                                        )
                                                                      //focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height: 30.0),
                                                                  MaterialButton(
                                                                    child: Text(
                                                                        "SUBMIT",
                                                                        style: new TextStyle(
                                                                            fontSize: 17,
                                                                            fontFamily: "AppBold")),
                                                                    onPressed: () {
                                                                      FocusScope
                                                                          .of(
                                                                          context)
                                                                          .requestFocus(
                                                                          FocusNode());
                                                                      ScaffoldMessenger.of(
                                                                          context)
                                                                          .hideCurrentSnackBar();

                                                                      if (emailForgotInputController
                                                                          .text
                                                                          .trim()
                                                                          .isEmpty) {
                                                                        ScaffoldMessenger
                                                                            .of(
                                                                            context)
                                                                            .showSnackBar(
                                                                            SnackBar(
                                                                              content: Text(
                                                                                  'Please enter email address'),
                                                                            ));
                                                                      }
                                                                      else
                                                                      if (!Regex
                                                                          .email
                                                                          .hasMatch(
                                                                          emailForgotInputController
                                                                              .text
                                                                              .trim())) {
                                                                        print(
                                                                            "Please enter valid email address");
                                                                        ScaffoldMessenger
                                                                            .of(
                                                                            context)
                                                                            .showSnackBar(
                                                                            SnackBar(
                                                                              content: Text(
                                                                                  'Please enter valid email address'),
                                                                            ));
                                                                      }
                                                                      else {
                                                                        _forgotPassword(
                                                                            context);
                                                                      }
                                                                    },
                                                                    color: AppTheme
                                                                        .appButton,
                                                                    textColor: AppTheme
                                                                        .appWhite,
                                                                    padding: EdgeInsets
                                                                        .fromLTRB(
                                                                        50, 10,
                                                                        50, 10),
                                                                    splashColor: AppTheme
                                                                        .appButton,
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: new BorderRadius
                                                                          .circular(
                                                                          25.0),
                                                                      side: BorderSide(
                                                                          color: AppTheme
                                                                              .appButton),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                    },
                                                    child: new Text("Forgot Password?",style: new TextStyle(
                                                        fontSize: 15,
                                                        color: AppTheme.txtBlue,
                                                        fontFamily: "AppRegular")),
                                                  ),
                                                  SizedBox(height: 50.0),
                                                  Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child:MaterialButton(
                                                            child: Text("LOG IN", style: new TextStyle(
                                                                fontSize: 16,
                                                                fontFamily: "AppBold")),
                                                            onPressed: () {
                                                              FocusScope.of(context).requestFocus(FocusNode());
                                                              ScaffoldMessenger.of(context).hideCurrentSnackBar();

                                                              if (emailInputController.text.trim().isEmpty) {
                                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                  content: Text('Please enter email address'),
                                                                ));
                                                              }
                                                              else if (!Regex.email.hasMatch(emailInputController.text.trim())) {
                                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                  content: Text('Please enter valid email address'),
                                                                ));
                                                              }
                                                              else if (passwordInputController.text.trim().isEmpty) {
                                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                  content: Text('Please enter password'),
                                                                ));
                                                              }
                                                              else if(passwordInputController.text.trim().length<6)
                                                              {
                                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                  content: Text('Password must be 6 characters long'),
                                                                ));
                                                              }
                                                              else {
                                                                _login(context);
                                                              }
                                                            },
                                                            color: AppTheme.appButton,
                                                            textColor: AppTheme.appWhite,
                                                            padding: EdgeInsets.fromLTRB(
                                                                20, 13, 20, 13),
                                                            splashColor: AppTheme.appButton,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: new BorderRadius
                                                                  .circular(
                                                                  25.0),
                                                              side: BorderSide(color: AppTheme
                                                                  .appButton),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                  ),
                                                  SizedBox(height: 30.0),
                                                  Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child:MaterialButton(
                                                            child: Row(
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: <Widget>[
                                                                Image(
                                                                  image: AssetImage("assets/images/google.png"),
                                                                  height: 20,
                                                                  width: 20,
                                                                ),
                                                                SizedBox(width: 10,),
                                                                Text("Sign in with Google", style: new TextStyle(
                                                                    fontSize: 16,
                                                                    fontFamily: "AppBold"))
                                                              ],
                                                            ),
                                                            onPressed: () {
                                                              if(!isInternet)
                                                              {
                                                                print("Internet not available");
                                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                  content: Text('Internet not available'),
                                                                ));
                                                              }
                                                              else {
                                                                _signInWithGoogle(context);
                                                              }
                                                            },
                                                            color: AppTheme.appWhite,
                                                            textColor: AppTheme.txtGrey,
                                                            padding: EdgeInsets.fromLTRB(
                                                                20, 13, 20, 13),
                                                            splashColor: AppTheme.appButton,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: new BorderRadius
                                                                  .circular(
                                                                  25.0),
                                                              side: BorderSide(color: AppTheme
                                                                  .appWhite),
                                                            ),
                                                          ),
                                                        )
                                                      ]
                                                  ),
                                               ]
                                            )
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text("Don't have an account?", style: new TextStyle(
                                                      fontSize: 18,
                                                      color: AppTheme.appWhite,
                                                      fontFamily: "AppRegular")),
                                                  SizedBox(height: 10,),
                                                  new GestureDetector(
                                                      onTap: () {
                                                        openSignUp();
                                                      },
                                                      child:Text("REGISTER", style: new TextStyle(
                                                            fontSize: 18,
                                                            color: AppTheme.txtBlue,
                                                            fontFamily: "AppRegular")
                                                      ),
                                                  ),
                                                ]
                                            )
                                        ),
                                      ]
                                    )
                                  )
                                ]
                            )
                        )
                    ),
                  ),
                ),
                inAsyncCall: _saving,
                progressIndicator: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(AppTheme.appWhite),
                ),
            );
          }
      )
    );
  }






  _signInWithGoogle(BuildContext context) async
  {
    setState(() {
      _saving=true;
    });

    googleSignIn.signIn().then((googleSignInAccount)
    {
      googleSignInAccount!.authentication.then((googleSignInAuthentication) async{

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult = await _auth.signInWithCredential(credential);
        final User user = authResult.user!;

        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);

        final User currentUser = _auth.currentUser!;
        assert(user.uid == currentUser.uid);

        print("ERROR 0 "+user.toString());

        FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .set(
            {
              "uid": user.uid,
              "name": user.displayName,
              "email": user.email,
              "user_type": "Google",
              "device_type": Platform.isAndroid?"Android":"iOS",
              "profilePhoto": user.photoURL,
            })
            .then((result) => onGoogleSuccess(user))
            .catchError((err) => throwError(err,context));
      })
      .catchError((onError){
        setState(() {
          _saving=false;
        });
        print("ERROR 1 "+onError.toString());
      });
    })
    .catchError((onError){
      setState(() {
        _saving=false;
      });
      print("ERROR 2 "+onError.toString());
    });
  }

  void onGoogleSuccess(User user) async
  {
    userSave.id=user.uid;
    userSave.name=user.displayName;
    userSave.email=user.email;
    userSave.loginType="Google";
    userSave.imagePath=user.photoURL;

    sharedPref.save("user", userSave);
    sharedPref.saveBool(isLogin, true);
    sharedPref.save(isLoginType, "Google");

    setState(() {
      AppGlobal.userLoad = userSave;
    });

    openHomePage();
  }

  _login(BuildContext context) async
  {
    setState(() {
      _saving = true;
    });

    FirebaseAuth.instance
        .signInWithEmailAndPassword(
        email: emailInputController.text.toString().trim(),
        password: passwordInputController.text.toString().trim())
        .then((currentUser) => onSuccess(currentUser.user!)
    ).catchError((err) => throwError(err,context));
  }

  void onSuccess(User user) async
  {
    var document = FirebaseFirestore.instance.collection('users').doc(user.uid);
    document.get().then((document)
    {
        print("================"+document['name']);

        setState(() {
          _saving = false;
        });

        print("============Complete=============");

        userSave.id=user.uid;
        userSave.name=document['name'];
        userSave.imagePath=document['profilePhoto'];
        userSave.email=emailInputController.text.toString().trim();
        userSave.loginType="Normal";

        sharedPref.save("user", userSave);
        sharedPref.saveBool(isLogin, true);
        sharedPref.save(isLoginType, "Normal");

        setState(() {
          AppGlobal.userLoad = userSave;
        });

        openHomePage();
    });
  }

  void throwError(PlatformException error,BuildContext context) {
    setState(() {
      _saving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error.message!),
    ));
  }

  _forgotPassword(BuildContext context) async
  {
    setState(() {
      _saving = true;
    });

    FirebaseAuth.instance.sendPasswordResetEmail(email: emailForgotInputController.text.toString().trim())
        .then((value) {
          setState(() {
            _saving = false;
          });
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Reset password link send into your email'),
          ));
        })
        .catchError((err) => throwError(err,context));
  }

  void openHomePage() {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    ));
  }

  void openSignUp() {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SignUpScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    ));
  }
}