import 'package:flutter/material.dart';
import 'package:salud_y_mas/src/pages/landing_page.dart';
import 'package:salud_y_mas/src/pages/login_page.dart';
import 'package:salud_y_mas/src/pages/notificaciones/notificaciones.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => Landing(),
    'login': (BuildContext context) => LoginPage(),
    'notificaciones': (BuildContext context) => NotificacionesPage()
    //'ESPECIALIDADES'  :  (BuildContext context) => EspecialidadCategoria(),
  };
}
