import 'package:flutter/material.dart';
import 'package:salud_y_mas/src/pages/landing_page.dart';
import 'package:salud_y_mas/src/pages/notificaciones/notificaciones_page.dart';
import 'package:salud_y_mas/src/pages/pantalla_inicio.dart';
import 'package:salud_y_mas/src/pages/revistas/revistas_page.dart';
import 'package:salud_y_mas/src/pages/ubicacion/ubicacion_page.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => Landing(),
    'notificaciones': (BuildContext context) => NotificacionesPage(),
    'inicio': (BuildContext context) => HomePage(),
    'revistas': (BuildContext context) => RevistasPage(),
    'ubicacion': (BuildContext context) => UbicacionPage()
  };
}
