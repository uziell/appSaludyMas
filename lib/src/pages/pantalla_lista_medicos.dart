
import 'package:flutter/material.dart';
import 'package:salud_y_mas/src/models/modelo_medicos_especialidad.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListaMedicosCategoria extends StatefulWidget {
  String nameEspecialidad, nameEdo,nameCd,idCategoria,idEspecialidad;
  ListaMedicosCategoria(this.nameEspecialidad,this.nameEdo,this.nameCd,this.idCategoria,this.idEspecialidad,{Key? key}) : super(key: key);

  @override
  _ListaMedicosCategoriaState createState() => _ListaMedicosCategoriaState();
}

class _ListaMedicosCategoriaState extends State<ListaMedicosCategoria> {
  String urlApi = 'https://www.salumas.com/Salud_Y_Mas_Api/';
  List<ModeloMedicosEspecialidad> medicosEspe = [];
  String imagenNombre='';
  String ima='';

  @override
  initState() {
    super.initState();
    print('nameEdo: '+widget.nameEdo +'nameCd: '+widget.nameCd +'idCateg: '+widget.idCategoria +'idEspeci: '+widget.idEspecialidad);
    consultarMedicos(widget.nameEdo,widget.nameCd,widget.idCategoria,widget.idEspecialidad).then((value) {
      setState(() {
      });
    });
  }

  Future consultarMedicos(String nEdo, String nCd, String idCate, String idEspe)async{
    medicosEspe.clear();
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
      body:  mostrarMedicos(),
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
          return new Container(
            margin: new EdgeInsets.all(1.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: (){
                  /*  Navigator.of(context).push(MaterialPageRoute<Null>(
                        builder:  (BuildContext context){
                          String nombreMEdico = medicos.nombre;
                          String idCliente = medicos.idcliente;
                          String imagenName = medicos.imagenName.toString();
                          /*String nameCd = widget.nombreCiudad;
                           String idCategoria = widget.idCategoria;
                           String idEspeciliad = espe.idespecialidad;*/
                          return InformacionMedico(nombreMEdico,idCliente,imagenName);
                        }));*/
                  },
                  child: Card(
                    child: Row(
                      children: [
                        if(medicos.imagenName == null || medicos.imagenName.toString().isEmpty)
                          Container(
                              width: 30.0,
                              height: 40.0,
                              child: Image.network(urlApi+'images/default.png')
                          )
                        else Container(
                          width: 30.0,
                          height: 40.0,
                          child:
                          Image.network(urlApi+'images/'+medicos.imagenName.toString()),
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
