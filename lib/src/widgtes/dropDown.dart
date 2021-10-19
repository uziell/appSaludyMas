
import 'package:flutter/material.dart';
import 'package:salud_y_mas/src/models/modelo_categoria.dart';
import 'dart:convert';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:salud_y_mas/src/models/modelo_categoria.dart';
import 'package:salud_y_mas/src/pages/pantalla_especialidades_categoria.dart';
import 'package:salud_y_mas/src/widgtes/backgraund.dart';
import 'package:salud_y_mas/src/widgtes/dropDown.dart';

class DropButton extends StatefulWidget {
  const DropButton({Key? key}) : super(key: key);

  @override
  _DropButtonState createState() => _DropButtonState();
}

class _DropButtonState extends State<DropButton> {

  List<String> estadosConsulta = [], ciudadesConsulta = [], imagenes =[];
  List<MyModel> myData = [];
  String urlApi = 'https://www.salumas.com/Salud_Y_Mas_Api/';
  String vista = 'Seleccione';
  String vistaCiudad = "Seleccione una ciudad";
  List<String> listImagenes = [];

  Future consultarImagenes() async {
    final url = Uri.parse(urlApi + 'consultas_carrusel.php');
    var response = await http.get(url);
    var respuestaImagen = jsonDecode(response.body);
    for (var valor in respuestaImagen) {
      imagenes.add((valor['imagen']).toString());
    }
    // print('Esto tiene imagenes: '+ imagenes.toString());
  }

  llenarCarrucel(List<String> lista) {
    print('Esto tiene lista:' + lista.toString());
    for (var i = 0; i < lista.length; i++) {
      listImagenes.add(urlApi + '/images/' + lista[i]);
    }
  }


  Future consultarAPIEstados() async {
    final url = Uri.parse(urlApi+'consultas_edo.php');
    var response = await http.get(url);
    var respuesta = jsonDecode(response.body);

    for (var valor in respuesta) {
      estadosConsulta.add((valor['nombre']));
    }
  }

  Future consultarAPICiudades(String estadoCiu) async {
    ciudadesConsulta.clear();
    // _ciudadActual = '';
    final url = Uri.parse(urlApi+'consultas_cd?nameEdo='+estadoCiu);
    var response = await http.get(url);
    var respuesta = jsonDecode(response.body);

    //print(respuesta);
    for (var valor in respuesta) {
      ciudadesConsulta.add((valor['nombre']));
    }
    // print('item: '+ciudadesConsulta.toString());
    if(ciudadesConsulta.isEmpty){
      return;
    }

  }

  @override
  initState() {
    super.initState();
    consultarImagenes().then((value) {
      llenarCarrucel(imagenes);
    });
    consultarAPIEstados().then((resultado) {
      setState(() {
      });
    });
    //
  }
  Future consultarCategorias(String actualStado, String actualCiudad)async{
    print('Esto tiene '+ actualStado +'y ciudad '+ actualCiudad);
    myData.clear();
    final  urlApi = Uri.parse("https://www.salumas.com/Salud_Y_Mas_Api/consultas_categorias?nameEdo="+actualStado+"&nameCd="+actualCiudad);
    var response = await http.get(urlApi);
    var jsonBody =   json.decode(response.body);
    print(urlApi);
    for (var data in jsonBody) {
      myData.add(new MyModel(data['idcategoria'],data['nombrecategoria'],data['descripccion'],data['imagen'].toString(),data['imagen_general'].toString()));
    }
    myData.forEach((someData)=>print('Name : ${someData.nombrecategoria}'));

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(padding: EdgeInsetsDirectional.all(5)),
        consultarDrop(),
        Divider(),
        llenarCarrucelPrueba(),
        Divider(),
        _llamarCategorias(),
      ],
    );
  }

  consultarDrop() {
    return  Row(
      children: [
        Container(
          width: 150,
          padding: EdgeInsets.symmetric(horizontal:12, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            // border: Border.all(color: Colors.black,width: 2),
            color: const Color(0xffe0f2f1),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              isExpanded: true,
              iconSize: 20,
              icon: Icon(Icons.arrow_drop_down, color: Colors.black),
              items: estadosConsulta.map((String estadoC) {
                return DropdownMenuItem(
                  value: estadoC,
                  child: Text(estadoC,
                  ),
                );
              }).toList(),
              onChanged: (String? seleccion){
                setState(() {
                  vista = seleccion.toString();
                  consultarAPICiudades(vista).then((value){
                    setState(() {
                      vistaCiudad = ciudadesConsulta[0].toString();

                      consultarCategorias(vista,vistaCiudad).then((value){
                        setState(() {

                        });
                      });
                    });
                  });
                });
              },
              hint: Text(vista, style: TextStyle(color:const Color(0xff1a237e), fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Container(
          width: 250,
          padding: EdgeInsets.symmetric(horizontal:12, vertical: 4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              //border: Border.all(color: Colors.black,width: 2)
              color:const Color(0xffe0f2f1),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              items: ciudadesConsulta.map((String ciudadC) {
                return DropdownMenuItem(
                  value: ciudadC,
                  child: Text(ciudadC),
                );
              }).toList(),
              iconSize: 20,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: Colors.blue),
              onChanged: (_ciudadActual){
                setState(() {
                  vistaCiudad = _ciudadActual.toString();
                  //consultarCategorias(vista,vistaCiudad);
                  consultarCategorias(vista,vistaCiudad).then((value){
                    setState(() {

                    });
                  });
                });

              },
              hint: Text(vistaCiudad,style: TextStyle(color:const Color(0xff1a237e),fontWeight: FontWeight.bold, fontSize: 16),),
            ),
          ),
        ),
      ],
    );
  }

  llenarCarrucelPrueba() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xff5DC1B9),width: 2),
      ),
      width: double.infinity,
      height: 250.0,
      child: Swiper(
        itemBuilder: (BuildContext context,int index){
          return new Image.network(listImagenes[index],fit: BoxFit.fill,);
        },
        itemCount: listImagenes.length,
        pagination: new SwiperPagination(),
        control: new SwiperControl(),
        autoplay: true,
      ),
    );

  }

  _llamarCategorias() {
    var size = MediaQuery.of(context).size;
    final double itemHeight = size.height * 15.8;
    final double itemWidth = size.width * 120;
    if (vista == 'Seleccione') return Card(
        child: Image.asset('assets/sinDatos.jpg')
    );
    else return Container(
        child: new GridView.count(
          crossAxisCount: 2,
          childAspectRatio: (itemWidth / itemHeight),
          controller: new ScrollController(keepScrollOffset: false),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: myData.map((value) {
            return new Container(
              /*decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff00838e),width: 2),
              ),*/
              margin: new EdgeInsets.all(1.0), child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    /*Navigator.of(context).push(MaterialPageRoute<Null>(
                        builder: (BuildContext context) {
                          String nombreCategoria = value.nombrecategoria.toString();
                          String idcategoria = value.idcategoria;
                          String nombreEdo = vista;
                          String nombreCd = vistaCiudad;
                          String imagenGeneral = value.imagenGeneral.toString();
                          return EspecialidadCategoria(nombreCategoria, idcategoria, nombreEdo, nombreCd, imagenGeneral);
                        }
                    )
                    );*/
                  },
                  child: Card(
                    color:const Color(0xff80cbc4),
                    child: Row(
                      children: [
                        Container(
                          width: 30.0,
                          height: 40.0,
                          child: Image.network(urlApi + 'images/' + value.imagen.toString()),
                        ),
                        SizedBox(
                          width: 1.5,
                        ),
                        Expanded(
                          child: Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if(value.nombrecategoria == "ANÁLISIS CLINICOS")Text("LABORATORIO DE "+value.nombrecategoria.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontStyle: FontStyle.normal, fontWeight: FontWeight.bold,fontSize: 9,),
                                ) else if(value.nombrecategoria == "ULTRASONIDO Y RAYOS X")Text("RADIOLOGÍA", style: TextStyle(color: Colors.white,
                                    fontStyle: FontStyle.normal, fontWeight: FontWeight.bold, fontSize: 9))
                                else
                                  Text(value.nombrecategoria.toString(), style: TextStyle(color: Colors.white,fontStyle: FontStyle.normal, fontWeight: FontWeight.bold, fontSize: 9,
                                  ),),
                                Text(value.descripccion.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 7,
                                      fontStyle: FontStyle.normal
                                  ),),
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

