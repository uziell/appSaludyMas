import 'package:flutter/material.dart';
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
  List<dynamic> nombreEdo = [];

  @override
  initState() {
    super.initState();
    consultarAPIEstados().then((resultado) {
      setState(() {});
    });
  }
  Future<List<dynamic>> consultarAPIEstados() async {
    final url = Uri.parse(urlApi+'consultas_edo.php');
    var response = await http.get(url);
    nombreEdo = json.decode(response.body);
    return nombreEdo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: new Center(child: new Text('SALUD Y MÁS', textAlign: TextAlign.center)),
      ),
      body: CardCiudad(),
    );
  }

  Widget CardCiudad() {
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
        children: nombreEdo.map((e) => InkWell(
          onTap: (){
            Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => CategoriasCiudad(e['nombre'], e['colorEdo'])
                )
            );
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
                            //color: const Color(0xff00838f),
                            border: Border.all(color:  Color(int.parse(e['colorEdo'])),width: 2),
                            borderRadius: BorderRadius.circular(26),
                            image: DecorationImage(
                                image: NetworkImage(urlApi+'images/'+e['imagenEstado']),
                                fit:  BoxFit.fill
                            )
                        ),
                      )


                      //Text(e['nombre'], style: TextStyle(color: Colors.blue),)
                    ],
            ),
          ),
        )).toList(),
    );
  }




}






