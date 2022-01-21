import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salud_y_mas/preferences/preferences.dart';
import 'package:salud_y_mas/src/models/notificaciones_model.dart';
import 'package:salud_y_mas/src/pages/notificaciones/notificaciones_page.dart';
import 'package:salud_y_mas/src/pages/perfilUsuario.dart';

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
                    DrawerHeader(
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
                                  "Bienvenido(a) ${_prefs.nombre} ${_prefs.paterno}",
                                  style: GoogleFonts.firaSans(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
                                ),
                              ),
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
                      leading: Icon(Icons.account_box),
                      title: Text(
                        "Mi perfil",
                        style: TextStyle(),
                      ),
                      onTap: () {
                        if (ModalRoute.of(context)!.settings.name != "perfil") {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => PerfilUsuario(_prefs.nombre)));
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
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => NotificacionesPage(isMenu: true),
                            ),
                          );
                        }
                      },
                    )),
                    ListTile(
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      leading: Icon(
                        Icons.exit_to_app,
                        color: Colors.brown,
                      ),
                      title: Text('Cerrar sesión'),
                      onTap: () async {
                        showDialog(context: context, builder: Alerts().dialogCerrarSesion);
                      },
                    )
                  ],
                )),
              ])))));
    }));
  }
}
