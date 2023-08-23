import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path/path.dart' as Path;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taskapp/custom/KeyboardHideView.dart';
import 'package:taskapp/model/User.dart';
import 'package:taskapp/utils/AppGlobal.dart';

import 'package:taskapp/utils/AppTheme.dart';
import 'package:taskapp/utils/Regex.dart';
import 'package:taskapp/utils/SharedPref.dart';


// import 'package:modal_progress_hud/modal_progress_hud.dart';

class EditProfile extends StatefulWidget
{
  static const String routeName = "/editProfile";
  @override
  EditProfileState createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> with TickerProviderStateMixin  {

  TextStyle appBarTitleStyle = TextStyle(fontFamily: 'AppLight', fontSize: 18.0, color: AppTheme.appWhite);

  TextStyle txtStyle = TextStyle(fontFamily: 'AppLight', fontSize: 16.0, color: AppTheme.appBlack);
  TextStyle lblStyle = TextStyle(fontFamily: 'AppLight', fontSize: 16.0, color: AppTheme.lblColor);

  bool _saving = false;

  bool passwordHide = true;

  TextEditingController ?nameInputController;

  User userSave = User();
  SharedPref sharedPref= SharedPref();

  File ? _image;
  String _uploadedFileURL="";

  @override
  void initState() {
    super.initState();

    loadSharedPrefs();

    nameInputController = new TextEditingController();

    nameInputController!.text=AppGlobal.userLoad.name!;

  }

  final FocusNode _nameFocus = FocusNode();


  loadSharedPrefs() async {
    try {
      User user = User.fromJson(await sharedPref.read("user"));

      setState(() {
        AppGlobal.userLoad = user;
        _uploadedFileURL=user.imagePath!;
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
          title: Text('Edit Profile',style: appBarTitleStyle,),
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

                            SizedBox(height: 20.0),
                            new GestureDetector(
                                onTap: () {
                                  chooseFile(context);
                                },
                                child:SizedBox(
                                    height: 100,
                                    width: 100,
                                    child:Stack(
                                        children: <Widget>[
                                          Align(
                                              alignment: Alignment.center,
                                              child: (_uploadedFileURL.isEmpty || _uploadedFileURL==null)?
                                              Image(
                                                image: AssetImage("assets/images/ic_user_with_circle.png"),
                                                color: AppTheme.appPlaceHolder,
                                                height: 100,
                                                width: 100,
                                              ):
                                              new Container(
                                                  width: 85,
                                                  height: 85,
                                                  decoration: new BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: new DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: new NetworkImage(_uploadedFileURL),
                                                      )
                                                  )
                                              )

                                          ),
                                          Align(
                                              alignment: Alignment.bottomRight,
                                              child: Padding(
                                                  padding: EdgeInsets.fromLTRB(0,0,0,17),
                                                  child:Container(
                                                      width: 30,
                                                      height: 30,
                                                      decoration: new BoxDecoration(
                                                          image: DecorationImage(
                                                              image: AssetImage("assets/images/ic_pencil_back.png"),
                                                              fit: BoxFit.cover

                                                          )
                                                      ),
                                                      child: Center(
                                                          child:Image(
                                                            image: AssetImage("assets/images/ic_pencil.png"),
                                                            height: 15,
                                                            width: 15,
                                                          )
                                                      )
                                                  )
                                              )
                                          )
                                        ]
                                    )
                                )
                            ),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[

                                  SizedBox(height: 20.0),
                                  Text("Full Name", style: lblStyle,),
                                  TextFormField(
                                      obscureText: false,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(30),
                                        FilteringTextInputFormatter.allow(Regex.onlyCharacter)
                                      ],
                                      textCapitalization: TextCapitalization.words,
                                      controller: nameInputController,
                                      style: txtStyle,
                                      keyboardType: TextInputType.text,
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
                                        contentPadding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 15.0),
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
                                      focusNode: _nameFocus,
                                      onFieldSubmitted: (term){
                                        //_fieldFocusChange(context, _nameFocus, _emailFocus);
                                        _nameFocus.unfocus();
                                      }
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              width: double.infinity,
                              child: MaterialButton(
                                child: Text("Save",style: new TextStyle(fontSize: 18,fontFamily: "HelveticaNeueLight")),
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
                              ),
                            )

                          ]
                  )
                ),
                inAsyncCall: _saving
          ),
              );
        }),
    ));

  }

  Future chooseFile(BuildContext context) async {


    final _picker = ImagePicker();

    PickedFile ?image = await _picker.getImage(source: ImageSource.gallery);

    try {
      if (image != null) {
        setState(() {
          _image = File(image.path);
          _saving = true;
        });

        print('profiles/${Path.basename(_image!.path)}');

        Reference storageReference = FirebaseStorage.instance.ref().child(
            'profiles/${Path.basename(_image!.path)}');
        UploadTask uploadTask = storageReference.putFile(_image!);
        uploadTask.then((onValue) {
          setState(() {
            _saving = true;
          });

          storageReference.getDownloadURL().then((fileURL) {
            setState(() {
              _uploadedFileURL = fileURL;
            });

            FirebaseFirestore.instance
                .collection("users")
                .doc(AppGlobal.userLoad.id)
                .update(
                {
                  "profilePhoto": _uploadedFileURL,
                  "device_type": Platform.isAndroid ? "Android" : "iOS",
                })
                .then((result) {
              AppGlobal.userLoad.imagePath = _uploadedFileURL;
              sharedPref.save("user", AppGlobal.userLoad);

              setState(() {
                _saving = false;
              });
            }).catchError((err) => throwError(err, context));
          }).catchError((err) => throwError(err, context));
        }).catchError((err) {
          setState(() {
            _saving = false;
          });
        });
      }
    }catch(e){

    }finally{
      setState(() {
        _saving=false;
      });
    }
  }

  _changePassword(BuildContext context) async {

    FocusScope.of(context).requestFocus(FocusNode());
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    if (nameInputController!.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter name'),
      ));
    }
    else
    {


      setState(() {
        _saving = true;
      });

      FirebaseFirestore.instance
          .collection("users")
          .doc(AppGlobal.userLoad.id)
          .update(
          {
            "name": nameInputController!.text.toString().trim(),
            "device_type": Platform.isAndroid?"Android":"iOS",
          }).then((result) {

            AppGlobal.userLoad.name=nameInputController!.text.toString().trim();
            sharedPref.save("user", AppGlobal.userLoad);

            setState(() {
              _saving = false;
            });

            Navigator.pop(context);

          }).catchError((err) => throwError(err,context));


    }
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