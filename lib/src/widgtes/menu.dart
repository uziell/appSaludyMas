import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salud_y_mas/notification_providers/push_notification_providers.dart';
import 'package:salud_y_mas/preferences/preferences.dart';
import 'package:salud_y_mas/src/pages/notificaciones/notificaciones_page.dart';
import 'package:http/http.dart' as http;

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  AppPreferences _prefs = AppPreferences();
  @override
  Widget build(BuildContext context) {
    return Drawer(child: LayoutBuilder(builder: (context, constraint) {
      return SingleChildScrollView(
          child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                  child: Container(
                      child: Column(children: [
                Expanded(
                    child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.all(0),
                        child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              image: AssetImage('assets/fondo.jpeg'),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
                            )),
                            alignment: Alignment.center,
                            child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
                              GestureDetector(
                                child: Container(
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(100.0),
                                        child: FadeInImage(fit: BoxFit.cover, placeholder: AssetImage("assets/Saludymas.png"), width: 90, height: 90, image: AssetImage('assets/Saludymas.png')))),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 7),
                                child: Text(
                                  "Bienvenido(a)",
                                  style: GoogleFonts.firaSans(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 7),
                                child: Text(
                                  "Estado: ${_prefs.estado == 'Seleccione un estado' ? 'Sin seleccionar' : _prefs.estado}",
                                  style: GoogleFonts.firaSans(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
                                ),
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    dialogCambiarEstado(context);
                                  },
                                  child: Text('Cambiar estado'))
                            ]))),
                    Container(
                        child: ListTile(
                      hoverColor: Colors.purple,
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      leading: Icon(Icons.home),
                      title: Text(
                        "Inicio",
                        style: TextStyle(),
                      ),
                      onTap: () {
                        if (ModalRoute.of(context)!.settings.name != "inicio") {
                          Navigator.of(context).pushReplacementNamed('inicio');
                        }
                      },
                    )),
                    Container(
                        child: ListTile(
                      hoverColor: Colors.purple,
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      leading: Icon(Icons.new_releases_rounded),
                      title: Text(
                        "Revistas",
                        style: TextStyle(),
                      ),
                      onTap: () {
                        if (ModalRoute.of(context)!.settings.name != "revistas") {
                          Navigator.of(context).pushReplacementNamed('revistas');
                        }
                      },
                    )),
                    Container(
                        child: ListTile(
                      hoverColor: Colors.purple,
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      leading: Icon(Icons.location_on),
                      title: Text(
                        "Mi ubicación",
                        style: TextStyle(),
                      ),
                      onTap: () {
                        if (ModalRoute.of(context)!.settings.name != "ubicacion") {
                          Navigator.of(context).pushReplacementNamed('ubicacion');
                        }
                      },
                    )),
                    Container(
                        child: ListTile(
                      hoverColor: Colors.purple,
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      leading: Icon(Icons.notifications),
                      title: Text(
                        "Notificaciones",
                        style: TextStyle(),
                      ),
                      onTap: () {
                        if (ModalRoute.of(context)!.settings.name != "notificaciones") {
                          if (_prefs.estado == "Seleccione el estado") {
                            return dialogCambiarEstado(context);
                          }
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => NotificacionesPage(isMenu: true),
                            ),
                          );
                        }
                      },
                    )),
                    Container(
                        child: ListTile(
                      hoverColor: Colors.purple,
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      leading: Icon(Icons.settings),
                      title: Text(
                        "Configuración",
                        style: TextStyle(),
                      ),
                      onTap: () {
                        if (ModalRoute.of(context)!.settings.name != "configuracion") {
                          Navigator.of(context).pushReplacementNamed('configuracion');
                        }
                      },
                    )),
                  ],
                )),
              ])))));
    }));
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
}
