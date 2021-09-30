import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:salud_y_mas/src/models/modeloCedulas.dart';
import 'package:salud_y_mas/src/models/modeloInformacionMedico.dart';

class InformacionMedico extends StatefulWidget {
  String nombreMedico;
  String idCliente;
  InformacionMedico(this.nombreMedico,this.idCliente,{Key? key}) : super(key: key);

  @override
  _InformacionMedicoState createState() => _InformacionMedicoState();
}

class _InformacionMedicoState extends State<InformacionMedico> {
   String urlApi = 'https://www.salumas.com/Salud_Y_Mas_Api/';
   ModeloInformacionMedico modelo = new ModeloInformacionMedico('','','','','','','','','','','','','','','');
   ModeloCedulas cedulas =  new ModeloCedulas('', '','', '', '', '');
  @override
  void initState(){
    super.initState();
   // consultarInformacionMedico(widget.idCliente);
    consultaInformacion(widget.idCliente);
    consultarCedulas(widget.idCliente);
  }
   consultaInformacion(String idCliente) async {
     final  urlApi = Uri.parse("https://www.salumas.com/Salud_Y_Mas_Api/consulta_cliente_general?idCliente="+idCliente);
     var response = await http.get(urlApi);
     List<dynamic> resp = json.decode(response.body);
     Map<String, dynamic> decodedResp = resp.first;
     modelo =  ModeloInformacionMedico.fromJson(decodedResp);
     print(modelo.descripcion_espe);
   }
   consultarCedulas(String idCliente) async {
     final  urlApi = Uri.parse("https://www.salumas.com/Salud_Y_Mas_Api/consulta_cliente_cedula?idCliente="+idCliente);
     var response = await http.get(urlApi);
     List<dynamic> resp = json.decode(response.body);
     Map<String, dynamic> decodedResp = resp.first;
     cedulas =  ModeloCedulas.fromJson(decodedResp);
     print(cedulas.tipoCedula);
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nombreMedico),
      ),
      body: Column(
        children: [
          imagenMedico(),
          SizedBox(height: 10),
          informacionPersonal(),
        ],
      )
    );
  }

  imagenMedico() {
    final card = Container(
      //clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          FadeInImage(
            image:NetworkImage('https://www.xtrafondos.com/descargar.php?id=5846&resolucion=2560x1440'),
            placeholder: AssetImage('assets/jar-loading.gif'),
            fadeInDuration: Duration(milliseconds: 200),
            height: 230.0,
            fit: BoxFit.cover,
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text(widget.nombreMedico),
                Text(modelo.descripcion_espe.toString()),
              ],
            )
          ),
        ],
      ),
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.white,
        boxShadow:<BoxShadow>[
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            spreadRadius: 2.0,
            offset: Offset(2.0,-10.0),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.0),
        child: card,
      ),
    );
  }

  informacionPersonal() {
    return Card(
      color:const Color(0xff4fb3bf),
      child: Column(
        children: [
          Text(modelo.descripcion_espe.toString()),
        ],
      ),
    );
  }







  
 
}