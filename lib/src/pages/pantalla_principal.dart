import 'dart:convert';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:salud_y_mas/src/models/modelo_categoria.dart';


class PantallaPrincipal extends StatefulWidget {
  @override
  _PantallaPrincipalState createState() => _PantallaPrincipalState();
}
class _PantallaPrincipalState extends State<PantallaPrincipal> {

  List<String> estadosConsulta = [], ciudadesConsulta = [], imagenes =[];
  String _estadoActual = '', _ciudadActual = "";
  List<DropdownMenuItem<String>> _dropDownMenuEstados = [], _dropDownMenuCiudades = [];  
  List<MyModel> myData = [];
  String urlApi = 'https://www.salumas.com/Salud_Y_Mas_Api/';
  List<dynamic> listImagenes = [] ;



  Future consultarImagenes() async {
    final url = Uri.parse(urlApi+'consultas_carrusel.php');
    var response = await http.get(url);
    var respuestaImagen = jsonDecode(response.body);
    
    for (var valor in respuestaImagen) {
      imagenes.add((valor['imagen']).toString());
    }
     print('Esto tiene imagenes: '+ imagenes.toString());
  }

  
  llenarCarrucel(List<String> lista) {
    print('Esto tiene lista:'+lista.toString());
    for (var i = 0; i < lista.length; i++) {
       listImagenes.add(Uri.parse(urlApi+'/images/'+lista[i]));
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
  List<DropdownMenuItem<String>> contruirDropEstados() {
    List<DropdownMenuItem<String>> items = [];

    for (String estado in estadosConsulta) {
      items.add(
          DropdownMenuItem(
            child: Text(estado),
            value:  estado,
          )
      );

      print('Esto tiene estados: '+ estado);
      print('Este es un estado nuevo'+estado);
    }
    return items;
  }

  Future consultarAPICiudades(String estadoCiu) async {
    _dropDownMenuCiudades.clear();
    ciudadesConsulta.clear();
    _ciudadActual = '';
    final url = Uri.parse(urlApi+'consultas_cd?nameEdo='+estadoCiu);
    var response = await http.get(url);
    var respuesta = jsonDecode(response.body);

    //print(respuesta);
    for (var valor in respuesta) {
      ciudadesConsulta.add((valor['nombre']));
      
    }
    
    if(ciudadesConsulta.isEmpty){
      return;
    }
   List<DropdownMenuItem<String>> itemsC = [];
    for (String ciudades in ciudadesConsulta) {
      itemsC.add(
          DropdownMenuItem(
                value: ciudades,
                child: 
                    Text(ciudades,overflow: TextOverflow.ellipsis,
                    )
          ),         
      ); 
      _dropDownMenuCiudades = itemsC;
      print('Esto tiene ciudades: '+ ciudades);
     // print('item: '+itemsC.toString());
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
        _dropDownMenuEstados = contruirDropEstados();
        _estadoActual = _dropDownMenuEstados[0].value.toString();
        
      });
    });
  }
  
  Future consultarCategorias(String actualStado)async{
    myData.clear();
    final  urlApi = Uri.parse('https://www.salumas.com/Salud_Y_Mas_Api/consultas_categorias?nameEdo='+ actualStado);
    var response = await http.get(urlApi);

    if(response.statusCode == 200){
      String responseBody = response.body;
      var jsonBody =   json.decode(responseBody);
      for (var data in jsonBody) {
        myData.add(new MyModel(data['idcategoria'], data['nombrecategoria'],data['descripccion'],data['imagen'].toString(),data['imagen_general'].toString())); 
      }
      /*setState(() {
      });*/
      myData.forEach((someData)=>print('Name : ${someData.imagen}'));
    }else {
      print('Error lo siento');
    }

  }  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        
        appBar: AppBar(
          title: Text('Salud y Mas'),
        ),
        body: ListView(
                  children: [
                    llamardropDwownMenu(),
                    Divider(),
                    _llenarCarrucel(),
                  // llenarCarrucelPrueba(),
                    Divider(),
                    _llamarCategorias(),
                  ],
                ),
            ),
        );
  }

  llamardropDwownMenu(){
    return Column(
      children: [
        Row(
          children: [
            DropdownButton(
              hint: Text('Seleccion'),
              value: _estadoActual,
              items: _dropDownMenuEstados,
              onChanged: (String? seleccion){
                setState(() {
                  _estadoActual = seleccion!;
                  consultarAPICiudades(_estadoActual).then((value){
                    setState(() {
                      _ciudadActual = _dropDownMenuCiudades[0].value.toString();
                    });
                  });
                  consultarCategorias(_estadoActual).then((value) {
                   // llenarImagenesEspecialidad(imagenesCategoria);
                  });
                });
              },
            ),
            SizedBox(
              width: 5.0,
            ),
            DropdownButton(
              hint: Text('Seleccionar Ciudad'),
              value: _ciudadActual,
              items: _dropDownMenuCiudades,
              onChanged: (String? seleccion){
                setState(() {
                  _ciudadActual = seleccion!;
                });
              },
            )
          ],
        )
      ],
    );

  }

  _llenarCarrucel() {
    CarouselController buttonCarouselController = CarouselController();
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:<Widget> [
          CarouselSlider(
            items: listImagenes.map((imgS){
              return Builder(
                builder: (BuildContext context){
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(imgS.toString()),
                    ),
                  );
                },
              );
            }).toList(),
            carouselController: buttonCarouselController ,
            options: CarouselOptions(
              height: 250,
              aspectRatio: 16/9,
              viewportFraction: 0.8,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              //autoPlayAnimationDuration: Duration(microseconds: 3),
              autoPlayInterval: Duration(seconds: 3),
              autoPlayCurve: Curves.fastOutSlowIn,
              scrollDirection: Axis.horizontal,
              
            ),
            
          )
        ],
      ),
    );
  }

  _llamarCategorias() {
   final uriApss = Uri.parse(urlApi+'images/especialidades/default.png');
    var size = MediaQuery.of(context).size;
    final double itemHeight = size.height * 15.8;
    final double itemWidth = size.width * 120;
    return Container(
      child: new GridView.count(
          crossAxisCount: 2,
          childAspectRatio: (itemWidth / itemHeight),
          controller: new ScrollController(keepScrollOffset: false),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: myData.map((var value) {
             return new Container(
              color: Colors.blue,
              margin: new EdgeInsets.all(1.0),
              child: Column(
               children: [
                 Card(
                   child: Row(
                     children: [
                       Container(
                      width: 30.0,
                      height: 40.0,
                      child: 
                      Image.network(
                        uriApss.toString()
                      ),
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
                        Text(value.nombrecategoria, style: TextStyle(
                          fontStyle: FontStyle.normal, fontWeight: FontWeight.bold
                          ,fontSize: 9,

                        ),),
                        Text(value.descripccion, style: TextStyle(
                          fontSize: 7,fontStyle: FontStyle.normal
                        ),),  
                      ],
                    ),
                  ),
                ),
                     ],
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