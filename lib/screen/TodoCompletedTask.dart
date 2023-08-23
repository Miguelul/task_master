import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:taskapp/custom/KeyboardHideView.dart';
import 'package:taskapp/model/TaskModel.dart';
import 'package:taskapp/utils/AppGlobal.dart';
import 'package:taskapp/utils/AppTheme.dart';

List<TaskModel> lstTask=[];
List<TaskModel> lstMainTask=[];

class TodoCompleteTask extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return TodoCompleteTaskState();
  }
}

class TodoCompleteTaskState extends State<TodoCompleteTask>
{
  TextStyle style = TextStyle(fontFamily: 'AppLight', fontSize: 14.0, color: AppTheme.appWhite);
  TextStyle hintStyle = TextStyle(fontFamily: 'AppLight', fontSize: 14.0, color: AppTheme.txtSearch);

  TextStyle titleStyle = TextStyle(fontFamily: 'AppLight', fontSize: 18.0, color: AppTheme.appWhite);

  late TextEditingController searchInputController;

  TextStyle itemTitleStyle = TextStyle(fontFamily: 'AppBold', fontSize: 16.0, color: AppTheme.taskItemTitle);
  TextStyle itemDescStyle = TextStyle(fontFamily: 'AppLight', fontSize: 15.0, color: AppTheme.taskItemDesc);
  TextStyle itemTimeStyle = TextStyle(fontFamily: 'AppItalic', fontSize: 13.0, color: AppTheme.taskItemTime);


  TextStyle itemEditStyle = TextStyle(fontFamily: 'AppLight', fontSize: 17.0, color: AppTheme.appButtonGreen);
  TextStyle itemDeleteStyle = TextStyle(fontFamily: 'AppLight', fontSize: 14.0, color: AppTheme.appButtonRed);
  TextStyle itemShareStyle = TextStyle(fontFamily: 'AppLight', fontSize: 15.0, color: AppTheme.appButton);

  bool showLoader=false;

  TextStyle noRecordFoundStyle = TextStyle(fontFamily: 'AppBold', fontSize: 18.0, color: AppTheme.appColor);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getTask();

  }

  getTask() async
  {
    lstTask.clear();
    lstMainTask.clear();

    setState(() {
      showLoader=true;
    });

    //QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection("tasks")
        .where("uid",isEqualTo:AppGlobal.userLoad.id.toString()).where("status", isEqualTo: 1)
        .orderBy("tdate", descending: true).orderBy("ttime", descending: true)
        .get()
        // ignore: missing_return
        .then((QuerySnapshot snapshot)
    {

      snapshot.docs.forEach((f) async {
        //print("================================"+f.data["title"]+"   ==========  "+'${f.data}');
        setState(() {
          lstTask.add(TaskModel.fromJson(f.data()as Map<String, dynamic>));
          lstMainTask.add(TaskModel.fromJson(f.data()as Map<String, dynamic>));
        });

      });

      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          showLoader=false;
        });
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:KeyboardHideView(
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.appBackground
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
                          Text("Completed Tasks",style: titleStyle,),
                          SizedBox(height: 15.0),
                          Container(
                              margin: new EdgeInsets.fromLTRB(10,0,10,0), // Or set whatever you want
                              child: TextFormField(
                                  controller: searchInputController,
                                  enabled: lstMainTask.length>0,
                                  obscureText: false,
                                  style: style,
                                  keyboardType: TextInputType.text,
                                  autocorrect: true,
                                  cursorColor: AppTheme.lightTheme.primaryColor,
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
                                    prefixIcon: Icon(Icons.search,color: AppTheme.appWhite,),
                                    hintText: "Search Task",
                                    hintStyle: hintStyle,
                                    contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                                    border:OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                        borderSide: BorderSide(color: Colors.white)
                                    ),
                                    focusedBorder:OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                        borderSide: BorderSide(color: Colors.white)
                                    ),
                                    enabledBorder:OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                        borderSide: BorderSide(color: Colors.white)
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                        borderSide: BorderSide(color: Colors.white10)
                                    )
                                    //focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                                  ),
                                  onFieldSubmitted: (term) {
                                  }
                              )
                          ),
                          SizedBox(height: 15.0),
                        ]
                    ),
                  ),



                  Expanded(
                    child: showLoader?
                    new Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        new CircularProgressIndicator(
                          //valueColor: new AlwaysStoppedAnimation<Color>(AppTheme.appButton),
                        ),
                      ],
                    ):lstTask.length==0?
                    Center(
                      child:Text("No completed task found!", style: noRecordFoundStyle,),
                    ):
                    ListView.builder(
                        itemCount: lstTask.length,
                        padding: EdgeInsets.fromLTRB(5.0, 8.0, 5.0, 8.0),
                        itemBuilder: (context, index) {
                          return Column(
                              children: <Widget>[
                                Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    elevation: 2,
                                    margin: EdgeInsets.all(8.0),
                                    child: Padding(
                                        padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                                        child:Column(
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text(lstTask[index].title!, style: itemTitleStyle,)
                                                    ],
                                                  ),
                                                ),
                                                Text(lstTask[index].tdate!+" "+lstTask[index].ttime!, style: itemTimeStyle,)
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Flexible(
                                                    child: Text(lstTask[index].description!, style: itemDescStyle,)
                                                ),

                                              ],
                                            ),
                                            SizedBox(height: 30),
                                            Divider(
                                              color: AppTheme.taskItemLine,
                                              thickness: 1,
                                              height: 1,
                                            ),
                                            Padding(
                                                padding: EdgeInsets.fromLTRB(0, 7, 0, 7),
                                                child:Row(
                                                  children: <Widget>[
                                                    new GestureDetector(
                                                      onTap: () {
                                                        deleteData(context, index);
                                                      },
                                                      child:Image(
                                                        image: AssetImage("assets/images/ic_delete.png"),
                                                        height: 40,
                                                        width: 40,
                                                      ),
                                                    ),
                                                    new GestureDetector(
                                                      onTap: () {
                                                        _shareApp(index);
                                                      },
                                                      child:Image(
                                                        image: AssetImage("assets/images/ic_share.png"),
                                                        height: 40,
                                                        width: 40,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                            ),
                                          ],
                                        )
                                    )
                                ),
                                SizedBox(height: index==lstTask.length-1?70:0),
                              ]
                          );
                        }
                    )
                  ),

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
    );
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

  _shareApp(int index) async
  {
    String shareText="\n\nTitle : "+lstTask[index].title!;
    shareText+="\nDescription : "+lstTask[index].description!;
    shareText+="\nDate : "+lstTask[index].tdate!+" "+lstTask[index].ttime!;

    String txt=AppGlobal.userLoad.name!+" has shared a task with you.....";

    Share.share(txt+shareText);
  }


  deleteData(BuildContext context,int index)
  {
    TextStyle noStyle = TextStyle(fontFamily: 'HelveticaNeueLight', fontSize: 14.0, color: AppTheme.appButtonGreen);
    TextStyle yesStyle = TextStyle(fontFamily: 'HelveticaNeueLight', fontSize: 14.0, color: AppTheme.appButtonRed);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Remove Task"),
          content: new Text("Are you sure? Do you want to remove this task?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new MaterialButton(
              child: new Text("No", style: noStyle,),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new MaterialButton(
              child: new Text("Yes", style: yesStyle,),
              onPressed: () {
                Navigator.of(context).pop();

                FirebaseFirestore.instance
                    .collection("tasks")
                    .doc(lstTask[index].key)
                    .delete()
                    .then((onValue){
                      setState(() {
                        AppGlobal.flutterLocalNotificationsPlugin.cancel(lstTask[index].reminderId!);
                        lstTask.removeAt(index);
                      });
                    }).catchError((e) {

                    });
              },
            ),
          ],
        );
      },
    );
  }
}