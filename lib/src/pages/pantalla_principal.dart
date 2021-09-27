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
  List<MyModel> myData = [];
  String urlApi = 'https://www.salumas.com/Salud_Y_Mas_Api/';
  List<String> listImagenes = [] ;
  String vista = 'Seleccione';
  String vistaCiudad = "Seleccione una ciudad";


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
       listImagenes.add(urlApi+'/images/'+lista[i]);
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
     print('item: '+ciudadesConsulta.toString());
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
       // _dropDownMenuEstados = contruirDropEstados();
       // _estadoActual = _dropDownMenuEstados[0].value.toString();
        
        
      });
    });
  }
  
  Future consultarCategorias(String actualStado, String actualCiudad)async{
    myData.clear();
    print('Esto tiene ciudadActual '+ actualCiudad);
    final  urlApi = Uri.parse("https://www.salumas.com/Salud_Y_Mas_Api/consultas_categorias?nameEdo="+actualStado+"&nameCd="+actualCiudad);
    print(urlApi);
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
        extendBodyBehindAppBar: true,
         appBar: AppBar(
          title: Text('Salud y Mas'),

        ),
        body: Column(         
        children: [
        Padding(padding: EdgeInsetsDirectional.all(35)),
        llamarDropPrueba(),
         //este es el buen carrucelPrueba
         llenarCarrucelPrueba(),
        
        ],
        ),
            ),
        );
  }

  llamarDropPrueba(){
    return Row(
            children: [
                 Container(
                  width: 150,
                  padding: EdgeInsets.symmetric(horizontal:12, vertical: 4),
                   decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black,width: 2)
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
                           
                          });
                        });
                      });
                    },
                      hint: Text(vista, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
                    border: Border.all(color: Colors.black,width: 2)
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
                      icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                      onChanged: (_ciudadActual){
                        setState(() {
                          vistaCiudad = _ciudadActual.toString();
                           _llamarCategorias(vistaCiudad);
                          });
                      },
                      hint: Text(vistaCiudad,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                      ),
                  ),
                ),
              
            ],
          );
    
  }
llenarCarrucelPrueba() {
return Container(
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
  _llamarCategorias(String nombreCiudad) {
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