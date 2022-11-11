import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../helper/db_helper.dart';
import '../helper/notiftion_helper.dart';
import '../models/modls.dart';
import 'package:timezone/timezone.dart' as tz;

class ReminderProvider extends ChangeNotifier{
  Future<List<Reminders>>? dbData;
  int random = 0;
  Random randoms  =Random();
  void fetchData(){
    dbData = DBHelper.dbHelper.fetchhhhData();
    notifyListeners();
  }
  void rendom(){
    random = randoms.nextInt(100);
    notifyListeners();
  }

  Future<void> scheduleNotifications({required id,required title,required body, required time}) async {

    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(time, tz.local),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
         notifyListeners();

  }



}