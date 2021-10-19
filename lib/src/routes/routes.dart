
import 'package:flutter/material.dart';
import 'package:salud_y_mas/src/pages/pantalla_inicio.dart';



Map<String, WidgetBuilder> getApplicationRoutes(){
  
  return <String, WidgetBuilder> {
    '/'  :  (BuildContext context) => HomePage(),
    //'ESPECIALIDADES'  :  (BuildContext context) => EspecialidadCategoria(),
  };
}
