import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salud_y_mas/preferences/preferences.dart';
import 'package:salud_y_mas/src/pages/login_page.dart';
import 'package:http/http.dart' as http;

class Alerts {
  AppPreferences _prefs = AppPreferences();
  Widget dialogCerrarSesion(BuildContext context) => CupertinoAlertDialog(
        title: Text('¿Desea cerrar sesión?'),
        actions: [
          CupertinoDialogAction(
            child: Text("Ok"),
            onPressed: () {
              FirebaseMessaging.instance.unsubscribeFromTopic(_prefs.estado);
              _prefs.clear();
              Navigator.pushNamedAndRemoveUntil(
                  context, 'login', (route) => false);
            },
          ),
          CupertinoDialogAction(
            child: Text("Cancelar"),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
        ],
      );

  dialogNotificaciones(BuildContext context, text) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text(text),
              actions: [
                CupertinoDialogAction(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            ));
  }

  dialogDinamico(BuildContext context, text) {
    showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text(text),
              actions: [
                CupertinoDialogAction(
                  child: Text("Si"),
                  onPressed: () {
                    //Aqui pones lo que pondrás al picarl el botón
                  },
                ),
                CupertinoDialogAction(
                  child: Text("No"),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            ));
  }

  dialogoAvisoPerfil(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text(
                  "Al actualizar tus datos tienes que ingresar nuevamente.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold)),
              actions: [
                CupertinoDialogAction(
                  child: Text("Entendido"),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            ));
  }



 
}
