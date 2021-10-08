import 'dart:collection';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:salud_y_mas/src/models/modeloCedulas.dart';
import 'package:salud_y_mas/src/models/modeloInformacionMedico.dart';
import 'package:salud_y_mas/src/models/modeloInformacionMedicosClinicas.dart';
import 'package:salud_y_mas/src/models/modeloMedicosClinicas.dart';
import 'package:collection/collection.Dart';
import 'package:salud_y_mas/src/models/modeloServicios.dart';

class ClinicasInformacion extends StatefulWidget {
  String idClinicas;
  String idEdo;
  String idCd;
  String idCate;
  String nameClinica;
  ClinicasInformacion(this.idClinicas, this.idEdo,this.idCd,this.idCate,this.nameClinica,{Key? key}) : super(key: key);

  @override
  _ClinicasInformacionState createState() => _ClinicasInformacionState();
}


class _ClinicasInformacionState extends State<ClinicasInformacion> {
  String urlApi = 'https://www.salumas.com/Salud_Y_Mas_Api/';

  ///en esta lista guardamos los datos de los clientes de cada clinica
  List<ModeloMedicoClinicas> datosEspecialidad = [];
  ///en esta lista guardamos el id de cada medico
  List<String> listaMedicos = [];
  String resMedicos ='';

  ///en esta lista guardamos todos los datos de las cedulas
  List<ModeloCedulas> clieEs=[];
  ///en esta lista gurdamos nada mas las cedulas el tipo de cedula y el nombre de la escuela
  List<String> listaCedulas = [];
  String resultados = "";

 ///en esta lista estan almacenado los servicios
  List<ModeloServicios> modeloServ = [];
  List<String> listaServicios = [];
  String resServicios="";


  List<ModeloInfomacionClientesMedicos> listaInfMe=[];
  List<String> listaCompleta = [];
  ModeloInfomacionClientesMedicos modelo = new ModeloInfomacionClientesMedicos('','','','','','','','','','','','','','','','','','');


  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    consultarMedicosInformacion(widget.idClinicas).then((value) {
      setState(() {
      });
    });
  }
  //en este metodo se consulta las cedulas
  Future consultarCedulas() async {
   for(var id in listaMedicos){
     print(listaMedicos.toString()+': tiene lista medicos');
     final  urlApi = Uri.parse("https://www.salumas.com/Salud_Y_Mas_Api/consulta_cliente_cedula?idCliente="+id);
     var response = await http.get(urlApi);
     var jsonBody = jsonDecode(response.body);
     print('el bodi: '+jsonBody.toString());
     for (var data in jsonBody) {
       clieEs.add(new ModeloCedulas(data['idcliente'],data['idcedula'],data['tipoCedula'],
           data['cedula'],data['escuela'],data['cliente_idcliente']));
     }
     for(int i=0; i<clieEs.length;i++){
       listaCedulas.add(clieEs.elementAt(i).idcliente.toString()+"//"+clieEs.elementAt(i).tipoCedula.toString()+"//"+clieEs.elementAt(i).cedula.toString()+"//"+clieEs.elementAt(i).escuela.toString()+"\n");
       for(int j=0; j<listaCedulas.length;j++){
         resultados += listaCedulas.elementAt(j);
         print('el res: '+resultados);
         listaCedulas.clear();
       }
     }
     clieEs.clear();
     listaMedicos.clear();
   }
  }

  consultarInformacionMedicoHospital() async {
    for(var id in listaMedicos){
      final  urlApi = Uri.parse("https://www.salumas.com/Salud_Y_Mas_Api/consultarInformacionMedico?idcliente="+id);
      var response = await http.get(urlApi);
      var jsonBody = jsonDecode(response.body);
     /* List<dynamic> resp = json.decode(response.body);
      Map<String, dynamic> decodedResp = resp.first;
      modelo = ModeloInfomacionClientesMedicos.fromJson(decodedResp);*/

     // print('el bodi: '+jsonBody.toString());
     for (var data in jsonBody) {
        listaInfMe.add(new ModeloInfomacionClientesMedicos(
            data['idcliente'],
            data['descripcion_espe'], data['telefono1'],data['telefono2'],
            data['telefono_emergencias'], data['facebook'], data['instagram'],
            data['twitter'], data['e_mail'],data['horario'],
            data['whatsapp'], data['pagina_web'], data['datos_extra'],
            data['direccion'], data['tipoCedula'], data['cedula'],
            data['escuela'], data['nombre']));
      }


      for(int i=0; i<listaInfMe.length;i++){
        listaCompleta.add(listaInfMe.elementAt(i).descripcion_espe.toString());
        print('lista: '+listaCompleta.toString());
        listaCompleta.clear();
      }
      listaInfMe.clear();
      listaMedicos.clear();
    }

  }

  consultarMedicosInformacion(String idClinicas) async {
    final  urlApi = Uri.parse("https://www.salumas.com/Salud_Y_Mas_Api/consulta_medicos_clinicas?idClinica="+idClinicas);
    var response = await http.get(urlApi);
    var jsonBody = json.decode(response.body);
    print(urlApi);
    for (var data in jsonBody) {
      datosEspecialidad.add(new ModeloMedicoClinicas(data['idcliente'],data['nombre'],
          data['clinicasyhospitales_idclinicasyhospitales']));
    }
    for (var datosid in datosEspecialidad){
      listaMedicos.add(datosid.idcliente);
      consultarCedulas().then((value) {
        setState(() {
          listaMedicos.addAll(listaCedulas);
          print('esto tiene listaMedicos: '+listaMedicos.toString());
        });
      });

     /* consultarInformacionMedicoHospital().then((value) {
        setState(() {


        });
      });*/
      listaMedicos.clear();
    }
  }

  conustarServiciosMedicos() async {
    for (var id in listaMedicos){
      final  urlApi = Uri.parse("https://www.salumas.com/Salud_Y_Mas_Api/consulta_cliente_servicios?idCliente="+id);
      var response = await http.get(urlApi);
      var jsonBody =   json.decode(response.body);
      for (var data in jsonBody) {
        modeloServ.add(new ModeloServicios(data['idcliente'],data['idservicios'],data['nombre'],
            data['descripcion'],data['costo'],data['cliente_idcliente']));
      }
      for(int i=0; i<modeloServ.length;i++){
        listaServicios.add(modeloServ.elementAt(i).idcliente.toString()+modeloServ.elementAt(i).nombre.toString()+",");
        for(int j=0; j<listaServicios.length;j++){
          resServicios += listaServicios.elementAt(j);
          listaServicios.clear();
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.nameClinica),
        ),
        body: mostrarMedicos(),
      ),

    );
  }

  mostrarMedicos() {
    var size = MediaQuery.of(context).size;
    final double itemHeight = size.height * 15.8;
    final double itemWidth = size.width * 120;
    return  Container(
      child: new GridView.count(
        crossAxisCount: 1,
        childAspectRatio: (itemWidth / itemHeight),
        controller: new ScrollController(keepScrollOffset: false),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: datosEspecialidad.map((medicos) {
          return new Container(
            margin: new EdgeInsets.all(1.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: (){
                   /* Navigator.of(context).push(MaterialPageRoute<Null>(
                        builder:  (BuildContext context){
                          String nombreMEdico = medicos.nombre;
                          String idCliente = medicos.idcliente;
                          /*String nameCd = widget.nombreCiudad;
                           String idCategoria = widget.idCategoria;
                           String idEspeciliad = espe.idespecialidad;*/
                          return InformacionMedico(nombreMEdico,idCliente);
                        }));*/
                  },
                  child: Card(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[
                                Text(medicos.nombre),
                                 Text(modelo.cedula.toString()),
                              //  Text(resServicios),
                                //if(medicos.horario == null || medicos.horario.toString().isEmpty)Visibility(visible:false,child:Text(medicos.horario.toString()))
                               // else Text(medicos.horario.toString()),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}


