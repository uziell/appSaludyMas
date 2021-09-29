
import 'package:flutter/material.dart';
import 'package:salud_y_mas/src/pages/mostrarClientes.dart';
import 'package:salud_y_mas/src/pages/pantalla_principal.dart';


Map<String, WidgetBuilder> getApplicationRoutes(){
  
  return <String, WidgetBuilder> {
    '/'  :  (BuildContext context) => PantallaPrincipal(),
    //'ESPECIALIDADES'  :  (BuildContext context) => EspecialidadCategoria(),
  };
}
