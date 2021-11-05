import 'dart:io';
import 'package:card_swiper/card_swiper.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:salud_y_mas/src/models/modeloCedulas.dart';
import 'package:salud_y_mas/src/models/modeloDireccion.dart';
import 'package:salud_y_mas/src/models/modeloFormasPago.dart';
import 'package:salud_y_mas/src/models/modeloInformacionMedico.dart';
import 'package:salud_y_mas/src/models/modeloServicios.dart';
import 'package:salud_y_mas/src/pages/pantalla_inicio.dart';
import 'package:url_launcher/url_launcher.dart';

class InformacionMedico extends StatefulWidget {
  String nombreMedico;
  String idCliente;
  String imagenCategoria;
  String colorEdo;
  InformacionMedico(
      this.nombreMedico, this.idCliente, this.imagenCategoria, this.colorEdo,
      {Key? key})
      : super(key: key);

  @override
  _InformacionMedicoState createState() => _InformacionMedicoState();
}

class _InformacionMedicoState extends State<InformacionMedico> {
  String urlApi = 'https://www.salumas.com/Salud_Y_Mas_Api/';
  ModeloInformacionMedico modelo = new ModeloInformacionMedico(
      '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
  ModeloDireccion modeloDireccion = new ModeloDireccion('', '');
  List<ModeloCedulas> clieEs = [];
  List<String> listaCedulas = [];
  String resultados = "";
  List<ModeloServicios> modeloServ = [];
  List<String> listaServicios = [];
  String resServicios = "";
  List<ModeloFormasPago> modeloFp = [];
  List<String> listaFomasPago = [];
  String resFp = "";

  List<dynamic> listaCarrucelPersonal = [];
  List<String> listImagenes = [];

  int _paginaActual = 0;
  @override
  void initState() {
    super.initState();
    consultaInformacion(widget.idCliente).then((value) {
      setState(() {});
    });
    consultarCedulas(widget.idCliente).then((value) {
      setState(() {});
    });
    consultarServicios(widget.idCliente).then((value) {
      setState(() {});
    });
    conusultarFormasDePago(widget.idCliente).then((value) {
      setState(() {});
    });
    consultarDireccion(widget.idCliente).then((value) {
      setState(() {});
    });
    consultarCarruceCliente(widget.idCliente).then((value) {
      setState(() {
        llenarCarrucel(listaCarrucelPersonal);
      });
    });
  }

  consultarCarruceCliente(String idCliente) async {
    final url =
        Uri.parse(urlApi + 'consultas_carrucel_cliente?idCliente=' + idCliente);
    var response = await http.get(url);
    var respuestaImagen = jsonDecode(response.body);
    for (var valor in respuestaImagen) {
      listaCarrucelPersonal.add((valor['imagen']).toString());
    }
  }

  llenarCarrucel(List<dynamic> lista) {
    print('Esto tiene lista:' + lista.toString());
    for (var i = 0; i < lista.length; i++) {
      listImagenes.add(urlApi + '/images/' + lista[i]);
    }
  }

  consultaInformacion(String idCliente) async {
    final urlApi = Uri.parse(
        "https://www.salumas.com/Salud_Y_Mas_Api/consulta_cliente_general?idCliente=" +
            idCliente);
    var response = await http.get(urlApi);
    List<dynamic> resp = json.decode(response.body);
    Map<String, dynamic> decodedResp = resp.first;
    modelo = ModeloInformacionMedico.fromJson(decodedResp);

    print('json: ' + resp.toString());
    print(modelo.descripcion_espe);
  }

  consultarCedulas(String idCliente) async {
    final urlApi = Uri.parse(
        "https://www.salumas.com/Salud_Y_Mas_Api/consulta_cliente_cedula?idCliente=" +
            idCliente);
    var response = await http.get(urlApi);
    var jsonBody = json.decode(response.body);
    for (var data in jsonBody) {
      clieEs.add(new ModeloCedulas(
          data['idcliente'],
          data['idcedula'],
          data['tipoCedula'],
          data['cedula'],
          data['escuela'],
          data['cliente_idcliente']));
    }
    for (int i = 0; i < clieEs.length; i++) {
      if (clieEs.elementAt(i).escuela == null)
        listaCedulas.add(clieEs.elementAt(i).tipoCedula.toString() +
            "//" +
            clieEs.elementAt(i).cedula.toString() +
            "\n");
      else
        listaCedulas.add(clieEs.elementAt(i).tipoCedula.toString() +
            "//" +
            clieEs.elementAt(i).cedula.toString() +
            "//" +
            clieEs.elementAt(i).escuela.toString() +
            "\n");
      for (int j = 0; j < listaCedulas.length; j++) {
        resultados += listaCedulas.elementAt(j);
        listaCedulas.clear();
      }
    }
  }

  consultarServicios(String idCliente) async {
    final urlApi = Uri.parse(
        "https://www.salumas.com/Salud_Y_Mas_Api/consulta_cliente_servicios?idCliente=" +
            idCliente);
    var response = await http.get(urlApi);
    var jsonBody = json.decode(response.body);
    for (var data in jsonBody) {
      modeloServ.add(new ModeloServicios(
          data['idcliente'],
          data['idservicios'],
          data['nombre'],
          data['descripcion'],
          data['costo'],
          data['cliente_idcliente']));
    }
    for (int i = 0; i < modeloServ.length; i++) {
      listaServicios.add(modeloServ.elementAt(i).nombre.toString() + ",");
      for (int j = 0; j < listaServicios.length; j++) {
        resServicios += listaServicios.elementAt(j);
        listaServicios.clear();
      }
    }
  }

  conusultarFormasDePago(String idCliente) async {
    final urlApi = Uri.parse(
        "https://www.salumas.com/Salud_Y_Mas_Api/consulta_cliente_formaPago?idCliente=" +
            idCliente);
    var response = await http.get(urlApi);
    var jsonBody = json.decode(response.body);
    for (var data in jsonBody) {
      modeloFp.add(new ModeloFormasPago(
          data['idcliente'],
          data['formasPago_idformasPago'],
          data['cliente_idcliente'],
          data['nombre']));
    }
    for (int i = 0; i < modeloFp.length; i++) {
      listaFomasPago.add(modeloFp.elementAt(i).nombre.toString() + "\n");
      for (int j = 0; j < listaFomasPago.length; j++) {
        resFp += listaFomasPago.elementAt(j);
        listaFomasPago.clear();
      }
    }
  }

  consultarDireccion(String idCliente) async {
    final urlApi = Uri.parse(
        "https://www.salumas.com/Salud_Y_Mas_Api/consulta_cliente_direcciones?idCliente=" +
            idCliente);
    var response = await http.get(urlApi);
    List<dynamic> resp = json.decode(response.body);
    Map<String, dynamic> decodedResp = resp.first;
    modeloDireccion = ModeloDireccion.jsonFrom(decodedResp);
    print(modeloDireccion.direccion);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            //carrucelPersonal(),
            imagenMedico(),
            informacionPersonal(),
            if (modeloDireccion.direccion == null ||
                modeloDireccion.direccion.toString().isEmpty)
              Visibility(visible: false, child: direccion())
            else
              direccion(),
            if (modelo.telefono1 == null || modelo.telefono1.toString().isEmpty)
              Visibility(visible: false, child: telefono1())
            else
              telefono1(),
            if (modelo.telefono2 == null || modelo.telefono2.toString().isEmpty)
              Visibility(visible: false, child: telefono2())
            else
              telefono2(),
            if (modelo.telefono_emergencias == null ||
                modelo.telefono_emergencias.toString().isEmpty)
              Visibility(visible: false, child: telEmergencia())
            else
              telEmergencia(),
            if (modelo.whatsapp == null || modelo.whatsapp.toString().isEmpty)
              Visibility(visible: false, child: whatSapp())
            else
              whatSapp(),
            if (modelo.facebook == null || modelo.facebook.toString().isEmpty)
              Visibility(visible: false, child: facebook())
            else
              facebook(),
            if (modelo.instagram == null || modelo.instagram.toString().isEmpty)
              Visibility(visible: false, child: instragam())
            else
              instragam(),
            if (modelo.twitter == null || modelo.twitter.toString().isEmpty)
              Visibility(visible: false, child: twitter())
            else
              twitter(),
            if (modelo.pagina_web == null ||
                modelo.pagina_web.toString().isEmpty)
              Visibility(visible: false, child: paginaWeb())
            else
              paginaWeb(),
            if (modelo.e_mail == null || modelo.e_mail.toString().isEmpty)
              Visibility(visible: false, child: email())
            else
              email(),
            if (listaCarrucelPersonal.isEmpty)
              Visibility(visible: false, child: carrucelPersonal())
            else
              carrucelPersonal(),
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        //color: Color(int.parse(widget.colorEdo)),
        height: 40,
        onTap: (index) {
          setState(() {
            _paginaActual = index;
            if (_paginaActual == 0) {
              showDialog(context: context, builder: createDialog);
            }
          });
        },
        //currentIndex: _paginaActual,
        items: [
          Icon(Icons.home),
        ],
      ),
    );
  }

  imagenMedico() {
    final card = Container(
      //clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          if (widget.imagenCategoria == 'null')
            FadeInImage(
              image: NetworkImage(urlApi + 'images/default.png'),
              placeholder: AssetImage('assets/jar-loading.gif'),
              fadeInDuration: Duration(milliseconds: 200),
              //height: 230.0,
              fit: BoxFit.cover,
            )
          else
            FadeInImage(
              image: NetworkImage(urlApi + 'images/' + widget.imagenCategoria),
              placeholder: AssetImage('assets/jar-loading.gif'),
              fadeInDuration: Duration(milliseconds: 200),
              //height: 230.0,
              fit: BoxFit.cover,
            ),
          Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Text(widget.nombreMedico,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                          fontSize: 12, color: Colors.blue)),
                  if (modelo.descripcion_espe == null ||
                      modelo.descripcion_espe.toString().isEmpty)
                    Visibility(
                        visible: false,
                        child: Text(modelo.descripcion_espe.toString()))
                  else
                    Text(modelo.descripcion_espe.toString(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                            fontSize: 12, color: Colors.blue)),
                  if (modelo.datos_extra == null ||
                      modelo.datos_extra.toString().isEmpty)
                    Visibility(
                        visible: false,
                        child: Text(modelo.datos_extra.toString()))
                  else
                    Text(modelo.datos_extra.toString(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                            fontSize: 12, color: Colors.blue)),
                ],
              )),
        ],
      ),
    );
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            spreadRadius: 2.0,
            offset: Offset(2.0, -10.0),
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
    return Column(
      children: [
        Card(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (resultados.isEmpty)
                        Visibility(visible: false, child: Text("Cedulas:"))
                      else
                        Center(
                            child: Text("Cedulas:",
                                style: GoogleFonts.montserrat(
                                    fontSize: 13, color: Colors.blue))),
                      if (resultados.isEmpty)
                        Visibility(visible: false, child: Text(resultados))
                      else
                        Center(
                            child: Text(resultados,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(fontSize: 13))),
                      if (resServicios.isEmpty)
                        Visibility(visible: false, child: Text("Servicios:"))
                      else
                        Center(
                            child: Text("Servicios:",
                                style: GoogleFonts.montserrat(
                                    fontSize: 13, color: Colors.blue))),
                      if (resServicios.isEmpty)
                        Visibility(visible: false, child: Text(resServicios))
                      else
                        Center(
                            child: Text(resServicios,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(fontSize: 13))),
                      if (resFp.isEmpty)
                        Visibility(
                            visible: false, child: Text("Formas de pago :"))
                      else
                        Center(
                            child: Text("Formas de pago:",
                                style: GoogleFonts.montserrat(
                                    fontSize: 13, color: Colors.blue))),
                      if (resFp.isEmpty)
                        Visibility(visible: false, child: Text(resFp))
                      else
                        Center(
                            child: Text(resFp,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(fontSize: 13))),
                      if (modelo.horario == null ||
                          modelo.horario.toString().isEmpty)
                        Visibility(visible: false, child: Text("Horarios:"))
                      else
                        Center(
                            child: Text("Horarios:",
                                style: GoogleFonts.montserrat(
                                    fontSize: 13, color: Colors.blue))),
                      if (modelo.horario == null ||
                          modelo.horario.toString().isEmpty)
                        Visibility(
                            visible: false,
                            child: Text(modelo.horario.toString()))
                      else
                        Center(
                            child: Text(modelo.horario.toString(),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(fontSize: 13))),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  direccion() {
    return GestureDetector(
      onTap: () {
        setState(() {
          googleMaps(modeloDireccion.direccion.toString());
        });
      },
      child: Column(
        children: [
          Card(
            child: Row(
              children: [
                Container(
                  width: 30.0,
                  height: 40.0,
                  child: Image.asset('assets/mapa.png'),
                ),
                SizedBox(
                  width: 2.5,
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(modeloDireccion.direccion.toString(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  telefono1() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _makePhoneCall(modelo.telefono1.toString());
          //launch()
        });
      },
      child: Column(
        children: [
          Card(
            child: Row(
              children: [
                Container(
                  width: 30.0,
                  height: 40.0,
                  child: Image.asset('assets/telefono.png'),
                ),
                SizedBox(
                  width: 2.5,
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                            child: Text('Telefono (Agendar Cita)',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(fontSize: 13))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  telefono2() {
    return GestureDetector(
      onTap: () {
        _makePhoneCall(modelo.telefono2.toString());
      },
      child: Column(
        children: [
          Card(
            child: Row(
              children: [
                Container(
                  width: 30.0,
                  height: 40.0,
                  child: Image.asset('assets/telefono.png'),
                ),
                SizedBox(
                  width: 2.5,
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                            child: Text('Telefono',
                                style: GoogleFonts.montserrat(fontSize: 13))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  telEmergencia() {
    return GestureDetector(
      onTap: () {
        _makePhoneCall(modelo.telefono_emergencias.toString());
      },
      child: Column(
        children: [
          Card(
            child: Row(
              children: [
                Container(
                  width: 30.0,
                  height: 40.0,
                  child: Image.asset('assets/llamada-de-emergencia.png'),
                ),
                SizedBox(
                  width: 2.5,
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                            child: Text('Telefono Emergencia',
                                style: GoogleFonts.montserrat(fontSize: 13))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  whatSapp() {
    return GestureDetector(
      onTap: () {
        setState(() {
          launchWhatsApp("+52" + modelo.whatsapp.toString());
        });
      },
      child: Column(
        children: [
          Card(
            child: Row(
              children: [
                Container(
                  width: 30.0,
                  height: 40.0,
                  child: Image.asset('assets/whatsapp.png'),
                ),
                SizedBox(
                  width: 2.5,
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                            child: Text('Whatsapp',
                                style: GoogleFonts.montserrat(fontSize: 13))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  facebook() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _facebook(modelo.facebook.toString());
        });
      },
      child: Column(
        children: [
          Card(
            child: Row(
              children: [
                Container(
                  width: 30.0,
                  height: 40.0,
                  child: Image.asset('assets/facebook.png'),
                ),
                SizedBox(
                  width: 2.5,
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                            child: Text('Facebook',
                                style: GoogleFonts.montserrat(fontSize: 13))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  instragam() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _instagram(modelo.instagram.toString());
        });
      },
      child: Column(
        children: [
          Card(
            child: Row(
              children: [
                Container(
                  width: 30.0,
                  height: 40.0,
                  child: Image.asset('assets/instagram.png'),
                ),
                SizedBox(
                  width: 2.5,
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                            child: Text('Instagram',
                                style: GoogleFonts.montserrat(fontSize: 13))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  twitter() {
    return Column(
      children: [
        Card(
          child: Row(
            children: [
              Container(
                width: 30.0,
                height: 40.0,
                child: Image.asset('assets/twitter.png'),
              ),
              SizedBox(
                width: 2.5,
              ),
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                          child: Text('Twitter',
                              style: GoogleFonts.montserrat(fontSize: 13))),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  paginaWeb() {
    return GestureDetector(
      onTap: () {
        setState(() {
          ulrWeb(modelo.pagina_web.toString());
          print(modelo.pagina_web.toString());
        });
      },
      child: Column(
        children: [
          Card(
            child: Row(
              children: [
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                            child: Text('Pagina Web',
                                style: GoogleFonts.montserrat(fontSize: 13))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  email() {
    return GestureDetector(
      onTap: () {
        setState(() {
          correo(modelo.e_mail.toString());
        });
      },
      child: Column(
        children: [
          Card(
            child: Row(
              children: [
                Container(
                  width: 30.0,
                  height: 40.0,
                  child: Image.asset('assets/email.png'),
                ),
                SizedBox(
                  width: 2.5,
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                            child: Text('E-mail',
                                style: GoogleFonts.montserrat(fontSize: 13))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
      await launch(url(),
          forceSafariVC: true, forceWebView: true, enableJavaScript: true);
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

  carrucelPersonal() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54, width: 2),
      ),
      width: double.infinity,
      height: 200.0,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return new Image.network(
            listImagenes[index],
            fit: BoxFit.fill,
          );
        },
        itemCount: listImagenes.length,
        pagination: new SwiperPagination(),
        control: new SwiperControl(),
        autoplay: true,
      ),
    );
  }

  Widget createDialog(BuildContext context) => CupertinoAlertDialog(
        title: Text('IR AL MENÚ PRINCIPAL'),
        actions: [
          CupertinoDialogAction(
            child: Text("OK"),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                  ModalRoute.withName("/HomePage"));
            },
          ),
          CupertinoDialogAction(
            child: Text("CANCEL"),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
        ],
      );
}
