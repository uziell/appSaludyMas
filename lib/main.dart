import 'package:flutter/material.dart';
import 'package:salud_y_mas/preferences/preferences.dart';
import 'package:salud_y_mas/src/routes/routes.dart';

import 'notification_providers/push_notification_providers.dart';

AppPreferences prefs = AppPreferences();

void main() async {
  await prefs.initPrefs();
  //Necesito inicializarlo aquí ya que si no, no agarrará lo del topic
  await PushNotificationProvider.initialAPP();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: getApplicationRoutes(),
    );
  }
}
