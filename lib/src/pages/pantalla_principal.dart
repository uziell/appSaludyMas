import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;






class PantallaPrincipal extends StatefulWidget {
  @override
  _PantallaPrincipalState createState() => _PantallaPrincipalState();
}
class _PantallaPrincipalState extends State<PantallaPrincipal> {

  List<String> estadosConsulta = [], ciudadesConsulta = [];
  String _estadoActual = '', _ciudadActual = "";
  List<DropdownMenuItem<String>> _dropDownMenuEstados = [], _dropDownMenuCiudades = [];
  
  List<String> imags = [];
  Future consultarAPIEstados() async {
    final url = Uri.parse('http://www.salumas.com/Salud_Y_Mas_Api/consultas_edo.php');
    var response = await http.get(url);
    var respuesta = jsonDecode(response.body);

    for (var valor in respuesta) {
      estadosConsulta.add((valor['nombre']));
    }
  }

  List<DropdownMenuItem<String>> contruirDropEstados() {
    List<DropdownMenuItem<String>> items = [];

    for (String estado in estadosConsulta) {
      items.add(
          DropdownMenuItem(
            child: Text(estado),
            value:  estado,
              )
      );

      print('Esto tiene estados: '+ estado);
      print('Este es un estado nuevo'+estado);
    }
    return items;
  }

  Future consultarAPICiudades(String estadoCiu) async {
    _dropDownMenuCiudades.clear();
    ciudadesConsulta.clear();
    _ciudadActual = '';
    final url = Uri.parse('http://www.salumas.com/Salud_Y_Mas_Api/consultas_cd?nameEdo='+estadoCiu);
    var response = await http.get(url);
    var respuesta = jsonDecode(response.body);

    //print(respuesta);
    for (var valor in respuesta) {
      ciudadesConsulta.add((valor['nombre']));
      
    }
    
    if(ciudadesConsulta.isEmpty){
      return;
    }
  
    List<DropdownMenuItem<String>> itemsC = [];
    for (String ciudades in ciudadesConsulta) {
      itemsC.add(
          DropdownMenuItem(
              value: ciudades,
              child: Text(ciudades, 
              textAlign: TextAlign.left,
             ))         
      ); 
      _dropDownMenuCiudades = itemsC;
      print('Esto tiene ciudades: '+ ciudades);
     // print('item: '+itemsC.toString());
    }     
  }

  @override
  initState() {
    super.initState();
    consultarAPIEstados().then((resultado) {
      setState(() {
        _dropDownMenuEstados = contruirDropEstados();
        _estadoActual = _dropDownMenuEstados[0].value.toString();
        
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Salud y Mas'),
        ),
        body: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [  
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DropdownButton(
                    hint: Text('Seleccionar estado'),
                    value: _estadoActual,
                    items: _dropDownMenuEstados,
                    onChanged: (seleccion){
                      setState(() {
                        _estadoActual = seleccion.toString();
                       //print('Este tiene mi estado actual: '+ _estadoActual);
                        consultarAPICiudades(_estadoActual).then((value) {
                          setState(() {
                            _ciudadActual = _dropDownMenuCiudades[0].value.toString();
                          });
                        });
                      });
                    },
                  ),
                  DropdownButton(
                    hint: Text('Seleccionar ciudad'),
                    value: _ciudadActual,
                    items: _dropDownMenuCiudades ,
                    onChanged: (seleccion){
                      setState(() {
                        _ciudadActual = seleccion.toString();
                      });
                    },
                  )
                ],
              ),
            ),
          ],
          
        ),
      ),
    );
  }
}