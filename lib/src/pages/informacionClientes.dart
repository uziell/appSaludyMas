import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
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
  String imagenCategoria;
  InformacionMedico(this.nombreMedico,this.idCliente,this.imagenCategoria,{Key? key}) : super(key: key);

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
       if(clieEs.elementAt(i).escuela == null)
         listaCedulas.add(clieEs.elementAt(i).tipoCedula.toString()+"//"+clieEs.elementAt(i).cedula.toString()+"\n");
       else listaCedulas.add(clieEs.elementAt(i).tipoCedula.toString()+"//"+clieEs.elementAt(i).cedula.toString()+"//"+clieEs.elementAt(i).escuela.toString()+"\n");
       for(int j=0; j<listaCedulas.length;j++){
          resultados += listaCedulas.elementAt(j);
          listaCedulas.clear();
       }
     }
   }
   consultarServicios(String idCliente) async {
     final  urlApi = Uri.parse("https://www.salumas.com/Salud_Y_Mas_Api/consulta_cliente_servicios?idCliente="+idCliente);
     var response = await http.get(urlApi);
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
            if(modeloDireccion.direccion == null|| modeloDireccion.direccion.toString().isEmpty)Visibility(visible:false,child:direccion())else direccion(),
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
            image: NetworkImage(urlApi+'images/'+widget.imagenCategoria),
            placeholder: AssetImage('assets/jar-loading.gif'),
            fadeInDuration: Duration(milliseconds: 200),
            //height: 230.0,
            fit: BoxFit.cover,
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text(widget.nombreMedico, style: GoogleFonts.montserrat(fontSize: 12,color: Colors.blue)),
                if(modelo.descripcion_espe == null || modelo.descripcion_espe.toString().isEmpty)Visibility(visible:false,child:Text(modelo.descripcion_espe.toString()))else Text(modelo.descripcion_espe.toString(),style: GoogleFonts.montserrat(fontSize: 12,color: Colors.blue)),
                if(modelo.datos_extra == null || modelo.datos_extra.toString().isEmpty)Visibility(visible:false,child:Text(modelo.datos_extra.toString()))else Text(modelo.datos_extra.toString(),style: GoogleFonts.montserrat(fontSize: 12,color: Colors.blue)),
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
                      if(resultados.isEmpty) Visibility(visible:false,child:Text("Cedulas:"))else Center(child: Text("Cedulas:",style: GoogleFonts.montserrat(fontSize: 13,color: Colors.blue))),
                      if(resultados.isEmpty) Visibility(visible:false,child:Text(resultados))else Center(child: Text(resultados, style: GoogleFonts.montserrat(fontSize: 13))),

                      if(resServicios.isEmpty)Visibility(visible:false,child: Text("Servicios:"))else Center(child: Text("Servicios:",style: GoogleFonts.montserrat(fontSize: 13,color: Colors.blue))),
                      if(resServicios.isEmpty)Visibility(visible:false,child: Text(resServicios))else Center(child: Text(resServicios,style: GoogleFonts.montserrat(fontSize: 13))),

                      if(resFp.isEmpty)Visibility(visible: false,child:Text("Formas de pago :")) else Center(child: Text("Formas de pago:",style: GoogleFonts.montserrat(fontSize: 13,color: Colors.blue))),
                      if(resFp.isEmpty)Visibility(visible: false,child:Text(resFp)) else Center(child:Text(resFp,style: GoogleFonts.montserrat(fontSize: 13))),

                      if(modelo.horario == null || modelo.horario.toString().isEmpty)Visibility(visible:false,child:Text("Horarios:" ))else Center(child: Text("Horarios:" ,style: GoogleFonts.montserrat(fontSize: 13,color: Colors.blue))),
                      if(modelo.horario == null || modelo.horario.toString().isEmpty)Visibility(visible:false,child:Text(modelo.horario.toString()))else Center(child: Text(modelo.horario.toString(),style: GoogleFonts.montserrat(fontSize: 13))),
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
          googleMaps('google.navigation:q='+modeloDireccion.direccion.toString());
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
                        Text('Whatsapp'),
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
                        Text('Facebook'),
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
                        Text('Instagram'),
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
                      Text('Twitter'),
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
                        Text('Pagina Web'),
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
                        Text('E-mail'),
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
   Future<void> googleMaps(String url) async {
     if (!await canLaunch(url)) {
       await launch(url);
     } else {
       throw 'Could not launch $url';
     }
   }

   Future<void>_makePhoneCall(String url)async{
     if(!await canLaunch(url)){
       await launch(url);
     }else{
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

  carrucelPersonal() {

  }




}