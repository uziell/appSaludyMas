import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:salud_y_mas/src/models/modeloEspecialidades.dart';
import 'package:salud_y_mas/src/pages/mostrarMedicosDeEspecialidad.dart';
// ignore: must_be_immutable

class EspecialidadCategoria extends StatefulWidget {
  String nombreEspecialidad ='';
  String  idCategoria;
  String nombreEstado='';
  String nombreCiudad='';
  String imagenGeneral='';
  EspecialidadCategoria(this.nombreEspecialidad,this.idCategoria,this.nombreEstado,this.nombreCiudad,this.imagenGeneral,{Key? key}) : super(key: key);
  
  @override
  _EspecialidadCategoriaState createState() => _EspecialidadCategoriaState();
}

class _EspecialidadCategoriaState extends State<EspecialidadCategoria> {
  
  String urlApi = 'https://www.salumas.com/Salud_Y_Mas_Api/';
  List<ModeloEspecialidad> datosEspecialidad = [];

  @override
  void initState() {
    super.initState();

    if(widget.nombreEspecialidad == "ESPECIALIDADES" || widget.nombreEspecialidad == "ODONTOLOGÍA" || widget.nombreEspecialidad == "ESPECIALIDADES PEDIATRICAS") {
      consultarEspecialidades(widget.nombreEstado,widget.nombreCiudad,widget.idCategoria).then((value){
      setState(() {   
      });
    });
    }else{

    }
    

  }

   Future consultarEspecialidades(String nombreEstado, String nombreCiudad, String idCategoria) async {
    print('Esto tiene el nombre: '+nombreEstado+"ciudad: "+ nombreCiudad+ "idCate: "+idCategoria);
    datosEspecialidad.clear();
    final  urlApi = Uri.parse("https://www.salumas.com/Salud_Y_Mas_Api/consultas_especialidad?nameEdo="+nombreEstado+"&nameCd="+nombreCiudad+"&idCate="+idCategoria);
    var response = await http.get(urlApi);
    var jsonBody =   json.decode(response.body);
    print(urlApi);
    for (var data in jsonBody) {
      datosEspecialidad.add(new ModeloEspecialidad(data['idespecialidad'], data['nombre'],data['imagen'].toString(),data['imagenGeneral'].toString())); 
    } 
    datosEspecialidad.forEach((someData)=>print('Name : ${someData.imagen}'));
     
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nombreEspecialidad),
      ),
      body: Container(
        child: _llamarCategorias(),
      ),
    );
  }

  

  _llamarCategorias() {
    var size = MediaQuery.of(context).size;
    final double itemHeight = size.height * 15.8;
    final double itemWidth = size.width * 120;
    return  Container(
          child: new GridView.count(
              crossAxisCount: 2,
              childAspectRatio: (itemWidth / itemHeight),
              controller: new ScrollController(keepScrollOffset: false),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: datosEspecialidad.map((espe) {
                 //print(urlApi+'images/'+espe.imagen);
                 return new Container(
                  margin: new EdgeInsets.all(1.0),
                  child: Column(
                   children: [
                     GestureDetector(
                       onTap: (){
                         Navigator.of(context).push(MaterialPageRoute<Null>(
                           builder:  (BuildContext context){

                            String nameEspecialidad = espe.nombre;
                            String nameEdo = widget.nombreEstado;
                            String nameCd = widget.nombreCiudad;
                            String idCategoria = widget.idCategoria;
                            String idEspeciliad = espe.idespecialidad;
                             return MedicosEspecialidad(nameEspecialidad,nameEdo,nameCd,idCategoria,idEspeciliad);
                           }
                         ));
                       },
                       child: Card(
                         child: Row(
                           children: [
                            Container(
                            width: 30.0,
                            height: 40.0,
                            child: Image.network(urlApi+'images/'+espe.imagen.toString()),
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
                              Text(espe.nombre.toString(), style: TextStyle(
                                fontStyle: FontStyle.normal, fontWeight: FontWeight.bold
                                ,fontSize: 9,
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

