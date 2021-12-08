import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:salud_y_mas/src/clases/claseMedicosClinicas.dart';
import 'package:salud_y_mas/src/models/modeloCedulas.dart';
import 'package:salud_y_mas/src/models/modeloInformacionMedicosClinicas.dart';
import 'package:salud_y_mas/src/models/modeloMedicosClinicas.dart';
import 'package:salud_y_mas/src/models/modeloServicios.dart';
import 'package:url_launcher/url_launcher.dart';

class ClinicasInformacion extends StatefulWidget {
  String idClinicas;
  String idEdo;
  String idCd;
  String idCate;
  String nameClinica;
  String colorEdo;
  ClinicasInformacion(this.idClinicas, this.idEdo, this.idCd, this.idCate, this.nameClinica, this.colorEdo, {Key? key}) : super(key: key);

  @override
  _ClinicasInformacionState createState() => _ClinicasInformacionState();
}

class _ClinicasInformacionState extends State<ClinicasInformacion> {
  String urlApi = 'https://www.salumas.com/Salud_Y_Mas_Api/';

  ///en esta lista guardamos los datos de los clientes de cada clinica
  List<ModeloMedicoClinicas> datosEspecialidad = [];

  ///en esta lista guardamos el id de cada medico
  List<String> listaMedicos = [];
  List<String> listanombres = [];
  String resMedicos = '';

  ///en esta lista guardamos todos los datos de las cedulas
  List<ModeloCedulas> clieEs = [];

  ///en esta lista gurdamos nada mas las cedulas el tipo de cedula y el nombre de la escuela
  List<String> listaCedulas = [];

  ///en esta lista estan almacenado los servicios
  List<ModeloServicios> modeloServ = [];
  List<String> listaServicios = [];
  String resServicios = "";

  List<ModeloInfomacionClientesMedicos> listaInfMe = [];
  // ModeloInfomacionClientesMedicos modelo = new ModeloInfomacionClientesMedicos('','','','','','','','','','','','','','','','','','');
  //ModeloMedicoClinicas modeloMedicoClinicas= new ModeloMedicoClinicas('','','','','','','','','','','','','','','','','','','');
  List<InfMeClinicas> info = [];

  String? dire, tel1, tel2, telE, face, insta, twi, em, what, pagWeb;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    //mandamos a llamar el metodo donde obtendremos a los medicos de cada clinica

    consultarMedicosInformacion(widget.idClinicas).then((value) {
      setState(() {
        //consulta la cedula de cada Medico
        consultarCedulas().then((value) {
          setState(() {});
        });

        //consulta el servicio de cada medico
      });
    });
  }

  //en este metodo se consulta las cedulas
  Future consultarCedulas() async {
    //hacemos el recorrido con un foreach para hacer las consultas de las cedulas con su respectivo id
    for (var id in datosEspecialidad) {
      //print('esto tien id+ '+id.idcliente.toString());

      final urlApi = Uri.parse("https://www.salumas.com/Salud_Y_Mas_Api/consulta_cliente_cedula?idCliente=" + id.idcliente);
      var response = await http.get(urlApi);
      var jsonBody = jsonDecode(response.body);

      print('el body' + jsonBody.toString());
      //hacemos el recorrido de los que nos trae el json y se lo agregamos a la lista de CliEs.
      for (var data in jsonBody) {
        clieEs.add(new ModeloCedulas(data['idcliente'], data['idcedula'], data['tipoCedula'], data['cedula'], data['escuela'], data['cliente_idcliente']));
      }
      var cedulas = "";
      // por cada medico agregar detalles de la cédula a la lista de cédulas [{id, nombreCedula, cédula, nombreEscuela},{id, nombreCedula, cédula, nombreEscuela}...]
      for (int i = 0; i < clieEs.length; i++) {
        if (i == 0)
          cedulas += clieEs.elementAt(i).tipoCedula.toString() + "//" + clieEs.elementAt(i).cedula.toString() + "//" + clieEs.elementAt(i).escuela.toString();
        else if (clieEs.elementAt(i).escuela == null)
          cedulas += clieEs.elementAt(i).tipoCedula.toString() + " " + clieEs.elementAt(i).cedula.toString();
        else
          cedulas += "\n" + clieEs.elementAt(i).tipoCedula.toString() + "//" + clieEs.elementAt(i).cedula.toString() + "//" + clieEs.elementAt(i).escuela.toString();
      }

      //llenamos la lista de informacion medicos
      info.add(new InfMeClinicas(
          id.idcliente.toString(),
          id.nombre.toString(),
          id.descripcion_espe.toString(),
          id.telefono1.toString(),
          id.telefono2.toString(),
          id.telefono_emergencias.toString(),
          id.facebook.toString(),
          id.instagram.toString(),
          id.twitter.toString(),
          id.e_mail.toString(),
          id.horario.toString(),
          id.whatsapp.toString(),
          id.pagina_web.toString(),
          id.datos_extra.toString(),
          id.estatus.toString(),
          id.serviciosNombre.toString(),
          id.clinicasyhospitales_idclinicasyhospitales.toString(),
          id.direccion.toString(),
          cedulas,
          '',
          '',
          id.imagenName.toString()));

      // es estas variables igualamos dentro de foreach de datos especialidad para poder manejar la vista de los card
      dire = id.direccion.toString();
      tel1 = id.telefono1.toString();
      tel2 = id.telefono2.toString();
      telE = id.telefono_emergencias.toString();
      face = id.facebook.toString();
      insta = id.instagram.toString();
      what = id.whatsapp.toString();
      pagWeb = id.pagina_web.toString();
      em = id.e_mail.toString();
      print('egf: ' + dire.toString());
      clieEs.clear();
    }
    datosEspecialidad.clear();
  }

  consultarMedicosInformacion(String idClinicas) async {
    final urlApi = Uri.parse("https://www.salumas.com/Salud_Y_Mas_Api/consulta_medicos_clinicas?idClinica=" + idClinicas);
    var response = await http.get(urlApi);
    var jsonBody = json.decode(response.body);
    print(urlApi);
    for (var data in jsonBody) {
      datosEspecialidad.add(new ModeloMedicoClinicas(
          data['idcliente'],
          data['nombre'],
          data['descripcion_espe'],
          data['telefono1'],
          data['telefono2'],
          data['telefono_emergencias'],
          data['facebook'],
          data['instagram'],
          data['twitter'],
          data['e_mail'],
          data['horario'],
          data['whatsapp'],
          data['pagina_web'],
          data['datos_extra'],
          data['estatus'],
          data['serviciosNombre'],
          data['clinicasyhospitales_idclinicasyhospitales'],
          data['direccion'],
          data['imagenName']));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/fondoPrincipal.jpg'),
              fit: BoxFit.cover,

              //colorFilter: ColorFilter.mode(Colors.white,)
            ),
          ),
        ),
        Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Color(int.parse(widget.colorEdo)),
              title: Text(widget.nameClinica, style: GoogleFonts.montserrat(color: Colors.white, fontSize: 14)),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // mostrarImagenPerfil(),
                  mostrarMedicos(),
                  if (dire == null || dire.toString().isEmpty) Visibility(visible: false, child: direccion()) else direccion(),
                  if (tel1 == null || tel1.toString().isEmpty) Visibility(visible: false, child: telefono1()) else telefono1(),
                  if (tel2 == null || tel2.toString().isEmpty) Visibility(visible: false, child: telefono2()) else telefono2(),
                  if (telE == null || telE.toString().isEmpty) Visibility(visible: false, child: telefono_emergencias()) else telefono_emergencias(),
                  if (face == null || face.toString().isEmpty) Visibility(visible: false, child: facebook()) else facebook(),
                  if (insta == null || insta.toString().isEmpty) Visibility(visible: false, child: instagram()) else instagram(),
                  if (what == null || what.toString().isEmpty) Visibility(visible: false, child: whatSapp()) else whatSapp(),
                  if (pagWeb == null || pagWeb.toString().isEmpty) Visibility(visible: false, child: paginaWeb()) else paginaWeb(),
                  if (em == null || em.toString().isEmpty) Visibility(visible: false, child: email()) else email()
                ],
              ),
            )
            //mostarMe(),
            ),
      ],
    );
  }

  mostrarImagenPerfil() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: info.map((medicos) {
          return Card(
            child: Column(
              children: [
                if (medicos.imagenName == 'null' || medicos.imagenName.toString().isEmpty)
                  Visibility(visible: false, child: Image.network(urlApi + 'images/' + medicos.imagenName.toString()))
                else
                  Image.network(urlApi + 'images/' + medicos.imagenName.toString()),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  mostrarMedicos() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: info.map((medicos) {
          return Card(
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (medicos.imagenName == 'null' || medicos.imagenName.toString().isEmpty)
                        Visibility(visible: false, child: Image.network(urlApi + 'images/' + medicos.imagenName.toString()))
                      else
                        Image.network(urlApi + 'images/' + medicos.imagenName.toString()),
                      Center(child: Text(medicos.nombreMedico.toString(), textAlign: TextAlign.center, style: GoogleFonts.montserrat(fontSize: 13, color: Colors.blue))),
                      if (medicos.descripcion_espe == 'null' || medicos.descripcion_espe.toString().isEmpty)
                        Visibility(visible: false, child: Text(medicos.descripcion_espe.toString()))
                      else
                        Center(child: Text(medicos.descripcion_espe.toString(), textAlign: TextAlign.center, style: GoogleFonts.montserrat(fontSize: 13))),
                      if (medicos.serviciosNombre == 'null' || medicos.serviciosNombre.toString().isEmpty)
                        Visibility(visible: false, child: Text(medicos.serviciosNombre.toString()))
                      else
                        Center(child: Text(medicos.serviciosNombre.toString(), style: GoogleFonts.montserrat(fontSize: 13))),
                      if (medicos.tipoCedula == 'null' || medicos.tipoCedula.toString().isEmpty)
                        Visibility(visible: false, child: Text(medicos.tipoCedula.toString()))
                      else
                        Center(child: Text(medicos.tipoCedula.toString(), style: GoogleFonts.montserrat(fontSize: 13))),
                      if (medicos.horario == 'null' || medicos.horario.toString().isEmpty)
                        Visibility(visible: false, child: Text(medicos.horario.toString()))
                      else
                        Center(child: Text(medicos.horario.toString(), style: GoogleFonts.montserrat(fontSize: 13))),
                      //if(medicos.direccion == 'null' || medicos.direccion.toString().isEmpty)Visibility(visible:false,child:direccion())else direccion(),
                    ],
                  ),
                ))
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  direccion() {
    return Card(
      child: Column(
        children: info.map((value) {
          return GestureDetector(
            onTap: () {
              setState(() {
                googleMaps(value.direccion.toString());
              });
            },
            child: Row(
              children: [
                if (value.direccion == 'null' || value.direccion.toString().isEmpty)
                  Visibility(visible: false, child: Container(width: 30.0, height: 40.0, child: Image.asset('assets/mapa.png')))
                else
                  Container(width: 30.0, height: 40.0, child: Image.asset('assets/mapa.png')),
                SizedBox(
                  width: 2.5,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      // border: Border.all(color: Colors.black,width: 2),
                      // color:const Color(0xff00838f),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (value.direccion == 'null' || value.direccion.toString().isEmpty)
                          Visibility(visible: false, child: Text(value.direccion.toString()))
                        else
                          Text(value.direccion.toString(), textAlign: TextAlign.center, style: GoogleFonts.montserrat(fontSize: 13))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  telefono1() {
    return Card(
      child: Column(
        children: info.map((value) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _makePhoneCall(value.telefono1.toString());
              });
            },
            child: Row(
              children: [
                if (value.telefono1 == 'null' || value.telefono1.toString().isEmpty)
                  Visibility(visible: false, child: Container(width: 30.0, height: 40.0, child: Image.asset('assets/telefono.png')))
                else
                  Container(width: 30.0, height: 40.0, child: Image.asset('assets/telefono.png')),
                SizedBox(
                  width: 2.5,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      // border: Border.all(color: Colors.black,width: 2),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (value.telefono1 == 'null' || value.telefono1.toString().isEmpty)
                          Visibility(visible: false, child: Text('Telefono'))
                        else
                          Text('Telefono (Agendar cita)', textAlign: TextAlign.center, style: GoogleFonts.montserrat(fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  telefono2() {
    return Card(
      child: Column(
        children: info.map((value) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _makePhoneCall(value.telefono2.toString());
              });
            },
            child: Row(
              children: [
                if (value.telefono2 == 'null' || value.telefono2.toString().isEmpty)
                  Visibility(visible: false, child: Container(width: 30.0, height: 40.0, child: Image.asset('assets/telefono.png')))
                else
                  Container(width: 30.0, height: 40.0, child: Image.asset('assets/telefono.png')),
                SizedBox(
                  width: 2.5,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        // border: Border.all(color: Colors.black,width: 2),
                        color: Colors.white),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (value.telefono2 == 'null' || value.telefono2.toString().isEmpty)
                          Visibility(visible: false, child: Text('Telefono'))
                        else
                          Text('Telefono 2', textAlign: TextAlign.center, style: GoogleFonts.montserrat(fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  telefono_emergencias() {
    return Card(
      child: GestureDetector(
        child: Column(
          children: info.map((value) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _makePhoneCall(value.telefono_emergencias.toString());
                });
              },
              child: Row(
                children: [
                  if (value.telefono_emergencias == 'null' || value.telefono_emergencias.toString().isEmpty)
                    Visibility(visible: false, child: Container(width: 30.0, height: 40.0, child: Image.asset('assets/llamada-de-emergencia.png')))
                  else
                    Container(width: 30.0, height: 40.0, child: Image.asset('assets/llamada-de-emergencia.png')),
                  SizedBox(
                    width: 2.5,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        // border: Border.all(color: Colors.black,width: 2),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (value.telefono_emergencias == 'null' || value.telefono_emergencias.toString().isEmpty)
                            Visibility(visible: false, child: Text('Telefono Emergencias'))
                          else
                            Text('Telefono Emergencias', textAlign: TextAlign.center, style: GoogleFonts.montserrat(fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  whatSapp() {
    return Card(
      child: GestureDetector(
        child: Column(
          children: info.map((value) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  launchWhatsApp('+52' + value.whatsapp.toString());
                });
              },
              child: Row(
                children: [
                  if (value.whatsapp == 'null' || value.whatsapp.toString().isEmpty)
                    Visibility(visible: false, child: Container(width: 30.0, height: 40.0, child: Image.asset('assets/whatsapp.png')))
                  else
                    Container(width: 30.0, height: 40.0, child: Image.asset('assets/whatsapp.png')),
                  SizedBox(
                    width: 2.5,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        // border: Border.all(color: Colors.black,width: 2),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (value.whatsapp == 'null' || value.whatsapp.toString().isEmpty)
                            Visibility(visible: false, child: Text('Whatsapp'))
                          else
                            Text('WhatSapp', textAlign: TextAlign.center, style: GoogleFonts.montserrat(fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  facebook() {
    return Card(
      child: GestureDetector(
        child: Column(
          children: info.map((value) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _facebook(value.facebook.toString());
                });
              },
              child: Row(
                children: [
                  if (value.facebook == 'null' || value.facebook.toString().isEmpty)
                    Visibility(visible: false, child: Container(width: 30.0, height: 40.0, child: Image.asset('assets/facebook.png')))
                  else
                    Container(width: 30.0, height: 40.0, child: Image.asset('assets/facebook.png')),
                  SizedBox(
                    width: 2.5,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        // border: Border.all(color: Colors.black,width: 2),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (value.facebook == 'null' || value.facebook.toString().isEmpty)
                            Visibility(visible: false, child: Text('Facebook'))
                          else
                            Text('Facebook', textAlign: TextAlign.center, style: GoogleFonts.montserrat(fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  instagram() {
    return Card(
      child: GestureDetector(
        child: Column(
          children: info.map((value) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _instagram(value.instagram.toString());
                });
              },
              child: Row(
                children: [
                  if (value.instagram == 'null' || value.instagram.toString().isEmpty)
                    Visibility(visible: false, child: Container(width: 30.0, height: 40.0, child: Image.asset('assets/instagram.png')))
                  else
                    Container(width: 30.0, height: 40.0, child: Image.asset('assets/instagram.png')),
                  SizedBox(
                    width: 2.5,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        // border: Border.all(color: Colors.black,width: 2),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (value.instagram == 'null' || value.instagram.toString().isEmpty)
                            Visibility(visible: false, child: Text('Instagram'))
                          else
                            Text('Instagram', textAlign: TextAlign.center, style: GoogleFonts.montserrat(fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  paginaWeb() {
    return Card(
      child: GestureDetector(
        child: Column(
          children: info.map((value) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  ulrWeb(value.pagina_web.toString());
                });
              },
              child: Row(
                children: [
                  if (value.pagina_web == 'null' || value.pagina_web.toString().isEmpty)
                    Visibility(
                        visible: false,
                        child: Container(
                          width: 30.0,
                          height: 40.0,
                          child: Image.asset('assets/red-mundial.png'),
                        ))
                  else
                    Container(
                      width: 30.0,
                      height: 40.0,
                      child: Image.asset('assets/red-mundial.png'),
                    ),
                  SizedBox(
                    width: 2.5,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        // border: Border.all(color: Colors.black,width: 2),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (value.pagina_web == 'null' || value.pagina_web.toString().isEmpty)
                            Visibility(visible: false, child: Text('Pagina Web'))
                          else
                            Text('Pagina Web', textAlign: TextAlign.center, style: GoogleFonts.montserrat(fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  email() {
    return Card(
      child: GestureDetector(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: info.map((value) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  correo(value.e_mail.toString());
                });
              },
              child: Row(
                children: [
                  if (value.e_mail == 'null' || value.e_mail.toString().isEmpty)
                    Visibility(visible: false, child: Container(width: 30.0, height: 40.0, child: Image.asset('assets/email.png')))
                  else
                    Container(width: 30.0, height: 40.0, child: Image.asset('assets/email.png')),
                  SizedBox(
                    width: 2.5,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        // border: Border.all(color: Colors.black,width: 2),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (value.e_mail == 'null' || value.e_mail.toString().isEmpty)
                            Visibility(visible: false, child: Text('Email'))
                          else
                            Text('Email', textAlign: TextAlign.center, style: GoogleFonts.montserrat(fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> googleMaps(@required urls) async {
    String url() {
      if (Platform.isIOS) {
        return Uri.encodeFull("https://maps.apple.com/?q=$urls");
      } else {
        return "google.navigation:q=$urls";
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else if (!await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }

  Future<void> _makePhoneCall(@required numero) async {
    String url() {
      if (Platform.isIOS) {
        return "tel://$numero";
      } else {
        return "tel://$numero";
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else if (!await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }

  void launchWhatsApp(@required number) async {
    String url() {
      if (Platform.isIOS) {
        return "whatsapp://send?phone=$number";
      } else {
        return "whatsapp://send?phone=$number";
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else if (!await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }

  Future<void> _facebook(@required link) async {
    String url() {
      if (Platform.isIOS) {
        return "https://www.facebook.com/$link";
      } else {
        return "https://www.facebook.com/$link";
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else if (!await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }

  Future<void> _instagram(@required link) async {
    String url() {
      if (Platform.isIOS) {
        return "https://www.instagram.com/$link";
      } else {
        return "https://www.instagram.com/$link";
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else if (!await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }

  Future<void> ulrWeb(@required link) async {
    String url() {
      if (Platform.isIOS) {
        return "https://$link";
      } else {
        return "https://$link";
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else if (!await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }

  Future<void> correo(@required correooo) async {
    String url() {
      if (Platform.isIOS) {
        return "mailto:$correooo";
      } else {
        return "mailto:$correooo";
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else if (!await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }
}
