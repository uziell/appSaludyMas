import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:salud_y_mas/src/models/modelo_medicos_especialidad.dart';

class MedicosEspecialidad extends StatefulWidget {

  String nameEspecialidad, nameEdo,nameCd,idCategoria,idEspecialidad;
  
  MedicosEspecialidad(this.nameEspecialidad,this.nameEdo,this.nameCd,this.idCategoria,this.idEspecialidad,{Key? key}) : super(key: key);
  @override

  _MedicosEspecialidadState createState() => _MedicosEspecialidadState();
}



class _MedicosEspecialidadState extends State<MedicosEspecialidad> {


 String urlApi = 'https://www.salumas.com/Salud_Y_Mas_Api/';
  List<ModeloMedicosEspecialidad> medicosEspe = [];
  @override
initState() {
  super.initState();

  consultarMedicos(widget.nameEdo,widget.nameCd,widget.idCategoria,widget.idEspecialidad).then((value) {
    setState(() {
      
    });
  });
}
 Future consultarMedicos(String nEdo, String nCd, String idCate, String idEspe)async{
  //  print('Esto tiene el nombre: '+nombreEstado+"ciudad: "+ nombreCiudad+ "idCate: "+idCategoria);
    medicosEspe.clear();
    //"https://www.salumas.com/Salud_Y_Mas_Api/consultas_clientesDespecialidad?nameEdo=CHIAPAS&nameCd=TUXTLA%20GUTI%C3%89RREZ&idCat=2&idEspec=5"
    final  urlApi = Uri.parse("https://www.salumas.com/Salud_Y_Mas_Api/consultas_clientesDespecialidad?nameEdo="+nEdo+"&nameCd="+nCd+"&idCat="+idCate+"&idEspec="+idEspe);
    var response = await http.get(urlApi);
    var jsonBody =   json.decode(response.body);
    print(urlApi);
    for (var data in jsonBody) {
      medicosEspe.add(new ModeloMedicosEspecialidad(data['idcliente'], data['nombre'],data['imagenName'].toString(),
      data['especialidad_idespecialidad'],data['cliente_idcliente'],data['ciudad_has_categoria_ciudad_idciudad'],
      data['ciudad_has_categoria_ciudad_estado_idestado'],data['ciudad_has_categoria_categoria_idcategoria'])); 
    } 
    medicosEspe.forEach((someData)=>print('Name : ${someData.imagenName}'));
     
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nameEspecialidad),
      ),
      body: mostrarMedicos(),
    );
  }

  mostrarMedicos() {
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
              children: medicosEspe.map((medicos) {
                // print(urlApi+'images/'+espe.imagen);
                 return new Container(
                  margin: new EdgeInsets.all(1.0),
                  child: Column(
                   children: [
                     GestureDetector(
                       onTap: (){
                       /*  Navigator.of(context).push(MaterialPageRoute<Null>(
                           builder:  (BuildContext context){

                            String nameEspecialidad = espe.nombre;
                            String nameEdo = widget.nombreEstado;
                            String nameCd = widget.nombreCiudad;
                            String idCategoria = widget.idCategoria;
                            String idEspeciliad = espe.idespecialidad;
                             return MedicosEspecialidad(nameEspecialidad,nameEdo,nameCd,idCategoria,idEspeciliad);
                           }
                         ));*/
                       },
                       child: Card(
                         child: Row(
                           children: [
                            Container(
                            width: 30.0,
                            height: 40.0,
                           /* child:
                             new Image.network(urlApi+'images/'+medicos.imagenName),*/
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
                              Text(medicos.nombre, style: TextStyle(
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