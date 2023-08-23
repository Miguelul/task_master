import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// import 'package:native_admob_flutter/native_admob_flutter.dart';
import 'package:share/share.dart';
import 'package:taskapp/custom/KeyboardHideView.dart';
import 'package:taskapp/model/TaskModel.dart';
import 'package:taskapp/screen/AddTask.dart';
import 'package:taskapp/utils/AppGlobal.dart';
import 'package:taskapp/utils/AppTheme.dart';

import 'EditTask.dart';

List<TaskModel> lstTask = [];
List<TaskModel> lstMainTask = [];

class TodoTask extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TodoTaskState();
  }
}

class TodoTaskState extends State<TodoTask> {
  TextStyle style = TextStyle(
      fontFamily: 'AppLight', fontSize: 14.0, color: AppTheme.appWhite);
  TextStyle hintStyle = TextStyle(
      fontFamily: 'AppLight', fontSize: 14.0, color: AppTheme.txtSearch);

  TextStyle titleStyle = TextStyle(
      fontFamily: 'AppLight', fontSize: 18.0, color: AppTheme.appWhite);

  late TextEditingController searchInputController;

  TextStyle itemTitleStyle = TextStyle(
      fontFamily: 'AppBold', fontSize: 16.0, color: AppTheme.taskItemTitle);
  TextStyle itemDescStyle = TextStyle(
      fontFamily: 'AppLight', fontSize: 15.0, color: AppTheme.taskItemDesc);
  TextStyle itemTimeStyle = TextStyle(
      fontFamily: 'AppItalic', fontSize: 13.0, color: AppTheme.taskItemTime);

  bool showLoader = false;
  bool _saving = false;

  TextStyle noRecordFoundStyle = TextStyle(
      fontFamily: 'AppBold', fontSize: 18.0, color: AppTheme.appColor);

  late AdmobInterstitial interstitialAd;

  @override
  void initState() {
    super.initState();
    interstitialAd = AdmobInterstitial(
      adUnitId: AppGlobal.interstitialId,
      listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
        if (event == AdmobAdEvent.closed) {
          print("Interstitial Ad closed");
          interstitialAd.load(); // Cargar un nuevo anuncio cuando se cierra
        }
      },
    );
    interstitialAd.load();
    getTask();

    //  if (  interstitialAd.isLoaded) interstitialAd.show();
  }

  @override
  void dispose() {
    interstitialAd.dispose();
    super.dispose();
  }

  // @override
  // void initState() {
  //   super.initState();

  //   // loadAd();
  // }

  // loadAd() {

  //   if (interstitialAd.isLoaded) interstitialAd.load();
  //   interstitialAd.onEvent.listen((e) {
  //     final event = e.keys.first;
  //     switch (event) {
  //      case AdmobAdEvent.closed:
  //   print("Interstitial Ad closed");
  //   interstitialAd.load();
  //         break;
  //       default:
  //         break;
  //     }
  //   });
  // }

  getTask() async {
    lstTask.clear();
    lstMainTask.clear();

    setState(() {
      showLoader = true;
    });

    //QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance
        .collection("tasks")
        .where("uid", isEqualTo: AppGlobal.userLoad.id.toString())
        .where("status", isEqualTo: 0)
        .orderBy("tdate", descending: true)
        .orderBy("ttime", descending: true)
        .get()
        // ignore: missing_return
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((f) async {
        //print("================================"+f.data["title"]+"   ==========  "+'${f.data}');
        // setState(() {
        //   lstTask.add(TaskModel.fromJson(f.data()));
        //   lstMainTask.add(TaskModel.fromJson(f.data()));
        // });
        setState(() {
          lstTask.add(TaskModel.fromJson(f.data() as Map<String, dynamic>));
          lstMainTask.add(TaskModel.fromJson(f.data() as Map<String, dynamic>));
        });
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          showLoader = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ModalProgressHUD(
            child: KeyboardHideView(
              child: Container(
                decoration: BoxDecoration(color: AppTheme.appBackground),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        width: MediaQuery.of(context).copyWith().size.width,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppTheme.layer1,
                                AppTheme.layer2,
                                AppTheme.layer3
                              ]),
                        ),
                        child: Column(children: <Widget>[
                          SizedBox(height: 50.0),
                          Text(
                            "Welcome " + AppGlobal.userLoad.name!,
                            style: titleStyle,
                          ),
                          SizedBox(height: 15.0),
                          Container(
                              margin: new EdgeInsets.fromLTRB(
                                  10, 0, 10, 0), // Or set whatever you want
                              child: TextFormField(
                                  controller: searchInputController,
                                  enabled: lstMainTask.length > 0,
                                  obscureText: false,
                                  style: style,
                                  keyboardType: TextInputType.text,
                                  autocorrect: true,
                                  cursorColor: AppTheme.appWhite,
                                  enableSuggestions: true,
                                  maxLines: 1,
                                  textDirection: TextDirection.ltr,
                                  textInputAction: TextInputAction.search,
                                  textAlignVertical: TextAlignVertical.center,
                                  onChanged: (text) {
                                    onSearchTextChanged(text);
                                  },
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.transparent,
                                      prefixIcon: Icon(
                                        Icons.search,
                                        color: AppTheme.appWhite,
                                      ),
                                      hintText: "Search task",
                                      hintStyle: hintStyle,
                                      contentPadding: EdgeInsets.fromLTRB(
                                          5.0, 5.0, 5.0, 5.0),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          borderSide:
                                              BorderSide(color: Colors.white)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          borderSide:
                                              BorderSide(color: Colors.white)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          borderSide:
                                              BorderSide(color: Colors.white)),
                                      disabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          borderSide: BorderSide(
                                              color: Colors.white10))),
                                  onFieldSubmitted: (term) {})),
                          SizedBox(height: 15.0),
                        ]),
                      ),
                      Expanded(
                          child: showLoader
                              ? new Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    new CircularProgressIndicator(
                                        //valueColor: new AlwaysStoppedAnimation<Color>(AppTheme.appButton),
                                        ),
                                  ],
                                )
                              : lstTask.length == 0
                                  ? Center(
                                      child: Text(
                                        "No pending task found!",
                                        style: noRecordFoundStyle,
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: lstTask.length,
                                      padding: EdgeInsets.fromLTRB(
                                          5.0, 8.0, 5.0, 8.0),
                                      itemBuilder: (context, index) {
                                        return Column(children: <Widget>[
                                          Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                              elevation: 2,
                                              margin: EdgeInsets.all(8.0),
                                              child: Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      15, 15, 15, 0),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <Widget>[
                                                                Text(
                                                                  lstTask[index]
                                                                      .title!,
                                                                  style:
                                                                      itemTitleStyle,
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Text(
                                                            lstTask[index]
                                                                    .tdate! +
                                                                " " +
                                                                lstTask[index]
                                                                    .ttime!,
                                                            style:
                                                                itemTimeStyle,
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(height: 10),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Flexible(
                                                              child: Text(
                                                            lstTask[index]
                                                                .description!,
                                                            style:
                                                                itemDescStyle,
                                                          )),
                                                        ],
                                                      ),
                                                      SizedBox(height: 30),
                                                      Divider(
                                                        color: AppTheme
                                                            .taskItemLine,
                                                        thickness: 1,
                                                        height: 1,
                                                      ),
                                                      Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  0, 7, 0, 7),
                                                          child: Row(
                                                            children: <Widget>[
                                                              new GestureDetector(
                                                                onTap: () {
                                                                  _editTask(
                                                                      index);
                                                                },
                                                                child: Image(
                                                                  image: AssetImage(
                                                                      "assets/images/ic_edit.png"),
                                                                  height: 40,
                                                                  width: 40,
                                                                ),
                                                              ),
                                                              new GestureDetector(
                                                                onTap: () {
                                                                  deleteData(
                                                                      context,
                                                                      index);
                                                                },
                                                                child: Image(
                                                                  image: AssetImage(
                                                                      "assets/images/ic_delete.png"),
                                                                  height: 40,
                                                                  width: 40,
                                                                ),
                                                              ),
                                                              new GestureDetector(
                                                                onTap: () {
                                                                  _shareApp(
                                                                      index);
                                                                },
                                                                child: Image(
                                                                  image: AssetImage(
                                                                      "assets/images/ic_share.png"),
                                                                  height: 40,
                                                                  width: 40,
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: <Widget>[
                                                                    MaterialButton(
                                                                      child: Text(
                                                                          "Complete",
                                                                          style: new TextStyle(
                                                                              fontSize: 14,
                                                                              fontFamily: "AppBold")),
                                                                      onPressed:
                                                                          () {
                                                                        _completeTask(
                                                                            index);
                                                                      },
                                                                      color: AppTheme
                                                                          .appButtonGreen,
                                                                      textColor:
                                                                          AppTheme
                                                                              .appWhite,
                                                                      padding: EdgeInsets
                                                                          .fromLTRB(
                                                                              20,
                                                                              0,
                                                                              20,
                                                                              0),
                                                                      splashColor:
                                                                          AppTheme
                                                                              .appButtonGreen,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            new BorderRadius.circular(25.0),
                                                                        side: BorderSide(
                                                                            color:
                                                                                AppTheme.appButtonGreen),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          )),
                                                    ],
                                                  ))),
                                          SizedBox(
                                              height:
                                                  index == lstTask.length - 1
                                                      ? 70
                                                      : 0),
                                        ]);
                                      })),

                      /*Divider(
                    color: AppTheme.tabUnselected,
                    thickness: 1,
                    height: 1,
                  ),*/
                    ],
                  ),
                ),
              ),
            ),
            inAsyncCall: _saving),
        floatingActionButton: FloatingActionButton(
          onPressed: _addTask,
          //backgroundColor: AppTheme.appButton,
          tooltip: 'Add Task',
          child: Icon(
            Icons.add,
          ), //color: AppTheme.appWhite,
        ));
  }

  onSearchTextChanged(String text) async {
    lstTask.clear();
    if (text.isEmpty) {
      setState(() {
        lstTask.addAll(lstMainTask);
      });
      return;
    }

    setState(() {
      lstMainTask.forEach((taskDetail) {
        if (taskDetail.title!.toLowerCase().contains(text.toLowerCase()) ||
            taskDetail.description!.toLowerCase().contains(text.toLowerCase()))
          lstTask.add(taskDetail);
      });
    });
  }

  _shareApp(int index) async {
    String shareText = "\n\nTitle : " + lstTask[index].title!;
    shareText += "\nDescription : " + lstTask[index].description!;
    shareText +=
        "\nDate : " + lstTask[index].tdate! + " " + lstTask[index].ttime!;

    String txt = AppGlobal.userLoad.name! + " has shared a task with you.....";

    Share.share(txt + shareText);
  }

  deleteData(BuildContext context, int index) {
    TextStyle noStyle = TextStyle(
        fontFamily: 'HelveticaNeueLight',
        fontSize: 14.0,
        color: AppTheme.appButtonGreen);
    TextStyle yesStyle = TextStyle(
        fontFamily: 'HelveticaNeueLight',
        fontSize: 14.0,
        color: AppTheme.appButtonRed);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Remove Task"),
          content: new Text("Are you sure? Do you want to remove this task?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new MaterialButton(
              child: new Text(
                "No",
                style: noStyle,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new MaterialButton(
              child: new Text(
                "Yes",
                style: yesStyle,
              ),
              onPressed: () {
                Navigator.of(context).pop();

                FirebaseFirestore.instance
                    .collection("tasks")
                    .doc(lstTask[index].key)
                    .delete()
                    .then((onValue) {
                  setState(() {
                    AppGlobal.flutterLocalNotificationsPlugin
                        .cancel(lstTask[index].reminderId!);
                    lstTask.removeAt(index);
                  });
                }).catchError((e) {});
              },
            ),
          ],
        );
      },
    );
  }

  _completeTask(int index) async {
    setState(() {
      _saving = true;
    });

    FirebaseFirestore.instance
        .collection("tasks")
        .doc(lstTask[index].key)
        .update({"status": 1}).then((result) {
      setState(() {
        lstTask.removeAt(index);
        _saving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Task Completed"),
      ));
    }).catchError((err) => throwError(err, context));
  }

  void throwError(PlatformException error, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error.message!),
    ));
  }

  _addTask() {
    Navigator.of(context)
        .push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => AddTask(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    ))
        .then((onValue) async {
      if (onValue) {
        bool? estado = false;

        estado = await interstitialAd.isLoaded;
        getTask();
        if (estado!) interstitialAd.show();
      }
    });
  }

  _editTask(int index) {
    Navigator.of(context)
        .push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          EditTask(taskModel: lstTask[index]),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    ))
        .then((onValue) async {
      //getTask();
      //print("=================>=========="+onValue.toString());
      if (onValue) {
        bool? estado = false;

        estado = await interstitialAd.isLoaded;
        getTask();
        if (estado!) interstitialAd.show();
      }
    });
  }
}
