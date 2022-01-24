import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salud_y_mas/notification_providers/push_notification_providers.dart';
import 'package:salud_y_mas/preferences/preferences.dart';
import 'package:salud_y_mas/src/requests/notificaciones_request.dart';
import 'package:http/http.dart' as http;
import 'alerts.dart';

class AppBarNotificaciones extends StatefulWidget {
  final String titulo;
  const AppBarNotificaciones({Key? key, required this.titulo})
      : super(key: key);

  @override
  _AppBarNotificacionesState createState() => _AppBarNotificacionesState();
}

class _AppBarNotificacionesState extends State<AppBarNotificaciones> {
  AppPreferences _prefs = AppPreferences();
  int numeroNotificaciones = 0;
  @override
  void initState() {
    super.initState();
    PushNotificationProvider.messageStream.listen((message) {
      print("entra listener app bar ");

      obtenerNumeroNotificacionesNoVistas();
    });
    obtenerNumeroNotificacionesNoVistas();
  }

  obtenerNumeroNotificacionesNoVistas() async {
    numeroNotificaciones = 0;
    List<dynamic> notificaciones =
        await NotificacionesRequest().obtenerNotificaciones();
    if (this.mounted) {
      setState(() {
        for (int i = 0; i < notificaciones.length; i++) {
          if (notificaciones[i]['estadoNot'] == "0") {
            numeroNotificaciones += 1;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        widget.titulo,
        style: GoogleFonts.abrilFatface(fontSize: 14),
      ),
      actions: [
        Badge(
          position: BadgePosition.topEnd(top: 5, end: 3),
          badgeColor: Colors.red,
          showBadge: numeroNotificaciones > 0 ? true : false,
          badgeContent: Text('$numeroNotificaciones',
              style: TextStyle(color: Colors.white, fontSize: 9)),
          child: IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              if (_prefs.estado == "Seleccione el estado") {
                return dialogCambiarEstado(context);
              }
              Navigator.pushNamed(context, 'notificaciones').then((value) {
                obtenerNumeroNotificacionesNoVistas();
              });
            },
          ),
        ),
      ],
    );
  }

  Future<List<dynamic>> consultarAPIEstados() async {
    String urlApi = 'https://www.salumas.com/Salud_Y_Mas_Api/';
    final url = Uri.parse(urlApi + 'consultas_edo.php');
    var response = await http.get(url);
    List<dynamic> nombreEdo;
    nombreEdo = json.decode(response.body);
    return nombreEdo;
  }

  dialogCambiarEstado(BuildContext context) async {
    List<dynamic> nombreEdo = await consultarAPIEstados();
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Seleccione el estado en el que se encuentra",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                      fontSize: 12, fontWeight: FontWeight.bold)),
              content: dropdownEstados(nombreEdo),
              actions: [
                TextButton(
                  child: Text('Cerrar'),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            ));
  }

  dropdownEstados(List<dynamic> nombreEdo) {
    return Container(
      color: Colors.white,
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: DropdownButtonFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
        items: nombreEdo.map((ciudadC) {
          return DropdownMenuItem(
            value: ciudadC['nombre'],
            child: Text(ciudadC['nombre']),
          );
        }).toList(),
        iconSize: 20,
        icon: Icon(Icons.arrow_drop_down, color: Colors.white),
        onChanged: (estadoActual) async {
          String tempEstado = _prefs.estado;
          _prefs.estado = estadoActual.toString();

          FirebaseMessaging.instance.requestPermission(
              sound: true, badge: true, alert: true, provisional: false);

          if (tempEstado != "Seleccione el estado") {
            await PushNotificationProvider.firebaseMessaging
                .unsubscribeFromTopic(tempEstado);
          }

          //Utilizo esto para que pueda ingresarse en un topic (tag) es decir si es YUCATAN a todos los de YUCATAN les llegará la notificación
          await PushNotificationProvider.firebaseMessaging
              .subscribeToTopic(_prefs.estado);
        },
        hint: Text(
          _prefs.estado,
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
    );
  }
}
