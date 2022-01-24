import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:salud_y_mas/src/requests/notificaciones_request.dart';

class PushNotificationProvider {
  static late AndroidNotificationChannel channel;
  static late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
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

  static _onMessaggeHandler(RemoteMessage message) async {
    print("ebtra ");
    // alert(message.notification?.body);
    //print(message.notification?.body);

    var p = await NotificacionesRequest().registrarNotificacion(message.notification?.title, message.notification?.body);
    print("notificacion re");
    print(p);
    _stramController.sink.add(message.notification?.body ?? 'No title');
    //alert();
  }

  static Future _onMessageOpenHandler(RemoteMessage message) async {
    print("entra en funcion ");
    print(message.notification?.body);
    var p = await NotificacionesRequest().registrarNotificacion(message.notification?.title, message.notification?.body);
    print("notificacion on");
    print(p);
    _stramController.sink.add(message.notification?.body ?? 'No title');
  }

  static Future initialAPP() async {
    firebaseApp = await Firebase.initializeApp();

    /*  firebaseApp = await Firebase.initializeApp(
        name: 'appSaludyMas',
        options: const FirebaseOptions(
          apiKey: 'AIzaSyAlElx8UgcaoTR5UK0kHR2nPZjj2zTWAkw',
          appId: '1:909682687135:ios:56a88b341d049129c976aa',
          messagingSenderId: '909682687135',
          projectId: 'saludymas-e48b8',
        ),
      );*/

    var p = await FirebaseMessaging.instance.getAPNSToken();

    print("token");
    print(p);
    //handlers
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    print("i web");
    print(kIsWeb);
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description: 'This channel is used for important notifications.', // description
        importance: Importance.high,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
    FirebaseMessaging.onMessage.listen(_onMessaggeHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenHandler);
  }

  static closeStrems() {
    _stramController.close();
  }
}
