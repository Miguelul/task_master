import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path/path.dart' as Path;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taskapp/custom/KeyboardHideView.dart';
import 'package:taskapp/model/User.dart' as mUser;
import 'package:taskapp/screen/login.dart';
import 'package:taskapp/utils/AppGlobal.dart';

import 'package:taskapp/utils/AppTheme.dart';
import 'package:taskapp/utils/Regex.dart';
import 'package:taskapp/utils/SharedPref.dart';
import 'package:taskapp/utils/constants.dart';


// import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'Home.dart';

class SignUpScreen extends StatefulWidget
{
  static const String routeName = "/signup";
  @override
  SignUpScreenState createState() => SignUpScreenState();
}


class SignUpScreenState extends State<SignUpScreen> with TickerProviderStateMixin  {

  TextStyle style = TextStyle(fontFamily: 'AppRegular', fontSize: 16.0, color: AppTheme.appWhite);

  late AnimationController controller;
  late CurvedAnimation curve;

  bool _saving = false;

  bool passwordHide = true;
  bool passwordHide2 = true;

  late TextEditingController nameInputController,emailInputController,passwordInputController,confirmPasswordInputController;

  mUser.User userSave = mUser.User();
  SharedPref sharedPref= SharedPref();

  File ?_image;
  String _uploadedFileURL="";

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    curve = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    passwordHide = true;
    passwordHide2 = true;

    nameInputController = new TextEditingController();
    emailInputController = new TextEditingController();
    passwordInputController = new TextEditingController();
    confirmPasswordInputController = new TextEditingController();
  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: new Builder(
          builder: (BuildContext context) {
            return ModalProgressHUD(
              /*child:SingleChildScrollView(*/
                child: KeyboardHideView(
                  child:SingleChildScrollView(
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
                                                Text("Create your account", style: TextStyle(fontFamily: 'AppRegular',
                                                    fontSize: 16.0, color: AppTheme.appWhite),),
                                              ]
                                          )
                                      ),
                                      Expanded(
                                          flex: 8,
                                          child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: <Widget>[
                                                new GestureDetector(
                                                    onTap: () {
                                                      chooseFile();
                                                    },
                                                    child:SizedBox(
                                                        height: 100,
                                                        width: 100,
                                                        child:Stack(
                                                        children: <Widget>[
                                                          Align(
                                                            alignment: Alignment.center,
                                                            child: _image != null
                                                                ?Container(
                                                                    width: 80,
                                                                    height: 80,
                                                                    decoration: new BoxDecoration(
                                                                        shape: BoxShape.circle,
                                                                        image: new DecorationImage(
                                                                            fit: BoxFit.cover,
                                                                            image: new FileImage(_image!)
                                                                        )
                                                                    )
                                                                )
                                                                :Image(
                                                                  image: AssetImage("assets/images/ic_user_with_circle.png"),
                                                                  //color: AppTheme.appWhite,
                                                                  height: 80,
                                                                  width: 80,
                                                                )
                                                          ),
                                                          Align(
                                                              alignment: Alignment.bottomRight,
                                                              child: Padding(
                                                                padding: EdgeInsets.fromLTRB(0,0,0,17),
                                                                  child:Image(
                                                                image: AssetImage("assets/images/edit_photo.png"),
                                                                height: 30,
                                                                width: 30,
                                                              ))
                                                          )
                                                        ]
                                                    )
                                                )),
                                                SizedBox(height: 20.0),
                                                TextFormField(
                                                    obscureText: false,
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(30),
                                                      FilteringTextInputFormatter.allow(Regex.onlyCharacter)
                                                    ],
                                                    textCapitalization: TextCapitalization.words,
                                                    controller: nameInputController,
                                                    style: style,
                                                    keyboardType: TextInputType.text,
                                                    autocorrect: true,
                                                    cursorColor: AppTheme.appWhite,
                                                    enableSuggestions: true,
                                                    maxLines: 1,
                                                    textDirection: TextDirection.ltr,
                                                    textInputAction: TextInputAction.next,
                                                    textAlignVertical: TextAlignVertical.center,
                                                    onChanged: (text) {

                                                    },
                                                    decoration: InputDecoration(
                                                        labelText: "Full name",
                                                        labelStyle: style,
                                                        contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                                                        border: new UnderlineInputBorder(
                                                            borderSide: new BorderSide(
                                                              color: AppTheme.appWhite,
                                                            )
                                                        ),
                                                        focusedBorder: new UnderlineInputBorder(
                                                            borderSide: new BorderSide(
                                                              color: AppTheme.appWhite,
                                                            )
                                                        ),
                                                        enabledBorder: new UnderlineInputBorder(
                                                            borderSide: new BorderSide(
                                                              color: AppTheme.appWhite,
                                                            )
                                                        )
                                                    ),
                                                    focusNode: _nameFocus,
                                                    onFieldSubmitted: (term){
                                                      _fieldFocusChange(context, _nameFocus, _emailFocus);
                                                    }
                                                ),
                                                SizedBox(height: 20.0),
                                                TextFormField(
                                                    controller: emailInputController,
                                                    obscureText: false,
                                                    style: style,
                                                    keyboardType: TextInputType.emailAddress,
                                                    autocorrect: true,
                                                    cursorColor: AppTheme.appWhite,
                                                    enableSuggestions: true,
                                                    maxLines: 1,
                                                    textDirection: TextDirection.ltr,
                                                    textInputAction: TextInputAction.next,
                                                    textAlignVertical: TextAlignVertical.center,
                                                    onChanged: (text) {

                                                    },
                                                    decoration: InputDecoration(
                                                        labelText: "Email address",
                                                        labelStyle: style,
                                                        contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                                                        border: new UnderlineInputBorder(
                                                            borderSide: new BorderSide(
                                                              color: AppTheme.appWhite,
                                                            )
                                                        ),
                                                        focusedBorder: new UnderlineInputBorder(
                                                            borderSide: new BorderSide(
                                                              color: AppTheme.appWhite,
                                                            )
                                                        ),
                                                        enabledBorder: new UnderlineInputBorder(
                                                            borderSide: new BorderSide(
                                                              color: AppTheme.appWhite,
                                                            )
                                                        )
                                                    ),
                                                    focusNode: _emailFocus,
                                                    onFieldSubmitted: (term){
                                                      _fieldFocusChange(context, _emailFocus, _passwordFocus);
                                                    }
                                                ),
                                                SizedBox(height: 20.0),
                                                TextFormField(
                                                  controller: passwordInputController,
                                                  obscureText: passwordHide,
                                                  style: style,
                                                  //keyboardType: TextInputType.numberWithOptions(signed: false,decimal: false),
                                                  keyboardType: TextInputType.visiblePassword,
                                                  autocorrect: true,
                                                  cursorColor: AppTheme.appWhite,
                                                  enableSuggestions: true,
                                                  maxLines: 1,
                                                  textDirection: TextDirection.ltr,
                                                  textInputAction: TextInputAction.next,
                                                  textAlignVertical: TextAlignVertical.center,
                                                  onChanged: (text) {

                                                  },
                                                  decoration: InputDecoration(
                                                      contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                                                      labelText: 'Password',
                                                      labelStyle: style,
                                                      //border:OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                                                      border: new UnderlineInputBorder(
                                                          borderSide: new BorderSide(
                                                            color: AppTheme.appWhite,
                                                          )
                                                      ),
                                                      focusedBorder: new UnderlineInputBorder(
                                                          borderSide: new BorderSide(
                                                            color: AppTheme.appWhite,
                                                          )
                                                      ),
                                                      enabledBorder: new UnderlineInputBorder(
                                                          borderSide: new BorderSide(
                                                            color: AppTheme.appWhite,
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
                                                  onFieldSubmitted: (value){
                                                    _fieldFocusChange(context, _passwordFocus, _confirmPasswordFocus);
                                                    //_Register();
                                                  },
                                                ),
                                                SizedBox(height: 20.0),
                                                TextFormField(
                                                  controller: confirmPasswordInputController,
                                                  obscureText: passwordHide2,
                                                  style: style,
                                                  //keyboardType: TextInputType.numberWithOptions(signed: false,decimal: false),
                                                  keyboardType: TextInputType.visiblePassword,
                                                  autocorrect: true,
                                                  cursorColor: AppTheme.appWhite,
                                                  enableSuggestions: true,
                                                  maxLines: 1,
                                                  textDirection: TextDirection.ltr,
                                                  textInputAction: TextInputAction.done,
                                                  textAlignVertical: TextAlignVertical.center,
                                                  onChanged: (text) {

                                                  },
                                                  decoration: InputDecoration(
                                                      contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                                                      labelText: 'Confirm password',
                                                      labelStyle: style,
                                                      //border:OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                                                      border: new UnderlineInputBorder(
                                                          borderSide: new BorderSide(
                                                            color: AppTheme.appWhite,
                                                          )
                                                      ),
                                                      focusedBorder: new UnderlineInputBorder(
                                                          borderSide: new BorderSide(
                                                            color: AppTheme.appWhite,
                                                          )
                                                      ),
                                                      enabledBorder: new UnderlineInputBorder(
                                                          borderSide: new BorderSide(
                                                            color: AppTheme.appWhite,
                                                          )
                                                      ),
                                                    suffixIcon: IconButton(
                                                        icon:Icon(
                                                          passwordHide2 ? Icons.visibility : Icons.visibility_off,
                                                          color: AppTheme.appWhite,
                                                        ),
                                                        onPressed: () {
                                                          // Update the state i.e. toogle the state of passwordVisible variable
                                                          setState(()
                                                          {
                                                            passwordHide2 = !passwordHide2;
                                                          });
                                                        }
                                                    ),
                                                  ),
                                                  focusNode: _confirmPasswordFocus,
                                                  onFieldSubmitted: (value){
                                                    _confirmPasswordFocus.unfocus();
                                                    //_changeText();
                                                  },
                                                ),
                                                SizedBox(height: 50.0),
                                                Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                          child:MaterialButton(
                                                            child: Text("SIGN UP",style: new TextStyle(fontSize: 18,fontFamily: "HelveticaNeueLight")),
                                                            onPressed: () {

                                                              FocusScope.of(context).requestFocus(FocusNode());
                                                              ScaffoldMessenger.of(context).hideCurrentSnackBar();

                                                              if(_image==null)
                                                              {
                                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                  content: Text('Please select profile picture'),
                                                                ));
                                                              }
                                                              else if(nameInputController.text.trim().isEmpty)
                                                              {
                                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                  content: Text('Please enter full name'),
                                                                ));
                                                              }
                                                              else if(emailInputController.text.trim().isEmpty)
                                                              {
                                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                  content: Text('Please enter email address'),
                                                                ));
                                                              }
                                                              else if(!Regex.email.hasMatch(emailInputController.text.trim()))
                                                              {
                                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                  content: Text('Please enter valid email address'),
                                                                ));
                                                              }
                                                              else if(passwordInputController.text.trim().isEmpty)
                                                              {
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
                                                              else if(confirmPasswordInputController.text.trim().isEmpty)
                                                              {
                                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                  content: Text('Please enter confirm password'),
                                                                ));
                                                              }
                                                              else if(confirmPasswordInputController.text.trim().compareTo(passwordInputController.text.trim())!=0)
                                                              {
                                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                  content: Text('Password and Confirm password must be same'),
                                                                ));
                                                              }
                                                              else
                                                              {
                                                                _register(context);
                                                              }
                                                            },
                                                            color: AppTheme.appButton,
                                                            textColor: AppTheme.appWhite,
                                                            padding: EdgeInsets.fromLTRB(20, 13, 20, 13),
                                                            splashColor: AppTheme.appButton,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: new BorderRadius.circular(25.0),
                                                              side: BorderSide(color: AppTheme.appButton),
                                                            ),
                                                          )
                                                      )
                                                    ]
                                                ),
                                                SizedBox(height: 20.0),
                                                new GestureDetector(
                                                  onTap: () {
                                                    openLoginPage();
                                                  },
                                                  child: new Text("Do you already have an account?",style: new TextStyle(
                                                      fontSize: 15,
                                                      color: AppTheme.txtBlue,
                                                      fontFamily: "AppBold")),
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
                  )
                ),
              //),
              inAsyncCall: _saving,
              progressIndicator: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(AppTheme.appWhite),
              ),
            );
          }
        )
    );
  }

  Future chooseFile() async {
    /*await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });*/

    final _picker = ImagePicker();

    PickedFile ?image = await _picker.getImage(source: ImageSource.gallery);
    if(image!=null) {
      setState(() {
        _image = File(image.path);
      });
    }


  }



  _register(BuildContext context) async
  {
    setState(() {
      _saving = true;
    });

    Reference storageReference = FirebaseStorage.instance.ref().child('profiles/${Path.basename(_image!.path)}');
    UploadTask uploadTask = storageReference.putFile(_image!);

    uploadTask.then((onValue){

    storageReference.getDownloadURL().then((fileURL) {
        setState(() {
          _uploadedFileURL = fileURL;
        });

        FirebaseAuth.instance
            .createUserWithEmailAndPassword(
            email: emailInputController.text.toString().trim(),
            password: passwordInputController.text.toString().trim())
            .then((currentUser) =>
            FirebaseFirestore.instance
                .collection("users")
                .doc(currentUser.user!.uid)
                .set(
                {
                  "uid": currentUser.user!.uid,
                  "name": nameInputController.text.toString().trim(),
                  "email": emailInputController.text.toString().trim(),
                  "profilePhoto": _uploadedFileURL,
                  "user_type": "Normal",
                  "device_type": Platform.isAndroid?"Android":"iOS",
                }).then((result) => onSuccess(currentUser.user!))
                .catchError((err) => throwError(err,context))
        ).catchError((err) => throwError(err,context));

    }).catchError((err) {
      setState(() {
        _saving = false;
      });
    });

    }).catchError((err) => throwError(err,context));
  }

  void onSuccess(User user)
  {
    setState(() {
      _saving = false;
    });

    userSave.id=user.uid;
    userSave.name=nameInputController.text.toString().trim();
    userSave.email=emailInputController.text.toString().trim();
    userSave.loginType="Normal";
    userSave.imagePath=_uploadedFileURL;

    sharedPref.save("user", userSave);
    sharedPref.saveBool(isLogin, true);
    sharedPref.save(isLoginType, "Normal");

    setState(() {
      AppGlobal.userLoad = userSave;
    });

    openHomePage();
  }

  void throwError(PlatformException error,BuildContext context)
  {
    setState(() {
      _saving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error.message!),
    ));
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
}