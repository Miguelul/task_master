import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:taskapp/model/User.dart';
import 'package:intl/intl.dart';

class AppGlobal
{
  static User userLoad =User();
  static final dateFormat = DateFormat("yyyy-MM-dd");
  static final timeFormat = DateFormat("HH:mm");
  static final dateTimeFormat = DateFormat("yyyy-MM-dd HH:mm");

  static String bannerId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/6300978111';

  static String interstitialId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-3940256099942544/1033173712';

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


}