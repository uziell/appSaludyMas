import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salud_y_mas/notification_providers/push_notification_providers.dart';
import 'package:salud_y_mas/preferences/preferences.dart';
import 'package:salud_y_mas/src/widgtes/appBarNotificaciones.dart';
import 'package:salud_y_mas/src/widgtes/menu.dart';
import 'package:http/http.dart' as http;

class ConfiguracionPage extends StatefulWidget {
  const ConfiguracionPage({Key? key}) : super(key: key);

  @override
  _ConfiguracionPageState createState() => _ConfiguracionPageState();
}

class _ConfiguracionPageState extends State<ConfiguracionPage> {
  AppPreferences _prefs = AppPreferences();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MenuPage(),
        appBar: PreferredSize(preferredSize: Size.fromHeight(50.0), child: AppBarNotificaciones(titulo: 'Configuración')),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(margin: EdgeInsets.only(left: 16, top: 24, bottom: 12), child: Text('Secciones', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 15))),
            ListTile(
              leading: Icon(Icons.location_city, color: Colors.brown),
              title: Text('Estado', style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text('Presione el botón para cambiar de estado en el que le llegarán las notificaciones'),
              onTap: () {
                dialogCambiarEstado(context);
              },
            ),
            Divider(
              thickness: 1.5,
              height: 18,
            ),
            ListTile(
                leading: Icon(Icons.notifications),
                title: Text('Notificaciones', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Si desactiva las notificaciones, no le llegarán hasta que vuelva activarlo'),
                trailing: Switch(
                  onChanged: (v) async {
                    setState(() async {
                      _prefs.isNotificacion = v;

                      if (_prefs.isNotificacion) {
                        await PushNotificationProvider.firebaseMessaging.subscribeToTopic(_prefs.estado);
                      } else {
                        await PushNotificationProvider.firebaseMessaging.unsubscribeFromTopic(_prefs.estado);
                      }
                    });
                  },
                  value: _prefs.isNotificacion,
                )),
          ],
        ));
  }

  dialogCambiarEstado(BuildContext context) async {
    List<dynamic> nombreEdo = await consultarAPIEstados();
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Seleccione el estado en el que se encuentra", textAlign: TextAlign.center, style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.bold)),
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

          FirebaseMessaging.instance.requestPermission(sound: true, badge: true, alert: true, provisional: false);

          if (tempEstado != "Seleccione el estado") {
            await PushNotificationProvider.firebaseMessaging.unsubscribeFromTopic(tempEstado);
          }

          _prefs.isNotificacion = true;

          //Utilizo esto para que pueda ingresarse en un topic (tag) es decir si es YUCATAN a todos los de YUCATAN les llegará la notificación
          await PushNotificationProvider.firebaseMessaging.subscribeToTopic(_prefs.estado);
          if (this.mounted) {
            setState(() {});
          }
        },
        hint: Text(
          _prefs.estado,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
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
}
