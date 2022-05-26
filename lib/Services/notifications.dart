import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LocalNotifications{
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context){

    const InitializationSettings initializationSettings=InitializationSettings(android: AndroidInitializationSettings('@drawable/logo'));

    _flutterLocalNotificationsPlugin.initialize(initializationSettings,onSelectNotification: (String? route)async{
      Navigator.of(context).pushNamed(route!);
    });
  }

  static void display(RemoteMessage message)async {
    try {

      var random = Random(); //
      int value=(pow(2, 32)-1).toInt();// keep this somewhere in a static variable. Just make sure to initialize only once.
      int id = random.nextInt(value);


      NotificationDetails notificationDetails = const NotificationDetails(
        android: AndroidNotificationDetails(
            'Persona', 'Persona channel',
            importance: Importance.max, priority: Priority.high),
      );

      await _flutterLocalNotificationsPlugin.show(
          id, message.notification!.title, message.notification!.body,
          notificationDetails,payload: message.data['route']);
    }catch(e){Fluttertoast.showToast(msg: e.toString());}
  }

}