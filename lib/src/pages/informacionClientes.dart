import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:salud_y_mas/src/models/modeloCedulas.dart';
import 'package:salud_y_mas/src/models/modeloDireccion.dart';
import 'package:salud_y_mas/src/models/modeloFormasPago.dart';
import 'package:salud_y_mas/src/models/modeloInformacionMedico.dart';
import 'package:salud_y_mas/src/models/modeloServicios.dart';
import 'package:url_launcher/url_launcher.dart';


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
   ModeloDireccion modeloDireccion =  new ModeloDireccion('','');
   List<ModeloCedulas> clieEs=[];
   List<String> listaCedulas = [];
   String resultados = "";
   List<ModeloServicios> modeloServ = [];
   List<String> listaServicios = [];
   String resServicios="";
   List<ModeloFormasPago> modeloFp = [];
   List<String> listaFomasPago = [];
   String resFp="";


  @override
  void initState()
  {
    super.initState();
    consultaInformacion(widget.idCliente).then((value) {
      setState(() {
      });
    });
    consultarCedulas(widget.idCliente).then((value) {
      setState(() {
      });
    });
    consultarServicios(widget.idCliente).then((value) {
      setState(() {
      });
    });
    conusultarFormasDePago(widget.idCliente).then((value) {
      setState(() {
      });
    });
    consultarDireccion(widget.idCliente).then((value) {
      setState(() {
      });
    });
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
     var jsonBody =   json.decode(response.body);
     for (var data in jsonBody) {
       clieEs.add(new ModeloCedulas(data['idcliente'],data['idcedula'],data['tipoCedula'],
           data['cedula'],data['escuela'],data['cliente_idcliente']));
     }
     for(int i=0; i<clieEs.length;i++){
       listaCedulas.add(clieEs.elementAt(i).tipoCedula.toString()+"//"+clieEs.elementAt(i).cedula.toString()+"//"+clieEs.elementAt(i).escuela.toString()+"\n");
       for(int j=0; j<listaCedulas.length;j++){
          resultados += listaCedulas.elementAt(j);
          listaCedulas.clear();
       }
     }
   }
   consultarServicios(String idCliente) async {
     final  urlApi = Uri.parse("https://www.salumas.com/Salud_Y_Mas_Api/consulta_cliente_servicios?idCliente="+idCliente);
     var response = await http.get(urlApi);
    /* List<dynamic> resp = json.decode(response.body);
     Map<String, dynamic> decodedResp = resp.first;
     servicios = ModeloServicios.fromJson(decodedResp);*/
     var jsonBody =   json.decode(response.body);
     for (var data in jsonBody) {
       modeloServ.add(new ModeloServicios(data['idcliente'],data['idservicios'],data['nombre'],
           data['descripcion'],data['costo'],data['cliente_idcliente']));
     }
     for(int i=0; i<modeloServ.length;i++){
       listaServicios.add(modeloServ.elementAt(i).nombre.toString()+",");
       for(int j=0; j<listaServicios.length;j++){
         resServicios += listaServicios.elementAt(j);
         listaServicios.clear();
       }
     }
   }
   conusultarFormasDePago(String idCliente) async {
     final  urlApi = Uri.parse("https://www.salumas.com/Salud_Y_Mas_Api/consulta_cliente_formaPago?idCliente="+idCliente);
     var response = await http.get(urlApi);
   /*  List<dynamic> resp = json.decode(response.body);
     Map<String, dynamic> decodedResp = resp.first;
     formasPago =  ModeloFormasPago.fromJson(decodedResp);
     print(formasPago.nombre);*/
     var jsonBody =   json.decode(response.body);
     for (var data in jsonBody) {
       modeloFp.add(new ModeloFormasPago(data['idcliente'],data['formasPago_idformasPago'],data['cliente_idcliente'],
           data['nombre']));
     }
     for(int i=0; i<modeloFp.length;i++){
       listaFomasPago.add(modeloFp.elementAt(i).nombre.toString()+"\n");
       for(int j=0; j<listaFomasPago.length;j++){
         resFp += listaFomasPago.elementAt(j);
         listaFomasPago.clear();
       }
     }

   }
   consultarDireccion(String idCliente)async {
     final  urlApi = Uri.parse("https://www.salumas.com/Salud_Y_Mas_Api/consulta_cliente_direcciones?idCliente="+idCliente);
     var response = await http.get(urlApi);
     List<dynamic> resp = json.decode(response.body);
     Map<String, dynamic> decodedResp = resp.first;
     modeloDireccion = ModeloDireccion.jsonFrom(decodedResp);
     print(modeloDireccion.direccion);
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nombreMedico),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            imagenMedico(),
            informacionPersonal(),
            if(modeloDireccion.direccion == null)Visibility(visible:false,child:direccion())else direccion(),
            if(modelo.telefono1 == null || modelo.telefono1.toString().isEmpty)Visibility(visible:false,child:telefono1()) else telefono1(),
            if(modelo.telefono2 == null || modelo.telefono2.toString().isEmpty)Visibility(visible:false,child:telefono2())else telefono2(),
            if(modelo.telefono_emergencias == null || modelo.telefono_emergencias.toString().isEmpty)Visibility(visible:false,child:telEmergencia())else telEmergencia(),
            if(modelo.whatsapp == null|| modelo.whatsapp.toString().isEmpty)Visibility(visible: false ,child:whatSapp())else whatSapp(),
            if(modelo.facebook == null || modelo.facebook.toString().isEmpty)Visibility(visible:false ,child:facebook()) else facebook(),
            if(modelo.instagram == null || modelo.instagram.toString().isEmpty)Visibility(visible:false,child:instragam())else instragam(),
            if(modelo.twitter == null || modelo.twitter.toString().isEmpty)Visibility(visible:false, child:twitter())else twitter(),
            if(modelo.pagina_web == null || modelo.pagina_web.toString().isEmpty)Visibility(visible:false,child:paginaWeb())else paginaWeb(),
            if(modelo.e_mail == null || modelo.e_mail.toString().isEmpty)Visibility(visible:false,child:email())else email(),
          ],
        ),
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
                    children:[
                      Text("Cedulas: \n"+resultados),
                      Text("Servicios:\n" + resServicios),
                      Text("Formas de pago : \n"+ resFp),
                      if(modelo.horario == null || modelo.horario.toString().isEmpty)Visibility(visible:false,child:Text("Horarios: \n" +modelo.horario.toString()))else Text("Horarios: \n" +modelo.horario.toString()),
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
      onTap: (){
        setState(() {
          googleMaps('comgooglemaps://?center='+modeloDireccion.direccion.toString());
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
                        children:[
                          Text(modeloDireccion.direccion.toString(), style: TextStyle(
                        fontStyle: FontStyle.normal, fontWeight: FontWeight.bold
                        ,fontSize: 9)
                          ),
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
      onTap: (){
        setState(() {
          _makePhoneCall('tel: '+modelo.telefono1.toString());
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
                  child:  Image.asset('assets/telefono.png'),
                ),
                SizedBox(
                  width: 2.5,
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        const Text('Telefono (Agendar Cita)'),

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
      onTap: (){
        _makePhoneCall('tel: '+modelo.telefono2.toString());
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
                      children:[
                        Text('Telefono'),
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
      onTap: (){
        _makePhoneCall('tel: '+modelo.telefono_emergencias.toString());
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
                      children:[
                        Text('Telefono Emergencia'),
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
      onTap: (){
        setState((){
           launchWhatsApp("+52"+modelo.whatsapp.toString());
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
                      children:[
                        Text(modelo.whatsapp.toString(), style: TextStyle(
                            fontStyle: FontStyle.normal, fontWeight: FontWeight.bold
                            ,fontSize: 9)
                        ),
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
      onTap: (){
        setState(() {
          _facebook('https://www.facebook.com/'+modelo.facebook.toString());
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
                      children:[
                        Text(modelo.facebook.toString(), style: TextStyle(
                            fontStyle: FontStyle.normal, fontWeight: FontWeight.bold
                            ,fontSize: 9)
                        ),
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
      onTap: (){
        setState(() {
          _instagram('https://www.instagram.com/'+modelo.instagram.toString());
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
                      children:[
                        Text(modelo.instagram.toString(), style: TextStyle(
                            fontStyle: FontStyle.normal, fontWeight: FontWeight.bold
                            ,fontSize: 9)
                        ),
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
                    children:[
                      Text(modelo.twitter.toString(), style: TextStyle(
                          fontStyle: FontStyle.normal, fontWeight: FontWeight.bold
                          ,fontSize: 9)
                      ),
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
      onTap: (){
        setState(() {
          ulrWeb('https://'+modelo.pagina_web.toString());
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
                      children:[
                        Text(modelo.pagina_web.toString(), style: TextStyle(
                            fontStyle: FontStyle.normal, fontWeight: FontWeight.bold
                            ,fontSize: 9)
                        ),
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
      onTap: (){
        setState(() {
          correo('mailto:'+modelo.e_mail.toString());
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
                      children:[
                        Text(modelo.e_mail.toString(), style: TextStyle(
                            fontStyle: FontStyle.normal, fontWeight: FontWeight.bold
                            ,fontSize: 9)
                        ),
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

   Future<void>_makePhoneCall(String url)async{
     if(!await canLaunch(url)){
       await launch(url);
     }else{
       throw 'Could not launch $url';
     }
   }
   Future<void> ulrWeb(String url) async {
     if (!await canLaunch(url)) {
       await launch(url);
     } else {
       throw 'Could not launch $url';
     }
   }

   Future<void> correo(String url) async {
     if (!await canLaunch(url)) {
       await launch(url);
     } else {
       throw 'Could not launch $url';
     }
   }
   Future<void> googleMaps(String url) async {
     if (!await canLaunch(url)) {
       await launch(url);
     } else {
       throw 'Could not launch $url';
     }
   }

   void launchWhatsApp(@required number) async {
     String url() {
       if (Platform.isAndroid) {
         return "whatsapp://send?phone=$number";
       } else {
         return "whatsapp://send?phone=$number";
       }
     }
     if (!await canLaunch(url())) {
       await launch(url());
     } else {
       throw 'Could not launch ${url()}';
     }
   }
   Future<void> _facebook(String url) async {
     if (!await canLaunch(url)) {
       await launch(url);
     } else {
       throw 'Could not launch $url';
     }
   }
   Future<void> _instagram(String url) async {
     if (!await canLaunch(url)) {
       await launch(url);
     } else {
       throw 'Could not launch $url';
     }
   }
}