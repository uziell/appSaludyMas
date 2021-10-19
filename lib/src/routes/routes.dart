
import 'package:flutter/material.dart';
import 'package:salud_y_mas/src/pages/pantalla_especialidades_categoria.dart';
import 'package:salud_y_mas/src/pages/pantalla_inicio.dart';
import 'package:salud_y_mas/src/pages/pantalla_principal.dart';


Map<String, WidgetBuilder> getApplicationRoutes(){
  
  return <String, WidgetBuilder> {
    '/'  :  (BuildContext context) => HomePage(),
    //'ESPECIALIDADES'  :  (BuildContext context) => EspecialidadCategoria(),
  };
}
