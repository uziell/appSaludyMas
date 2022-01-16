import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PushNotificationProvider {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static String? token;
  static FirebaseApp? firebaseApp;
  static StreamController<String> _stramController = new StreamController.broadcast();
  static Stream<String> get messageStream => _stramController.stream;
  static BuildContext? context;
  static Future _backgroundHandler(RemoteMessage message) async {
   // print(message.notification?.title);
  //  alert(message);
    _stramController.sink.add(message.notification?.body ?? 'No title');
  }

  static  _onMessaggeHandler(RemoteMessage message) async {
    print("ebtra ");
   // alert(message.notification?.body);
    //print(message.notification?.body);
    _stramController.sink.add(message.notification?.title ?? 'No title');
    //alert();
  }

  static Future _onMessageOpenHandler(RemoteMessage message) async {
   print("entra en funcion ");
   print(message.notification?.body);
   alert(message);
    _stramController.sink.add(message.notification?.title ?? 'No title');
  }

  static Future initialAPP() async {
    firebaseApp = await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
    print(":::: token ;;;;");
    print(token);
    //handlers
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessaggeHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenHandler);
  }

  static closeStrems() {
    _stramController.close();
  }

  static alert(RemoteMessage message){
    print("entra aqui");
    return AlertDialog(
      title: Text(message.notification?.title ?? 'title'),
      content: Text(message.notification?.body ?? 'title'),
      actions: [
      ],
    );
  }
}
