import 'package:flutter/material.dart';
import 'package:salud_y_mas/notification_providers/push_notification_providers.dart';
import 'package:salud_y_mas/preferences/preferences.dart';
import 'package:salud_y_mas/src/pages/pantalla_inicio.dart';

class Landing extends StatefulWidget {
  const Landing({Key? key}) : super(key: key);

  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  AppPreferences prefs = AppPreferences();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!
        .addPostFrameCallback((_) => {this.autentication()});
  }

  Future<void> autentication() async {
    // if (prefs.logIn) {
      //await PushNotificationProvider.initialAPP();
      Navigator.pushNamedAndRemoveUntil(context, "inicio", (Route<dynamic> route) => false);
    // } else {
    //   Navigator.pushNamedAndRemoveUntil(context, "login", (Route<dynamic> route) => false);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
