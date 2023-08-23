import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:taskapp/custom/KeyboardHideView.dart';
import 'package:taskapp/model/TaskModel.dart';
import 'package:taskapp/model/User.dart';
import 'package:taskapp/utils/AppGlobal.dart';

import 'package:taskapp/utils/AppTheme.dart';
import 'package:taskapp/utils/Constants.dart';
import 'package:taskapp/utils/SharedPref.dart';

// import 'package:modal_progress_hud/modal_progress_hud.dart';


TextStyle textStyle = TextStyle(fontFamily: 'AppLight', fontSize: 16.0, color: AppTheme.appBlack);
TextStyle lblStyle = TextStyle(fontFamily: 'AppLight', fontSize: 16.0, color: AppTheme.lblColor);
TextStyle hintStyle = TextStyle(fontFamily: 'AppLight', fontSize: 16.0, color: AppTheme.lblColor);


class EditTask extends StatefulWidget
{
  static const String routeName = "/editTask";
  @override
  EditTaskState createState() => EditTaskState();

  final TaskModel taskModel;

  // In the constructor, require a Todo.
  EditTask({Key? key, required this.taskModel}) : super(key: key);
}


class EditTaskState extends State<EditTask> with TickerProviderStateMixin  {

  TextStyle appBarTitleStyle = TextStyle(fontFamily: 'AppLight', fontSize: 18.0, color: AppTheme.appWhite);

  bool _saving = false;

 late TextEditingController titleInputController,descriptionInputController,dateInputController,timeInputController;

  User userSave = User();
  SharedPref sharedPref= SharedPref();

  var dateFormatterBasedOnDevice;
  var dateFormatterBasedOnDeviceNEW;

  @override
  void initState() {
    super.initState();

    loadSharedPrefs();

    Devicelocale.currentLocale.then((onValue){
      //print("============>>>==="+onValue+"========="+DateFormat.yMd(onValue).pattern);
      dateFormatterBasedOnDevice=DateFormat.yMd(onValue);
      dateFormatterBasedOnDeviceNEW=DateFormat.yMd(onValue).add_Hm();
    });

    titleInputController = new TextEditingController();
    descriptionInputController = new TextEditingController();
    dateInputController = new TextEditingController();
    timeInputController = new TextEditingController();

    if(widget.taskModel!=null) {
      titleInputController.text = widget.taskModel.title!;
      descriptionInputController.text = widget.taskModel.description!;
      dateInputController.text = widget.taskModel.tdate!;
      timeInputController.text = widget.taskModel.ttime!;
    }
  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  final FocusNode _titleFocus = FocusNode();
  final FocusNode _descFocus = FocusNode();


  loadSharedPrefs() async {
    try {
      User user = User.fromJson(await sharedPref.read("user"));

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
          title: Text('Edit Your Task',style: appBarTitleStyle,),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[

                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 20.0),
                                  Text("Type Something", style: lblStyle,),
                                  TextFormField(
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(50),
                                      ],
                                      textCapitalization: TextCapitalization
                                          .words,
                                      obscureText: false,
                                      controller: titleInputController,
                                      style: TextStyle(fontFamily: 'AppBold',
                                          fontSize: 18.0,
                                          color: AppTheme.appBlack),
                                      keyboardType: TextInputType.text,
                                      autocorrect: true,
                                      cursorColor: AppTheme.lightTheme
                                          .primaryColor,
                                      enableSuggestions: true,
                                      maxLines: 1,
                                      textInputAction: TextInputAction.next,
                                      textAlignVertical: TextAlignVertical
                                          .center,
                                      onChanged: (text) {

                                      },
                                      decoration: InputDecoration(
                                        //contentPadding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
                                          border: new UnderlineInputBorder(
                                              borderSide: new BorderSide(
                                                color: AppTheme.greyBorder,)
                                          ),
                                          focusedBorder: new UnderlineInputBorder(
                                              borderSide: new BorderSide(
                                                color: AppTheme.greyBorder,)
                                          ),
                                          enabledBorder: new UnderlineInputBorder(
                                              borderSide: new BorderSide(
                                                color: AppTheme.greyBorder,)
                                          )

                                      ),
                                      focusNode: _titleFocus,
                                      onFieldSubmitted: (term) {
                                        _fieldFocusChange(
                                            context, _titleFocus, _descFocus);
                                      }
                                  ),

                                  SizedBox(height: 20.0),
                                  Text("When", style: lblStyle,),
                                  SizedBox(height: 10.0),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                                    child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 5,
                                            child: DottedBorder(
                                                color: AppTheme.dashBorder,
                                                strokeWidth: 1,
                                                borderType: BorderType.RRect,
                                                radius: Radius.circular(8),
                                                child: DateTimeField(
                                                  controller: dateInputController,
                                                  style: textStyle,
                                                  decoration: InputDecoration(
                                                    hintText: "Date",
                                                    hintStyle: hintStyle,
                                                    prefixIcon: IconButton(
                                                      icon: new Image.asset(
                                                          'assets/images/ic_date.png'),
                                                      iconSize: 10,
                                                      onPressed: () {},
                                                    ),
                                                    contentPadding: EdgeInsets
                                                        .fromLTRB(
                                                        0.0, 15.0, 0.0, 15.0),
                                                    border: OutlineInputBorder(
                                                        borderRadius: BorderRadius
                                                            .circular(8.0),
                                                        borderSide: new BorderSide(
                                                            color: Colors
                                                                .transparent)),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius
                                                            .circular(8.0),
                                                        borderSide: new BorderSide(
                                                            color: Colors
                                                                .transparent)),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius
                                                            .circular(8.0),
                                                        borderSide: new BorderSide(
                                                            color: Colors
                                                                .transparent)),
                                                  ),
                                                  format: dateFormatterBasedOnDevice,
                                                  onShowPicker: (context,
                                                      currentValue) {
                                                    return showDatePicker(
                                                        context: context,
                                                        firstDate: DateTime
                                                            .now().add(
                                                            Duration(days: -1)),
                                                        initialDate: currentValue ??
                                                            DateTime.now(),
                                                        lastDate: DateTime(
                                                            2100));
                                                  },
                                                )
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            flex: 4,
                                            child: DottedBorder(
                                              color: AppTheme.dashBorder,
                                              strokeWidth: 1,
                                              borderType: BorderType.RRect,
                                              radius: Radius.circular(8),
                                              child: DateTimeField(
                                                controller: timeInputController,
                                                style: textStyle,
                                                decoration: InputDecoration(
                                                  hintText: "Time",
                                                  hintStyle: hintStyle,
                                                  prefixIcon: IconButton(
                                                    icon: new Image.asset(
                                                        'assets/images/ic_time.png'),
                                                    iconSize: 10,
                                                    onPressed: () {},
                                                  ),
                                                  contentPadding: EdgeInsets
                                                      .fromLTRB(
                                                      0.0, 15.0, 0.0, 15.0),
                                                  border: OutlineInputBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(8.0),
                                                      borderSide: new BorderSide(
                                                          color: Colors
                                                              .transparent)),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(8.0),
                                                      borderSide: new BorderSide(
                                                          color: Colors
                                                              .transparent)),
                                                  enabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(8.0),
                                                      borderSide: new BorderSide(
                                                          color: Colors
                                                              .transparent)),
                                                ),
                                                format: AppGlobal.timeFormat,
                                                onShowPicker: (context,
                                                    currentValue) async {
                                                  final time = await showTimePicker(
                                                    context: context,
                                                    initialTime: TimeOfDay
                                                        .fromDateTime(
                                                        currentValue ??
                                                            DateTime.now()),
                                                  );
                                                  return DateTimeField.convert(
                                                      time);
                                                },
                                              ),
                                            ),
                                          )
                                        ]
                                    ),
                                  ),

                                  SizedBox(height: 20.0),
                                  Text("Description", style: lblStyle,),
                                  SizedBox(height: 10.0),
                                  TextFormField(
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(500),
                                      ],
                                      textCapitalization: TextCapitalization
                                          .sentences,
                                      controller: descriptionInputController,
                                      obscureText: false,
                                      style: TextStyle(fontFamily: 'AppRegular',
                                          fontSize: 15.0,
                                          color: AppTheme.appBlack),
                                      keyboardType: TextInputType.multiline,
                                      autocorrect: true,
                                      cursorColor: AppTheme.lightTheme
                                          .primaryColor,
                                      enableSuggestions: true,
                                      maxLines: 4,
                                      textInputAction: TextInputAction.newline,
                                      textAlignVertical: TextAlignVertical
                                          .center,
                                      onChanged: (text) {

                                      },
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.fromLTRB(
                                            15.0, 15.0, 15.0, 15.0),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                8.0),
                                            borderSide: new BorderSide(
                                                color: AppTheme.greyBorder)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                8.0),
                                            borderSide: new BorderSide(
                                                color: AppTheme.greyBorder)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                8.0),
                                            borderSide: new BorderSide(
                                                color: AppTheme.greyBorder)),
                                      ),
                                      focusNode: _descFocus,
                                      onFieldSubmitted: (term) {
                                        //_fieldFocusChange(context, _emailFocus, _passwordFocus);
                                        _descFocus.unfocus();
                                      }
                                  ),

                                ],
                              ),
                            ),

                            SizedBox(
                              width: double.infinity,
                              child: MaterialButton(
                                child: Text("UPDATE TASK", style: new TextStyle(
                                    fontSize: 16,
                                    fontFamily: "AppBold")),
                                onPressed: () {
                                  _saveTask(context);
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
                            ),

                          ]
                      )
                ), inAsyncCall: _saving
              ),
            );
          }
        ),
    ));

  }

  _saveTask(BuildContext context) {

    FocusScope.of(context).requestFocus(FocusNode());
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    if(titleInputController.text.trim().isEmpty)
    {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter title'),
      ));
    }
    /*else if(descriptionInputController.text.trim().isEmpty)
    {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Please enter description'),
      ));
    }*/
    else if(dateInputController.text.trim().isEmpty)
    {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter date'),
      ));
    }
    else if(timeInputController.text.trim().isEmpty)
    {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter time'),
      ));
    }
    else
    {
        setState(() {
          _saving = true;
        });

        final randomValue=widget.taskModel.key;

        var scheduledNotificationDateTime =DateTime.parse(dateFormatterBasedOnDeviceNEW.parse(dateInputController.text.trim()+" "+timeInputController.text.trim()).toString());

        int _id=(scheduledNotificationDateTime.millisecondsSinceEpoch/1000).round();

        FirebaseFirestore.instance
            .collection("tasks")
            .doc(randomValue)
            .update(
            {
              "uid": AppGlobal.userLoad.id,
              "title": titleInputController.text.toString().trim(),
              "description": descriptionInputController.text.toString().trim(),
              "tdate": dateInputController.text.toString().trim(),
              "ttime": timeInputController.text.toString().trim(),
              "device_type": Platform.isAndroid?"Android":"iOS",
              "key": randomValue,
              "millisecond":scheduledNotificationDateTime.millisecondsSinceEpoch,
              "reminderId":_id,
              "status":widget.taskModel.status
            }).then((result) {
                setState(() {
                  _saving = false;
                });

                navigationPage();

                DateTime selectedDate=DateTime.parse(dateFormatterBasedOnDeviceNEW.parse(
                    dateInputController.text.trim()+" "+timeInputController.text.trim()).toString());
                DateTime currentDate=DateTime.now();

                if(selectedDate.millisecondsSinceEpoch >= currentDate.millisecondsSinceEpoch)
                {
                  AppGlobal.flutterLocalNotificationsPlugin.cancel(widget.taskModel.reminderId!);
                  setNotification(scheduledNotificationDateTime);
                }

            })
            .catchError((err) => throwError(err,context));
    }
  }

  setNotification(DateTime scheduledNotificationDateTime) async {
    var android = AndroidNotificationDetails(taskChannelId, taskChannelName,);
    var iOS = IOSNotificationDetails();
    var platform = NotificationDetails(android: android, iOS: iOS);
    //var scheduledNotificationDateTime =DateTime.parse(dateInputController.text.trim()+" "+timeInputController.text.trim());
    //var scheduledNotificationDateTime =DateTime.parse("2020-04-14 12:10");
    int _id=(scheduledNotificationDateTime.millisecondsSinceEpoch/1000).round();
    //print("---------------------"+_id.toString());
    await AppGlobal.flutterLocalNotificationsPlugin.schedule(_id,
        titleInputController.text.trim(), descriptionInputController.text.trim(), scheduledNotificationDateTime, platform);
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