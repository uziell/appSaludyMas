import 'dart:async';
import 'package:badges/badges.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:salud_y_mas/notification_providers/push_notification_providers.dart';
import 'package:salud_y_mas/preferences/preferences.dart';
import 'package:salud_y_mas/src/pages/login_page.dart';
import 'dart:convert';
import 'package:salud_y_mas/src/pages/pantalla_categorias_ciudad.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:salud_y_mas/src/widgtes/alerts.dart';
import 'package:salud_y_mas/src/widgtes/appBarNotificaciones.dart';
import 'package:salud_y_mas/src/widgtes/menu.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String urlApi = 'https://www.salumas.com/Salud_Y_Mas_Api/';

  //VARIBLE PARA ALMACENAR LOS DATOS DEL JSON DE CONSULTAR ESTADOS
  List<dynamic> nombreEdo = [];
  String vistaCiudad = "Seleccione una ciudad";
  bool _cargando = false;
  int _paginaActual = 0;
  AppPreferences prefs = AppPreferences();

  @override
  initState() {
    super.initState();
    consultarAPIEstados().then((resultado) {
      setState(() {
        this._cargando = true;
      });
    });
    main();
    PushNotificationProvider.messageStream.listen((message) {
      print("entra notificaciónes inicio");
      //si mando a llamar aca el metodo de cerrar secion si lo hace
      //pero si le paso mis argumentos no lo acepta
      // Alerts().dialogDinamico(context, 'Que onda');
    });
  }

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    // await PushNotificationProvider.initialAPP();
  }

//METODO PARA CONSULTAR LOS ESTADOS LOS CUAL CONTIENE NOMBRE, IMAGEN Y UN COLOR ASIGANDO POR EL ADMINISTRADOR
// GUARDA LOS DATOS EN LA VARIBALE nombreEdo
  Future<List<dynamic>> consultarAPIEstados() async {
    final url = Uri.parse(urlApi + 'consultas_edo.php');
    var response = await http.get(url);
    nombreEdo = json.decode(response.body);
    return nombreEdo;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondoPrincipal.jpg'),
            fit: BoxFit.cover,
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.9), BlendMode.dstATop),
          ),
        ),
      ),
      Scaffold(
        drawer: MenuPage(),
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: AppBarNotificaciones(titulo: 'Salud y más')),
        backgroundColor: Colors.transparent,
        body: _cargando
            ? Container(
                child: SingleChildScrollView(
                child: Column(children: [
                  Padding(
                      padding: EdgeInsets.only(left: 38, right: 38, top: 12)),
                  Card(
                    margin: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                    color: Colors.transparent,
                    elevation: 0,
                    child: Row(
                      children: [
                        Container(
                          color: Colors.transparent,
                          width: 120.0,
                          height: 80.0,
                          child: Image.asset(
                              'assets/ubicacionPantallaPrincipal.png'),
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
                                Text('UBICACIÓN',
                                    style: GoogleFonts.montserrat(
                                        fontSize: 24,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  cardCiudad(),
                  //listaEstados(),
                ]),
              ))
            : Center(child: CircularProgressIndicator()),
        // bottomNavigationBar: CurvedNavigationBar(
        //   height: 40,
        //   onTap: (index) {
        //     setState(() {
        //       _paginaActual = index;
        //       if (_paginaActual == 0) {
        //         showDialog(context: context, builder: Alerts().dialogCerrarSesion);
        //       }
        //     });
        //   },
        //   //currentIndex: _paginaActual,
        //   items: [
        //     Icon(Icons.close),
        //   ],
        // ),
      ),
    ]);
  }

  //METODO PARA PINTAR LAS IMAGENES DENTRO DE UN GRIDVIEW
  Widget cardCiudad() {
    var size = MediaQuery.of(context).size;
    final double itemHeight = size.height * 38;
    final double itemWidth = size.width * 80;
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.all(30),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      scrollDirection: Axis.vertical,
      childAspectRatio: (itemWidth / itemHeight),
      controller: new ScrollController(keepScrollOffset: false),
      shrinkWrap: true,
      children: nombreEdo
          .map((e) => InkWell(
                onTap: () {
                  //EN este navigator pasamos a la siguiente pantalla de las categorias por ciudad
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          CategoriasCiudad(e['nombre'], e['colorEdo'])));
                },
                child: Card(
                    margin: EdgeInsets.all(2),
                    color: Colors.transparent,
                    elevation: 0,
                    child: Container(
                        height: size.height / nombreEdo.length - 15,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(26),
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(26.0),
                            child: FadeInImage(
                              fit: BoxFit.cover,
                              placeholder: AssetImage("assets/jar-loading.gif"),
                              image: NetworkImage(
                                  urlApi + 'images/' + e['imagenEstado']),
                            )))),
              ))
          .toList(),
    );
  }
}
