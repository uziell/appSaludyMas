import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salud_y_mas/preferences/preferences.dart';
import 'package:salud_y_mas/src/pages/notificaciones/notificaciones_page.dart';
import 'package:salud_y_mas/src/pages/perfil/perfilUsuario.dart';
import 'package:http/http.dart' as http;
import 'alerts.dart';

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
                              colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.3),
                                  BlendMode.darken),
                            )),
                            alignment: Alignment.center,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    child: Container(
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            child: FadeInImage(
                                                fit: BoxFit.cover,
                                                placeholder: AssetImage(
                                                    "assets/Saludymas.png"),
                                                width: 90,
                                                height: 90,
                                                image: AssetImage(
                                                    'assets/Saludymas.png')))),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 7),
                                    child: Text(
                                      _prefs.logIn
                                          ? "Bienvenido(a) ${_prefs.nombre} ${_prefs.paterno}"
                                          : "Invitado",
                                      style: GoogleFonts.firaSans(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 16),
                                    ),
                                  ),
                                  ElevatedButton(onPressed: (){
                                     dialogCambiarEstado(context);
                                  }, child: Text('Cambiar estado'))
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
                        if (ModalRoute.of(context)!.settings.name !=
                            "revistas") {
                          Navigator.of(context)
                              .pushReplacementNamed('revistas');
                        }
                      },
                    )),
                    _prefs.logIn
                        ? Container(
                            child: ListTile(
                            hoverColor: Colors.purple,
                            contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            leading: Icon(Icons.account_box),
                            title: Text(
                              "Mi perfil",
                              style: TextStyle(),
                            ),
                            onTap: () {
                              if (ModalRoute.of(context)!.settings.name !=
                                  "perfil") {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        PerfilUsuario(_prefs.nombre)));
                              }
                            },
                          ))
                        : Container(),
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
                        if (ModalRoute.of(context)!.settings.name !=
                            "notificaciones") {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) =>
                                  NotificacionesPage(isMenu: true),
                            ),
                          );
                        }
                      },
                    )),
                    _prefs.logIn == false
                        ? ListTile(
                            contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            leading: Icon(
                              Icons.login,
                              color: Colors.brown,
                            ),
                            title: Text('Iniciar sesión'),
                            onTap: () async {
                              showDialog(
                                  context: context,
                                  builder: Alerts().dialogCerrarSesion);
                            },
                          )
                        : Container(),
                    _prefs.logIn
                        ? ListTile(
                            contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            leading: Icon(
                              Icons.logout,
                              color: Colors.brown,
                            ),
                            title: Text('Cerrar sesión'),
                            onTap: () async {
                              showDialog(
                                  context: context,
                                  builder: Alerts().dialogCerrarSesion);
                            },
                          )
                        : Container()
                  ],
                )),
              ])))));
    }));
  }

   dropdownEstados(List<dynamic>nombreEdo)  {
    

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
        onChanged: (estadoActual) {
          _prefs.estado = estadoActual.toString();
        },
        hint: Text(
          _prefs.estado,
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
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

    dialogCambiarEstado(BuildContext context) async{

   List<dynamic> nombreEdo = await consultarAPIEstados();
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Seleccione el estado en el que se encuentra",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                      fontSize: 12,
                     
                      fontWeight: FontWeight.bold)),

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
