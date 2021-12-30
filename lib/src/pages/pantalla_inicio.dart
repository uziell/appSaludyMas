import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:salud_y_mas/src/pages/pantalla_categorias_ciudad.dart';

void main() => runApp(HomePage());

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String urlApi = 'https://www.salumas.com/Salud_Y_Mas_Api/';

  //VARIBLE PARA ALMACENAR LOS DATOS DEL JSON DE CONSULTAR ESTADOS
  List<dynamic> nombreEdo = [];
  String vistaCiudad = "Seleccione una ciudad";
  bool _cargando = false;

  @override
  initState() {
    super.initState();
    consultarAPIEstados().then((resultado) {
      setState(() {
        this._cargando = true;
      });
    });
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
            colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.9), BlendMode.dstATop),
          ),
        ),
      ),
      Scaffold(
          backgroundColor: Colors.transparent,
          body: _cargando
              ? Container(
                  child: SingleChildScrollView(
                  child: Column(children: [
                    Padding(padding: EdgeInsetsDirectional.all(38)),
                    Card(
                      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 4),
                      color: Colors.transparent,
                      elevation: 0,
                      child: Row(
                        children: [
                          Container(
                            color: Colors.transparent,
                            width: 120.0,
                            height: 80.0,
                            child: Image.asset('assets/ubicacionPantallaPrincipal.png'),
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
                                  Text('UBICACIÓN', style: GoogleFonts.montserrat(fontSize: 24, color: Colors.blue, fontWeight: FontWeight.bold)),
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
              : Center(child: CircularProgressIndicator()))
    ]);
  }

  //METODO PARA PINTAR LAS IMAGENES DENTRO DE UN GRIDVIEW
  Widget cardCiudad() {
    var size = MediaQuery.of(context).size;
    final double itemHeight = size.height * 38;
    final double itemWidth = size.width * 80;
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.all(15),
      scrollDirection: Axis.vertical,
      childAspectRatio: (itemWidth / itemHeight),
      controller: new ScrollController(keepScrollOffset: false),
      shrinkWrap: true,
      children: nombreEdo
          .map((e) => InkWell(
                onTap: () {
                  //EN este navigator pasamos a la siguiente pantalla de las categorias por ciudad
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => CategoriasCiudad(e['nombre'], e['colorEdo'])));
                },
                child: Card(
                  margin: EdgeInsets.all(2),
                  color: Colors.transparent,
                  elevation: 0,
                  child: Column(
                    children: [
                      Container(
                        height: size.height / nombreEdo.length,
                        width: 140,
                        decoration: BoxDecoration(
                            boxShadow: [BoxShadow(blurRadius: 0.1, spreadRadius: 0.1, offset: Offset(6, 6), color: Colors.grey.shade400)],
                            //color: const Color(0xff00838f),
                            border: Border.all(color: Colors.grey.shade300, width: 2),
                            borderRadius: BorderRadius.circular(26),
                            image: DecorationImage(image: NetworkImage(urlApi + 'images/' + e['imagenEstado']), fit: BoxFit.fill)),
                      )
                      //Text(e['nombre'], style: TextStyle(color: Colors.blue),)
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }
}
