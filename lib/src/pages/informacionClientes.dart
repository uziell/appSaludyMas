import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/retry.dart';
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
  List<ModeloInformacionMedico> informacionMedico = [];
  @override
  void initState() {
    super.initState();
    consultarInformacionMedico(widget.idCliente);
    
  }
  Future consultarInformacionMedico(String idCliente) async {
    final  urlApi = Uri.parse("https://www.salumas.com/Salud_Y_Mas_Api/consulta_cliente_general?idCliente="+idCliente);
    var response = await http.get(urlApi);
    var jsonBody =   json.decode(response.body);
    print(urlApi);
    for (var data in jsonBody) {
      informacionMedico.add(new ModeloInformacionMedico(data['idcliente'],data['nombre'], data['descripcion_espe'],
      data['telefono1'], data['telefono2'], data['telefono_emergencias'], data['facebook'],data['instagram'], 
      data['twitter'], data['e_mail'],
      data['horario'], data['whatsapp'], data['pagina_web'],data['datos_extra'], data['estatus'])); 
    } 
    informacionMedico.forEach((someData)=>print('Name : ${someData.nombre}'));     
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
            child: Text(widget.nombreMedico)
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

  
 
}