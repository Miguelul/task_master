import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:taskapp/custom/KeyboardHideView.dart';
import 'package:taskapp/model/User.dart' as mUser;
import 'package:taskapp/utils/AppGlobal.dart';

import 'package:taskapp/utils/AppTheme.dart';
import 'package:taskapp/utils/SharedPref.dart';


// import 'package:modal_progress_hud/modal_progress_hud.dart';

class ChangePassword extends StatefulWidget
{
  static const String routeName = "/changePassword";
  @override
  ChangePasswordState createState() => ChangePasswordState();
}


class ChangePasswordState extends State<ChangePassword> with TickerProviderStateMixin  {

  TextStyle appBarTitleStyle = TextStyle(fontFamily: 'AppLight', fontSize: 18.0, color: AppTheme.appWhite);

  TextStyle txtStyle = TextStyle(fontFamily: 'AppLight', fontSize: 16.0, color: AppTheme.appBlack);
  TextStyle lblStyle = TextStyle(fontFamily: 'AppLight', fontSize: 16.0, color: AppTheme.lblColor);

  bool _saving = false;

  bool passwordHide = true;

  late TextEditingController passwordInputController,newPasswordInputController,confirmNewPasswordInputController;

  mUser.User userSave = mUser.User();
  SharedPref sharedPref= SharedPref();

  @override
  void initState() {
    super.initState();

    loadSharedPrefs();

    passwordInputController = new TextEditingController();
    newPasswordInputController = new TextEditingController();
    confirmNewPasswordInputController = new TextEditingController();
  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _newPasswordFocus = FocusNode();
  final FocusNode _confirmNewPasswordFocus = FocusNode();


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


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop: () => _exitApp(context),
    child:Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Change Password',style: appBarTitleStyle,),
            leading: Builder(builder: (BuildContext context) {
              return IconButton(
                  icon: Image(
                    image: AssetImage("assets/images/ic_back.png"),
                    height: 20,
                    width: 20,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }
              );
            })
        ),
        body: new Builder(
            builder: (BuildContext context)
            {
              return KeyboardHideView(
                child: ModalProgressHUD(
                child:Container(
                  height: MediaQuery.of(context).copyWith().size.height,
                  width: MediaQuery.of(context).copyWith().size.width,
                  decoration: new BoxDecoration(
                    color: AppTheme.appWhite,
                  ),
                  padding: EdgeInsets.fromLTRB(20,10,20,10),
                  child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[

                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(height: 20.0),
                                    Text("Current Password", style: lblStyle,),
                                    TextFormField(
                                      controller: passwordInputController,
                                      obscureText: passwordHide,
                                      style: txtStyle,
                                      //keyboardType: TextInputType.numberWithOptions(signed: false,decimal: false),
                                      keyboardType: TextInputType.visiblePassword,
                                      autocorrect: true,
                                      cursorColor: AppTheme.lightTheme.primaryColor,
                                      enableSuggestions: true,
                                      maxLines: 1,
                                      textDirection: TextDirection.ltr,
                                      textInputAction: TextInputAction.next,
                                      textAlignVertical: TextAlignVertical.center,
                                      onChanged: (text) {

                                      },
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
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

                                      ),
                                      focusNode: _passwordFocus,
                                      onFieldSubmitted: (value){
                                        _fieldFocusChange(context, _passwordFocus, _newPasswordFocus);
                                        //_Register();
                                      },
                                    ),
                                    SizedBox(height: 40.0),
                                    Text("New Password", style: lblStyle,),
                                    TextFormField(
                                      controller: newPasswordInputController,
                                      obscureText: passwordHide,
                                      style: txtStyle,
                                      //keyboardType: TextInputType.numberWithOptions(signed: false,decimal: false),
                                      keyboardType: TextInputType.visiblePassword,
                                      autocorrect: true,
                                      cursorColor: AppTheme.lightTheme.primaryColor,
                                      enableSuggestions: true,
                                      maxLines: 1,
                                      textDirection: TextDirection.ltr,
                                      textInputAction: TextInputAction.next,
                                      textAlignVertical: TextAlignVertical.center,
                                      onChanged: (text) {

                                      },
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
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
                                      ),
                                      focusNode: _newPasswordFocus,
                                      onFieldSubmitted: (value){
                                        _fieldFocusChange(context, _newPasswordFocus, _confirmNewPasswordFocus);
                                        //_Register();
                                      },
                                    ),
                                    SizedBox(height: 40.0),
                                    Text("Confirm New Password", style: lblStyle,),
                                    TextFormField(
                                      controller: confirmNewPasswordInputController,
                                      obscureText: passwordHide,
                                      style: txtStyle,
                                      //keyboardType: TextInputType.numberWithOptions(signed: false,decimal: false),
                                      keyboardType: TextInputType.visiblePassword,
                                      autocorrect: true,
                                      cursorColor: AppTheme.lightTheme.primaryColor,
                                      enableSuggestions: true,
                                      maxLines: 1,
                                      textDirection: TextDirection.ltr,
                                      textInputAction: TextInputAction.done,
                                      textAlignVertical: TextAlignVertical.center,
                                      onChanged: (text) {

                                      },
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
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
                                      ),
                                      focusNode: _confirmNewPasswordFocus,
                                      onFieldSubmitted: (value){
                                        _confirmNewPasswordFocus.unfocus();
                                        //_changeText();
                                      },
                                    ),
                                  ]
                              )
                            ),

                            SizedBox(
                              width: double.infinity,
                              child:MaterialButton(
                                child: Text("Change Password",style: new TextStyle(fontSize: 18,fontFamily: "HelveticaNeueLight")),
                                onPressed: () {
                                  //_changeText();

                                  _changePassword(context);

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
                  )
                ), inAsyncCall: _saving
        ),
              );}),
    ));

  }

  _changePassword(BuildContext context) async {

    FocusScope.of(context).requestFocus(FocusNode());
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    if(passwordInputController.text.trim().isEmpty)
    {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter current password'),
      ));
    }
    else if(newPasswordInputController.text.trim().isEmpty)
    {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter new password'),
      ));
    }
    else if(confirmNewPasswordInputController.text.trim().isEmpty)
    {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter new confirm password'),
      ));
    }
    else if(newPasswordInputController.text.trim().compareTo(confirmNewPasswordInputController.text.trim())!=0)
    {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('New password and New confirm password must be same'),
      ));
    }
    else
    {
      setState(() {
        _saving = true;
      });




      FirebaseAuth.instance.signInWithEmailAndPassword(
          email: AppGlobal.userLoad.email!,
          password: passwordInputController.text.toString().trim())
          .then((currentUser)
          {
            _onChangePassword(context);
          }
      ).catchError((err) => throwError(err,context));


    }
  }

  _onChangePassword(BuildContext context) async
  {
    User user = FirebaseAuth.instance.currentUser!;
    //onSuccess(currentUser.user);
    //Pass in the password to updatePassword.
    user.updatePassword(newPasswordInputController.text.trim()).then((_){
      setState(() {
        _saving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Succesfully changed password'),
      ));
      Navigator.pop(context);
    }).catchError((error){
      setState(() {
        _saving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Password can't be changed" + error.toString()),
      ));
    });
  }

  Future<bool> _exitApp(BuildContext context) async
  {
    Navigator.pop(context, false);
    return false;
  }


  void navigationPage() {
    Navigator.pop(context, true);
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
}