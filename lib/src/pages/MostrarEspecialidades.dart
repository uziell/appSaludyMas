import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:salud_y_mas/src/models/modeloClinicasyHospitales.dart';
import 'dart:convert';

import 'package:salud_y_mas/src/models/modeloEspecialidades.dart';
import 'package:salud_y_mas/src/models/modelo_medicos_especialidad.dart';
import 'package:salud_y_mas/src/pages/informacionClientes.dart';
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
  List<ModeloMedicosEspecialidad> medicosEspe = [];
  List<ModeloClinicaYHospitales> modeloClinicas = [];

  @override
  void initState() {
    super.initState();

    if (widget.nombreEspecialidad == "ESPECIALIDADES"
        || widget.nombreEspecialidad == "ODONTOLOGÍA"
        || widget.nombreEspecialidad == "ESPECIALIDADES PEDIATRICAS"
        || widget.nombreEspecialidad == "DIRECTORIOS") {
      consultarEspecialidades(
          widget.nombreEstado, widget.nombreCiudad, widget.idCategoria).then((
          value) {
        setState(() {});
      });
    } else if (widget.nombreEspecialidad == "CLINICAS Y HOSPITALES") {
      ConsultarClinicas(
          widget.nombreEstado, widget.nombreCiudad, widget.idCategoria).then((
          value) {
        setState(() {

        });
      });
    } else{
      consultarClientesSinEspecialidad(
          widget.nombreEstado, widget.nombreCiudad, widget.idCategoria,
          widget.nombreEspecialidad).then((value) {
        setState(() {
        });
      });
    }
  }

  Future consultarEspecialidades(String nombreEstado, String nombreCiudad,String idCategoria) async {
    print('Esto tiene el nombre: '+nombreEstado+"ciudad: "+ nombreCiudad+ "idCate: "+idCategoria);
    datosEspecialidad.clear();
    final urlApi = Uri.parse("https://www.salumas.com/Salud_Y_Mas_Api/consultas_especialidad?nameEdo="+nombreEstado+"&nameCd="+nombreCiudad+"&idCate="+idCategoria);
    var response = await http.get(urlApi);
    var jsonBody = json.decode(response.body);
    print(urlApi);
    for (var data in jsonBody) {
      datosEspecialidad.add(new ModeloEspecialidad(
          data['idespecialidad'], data['nombre'], data['imagen'].toString(),
          data['imagenGeneral'].toString()));
    }
    datosEspecialidad.forEach((someData) => print('Name : ${someData.nombre}'));
  }

  Future ConsultarClinicas(String nombreEstado, String nombreCiudad,
      String idCategoria) async {
    modeloClinicas.clear();
    final urlApi = Uri.parse(
        "https://www.salumas.com/Salud_Y_Mas_Api/consultas_clinicas?nameEdo=" +
            nombreEstado + "&nameCd=" + nombreCiudad + "&idCate=" +
            idCategoria);
    var response = await http.get(urlApi);
    var jsonBody = json.decode(response.body);
    //print(urlApi);
    for (var data in jsonBody) {
      modeloClinicas.add(new ModeloClinicaYHospitales(
          data['idclinicasyhospitales'], data['nombre'],
          data['imagen'].toString(), data['idcat'], data['idcd'],
          data['idedo']));
    }
    modeloClinicas.forEach((someData) => print('Name : ${someData.nombre}'));
  }

  Future consultarClientesSinEspecialidad(String nombreEstado,
      String nombreCiudad, String idCategoria, String nameCate) async {
    print('Esto tiene el nombre: ' + nombreEstado + "ciudad: " + nombreCiudad +
        "idCate: " + idCategoria + "idespeci:" + nameCate);
    medicosEspe.clear();
    final urlApi = Uri.parse(
        "https://www.salumas.com/Salud_Y_Mas_Api/consultas_clientesSinEspecialidad?nameEdo=" +
            nombreEstado + "&nameCd=" + nombreCiudad +
            "&idCat=" + idCategoria + "&nameCate=" + nameCate);
    var response = await http.get(urlApi);
    var jsonBody = json.decode(response.body);
    print(urlApi);
    print(jsonBody);
    for (var data in jsonBody) {
      medicosEspe.add(new ModeloMedicosEspecialidad(
          data['idcliente'],
          data['nombre'],
          data['imagenName'].toString(),
          data['especialidad_idespecialidad'],
          data['cliente_idcliente'],
          data['ciudad_has_categoria_ciudad_idciudad'],
          data['ciudad_has_categoria_ciudad_estado_idestado'],
          data['ciudad_has_categoria_categoria_idcategoria']));
    }
    medicosEspe.forEach((someData) => print('Name : ${someData.nombre}'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nombreEspecialidad),
      ),
      body: SingleChildScrollView(
        child: Column(
            children: [

              if(widget.nombreEspecialidad == "ESPECIALIDADES" ||
                  widget.nombreEspecialidad == "ODONTOLOGÍA" ||
                  widget.nombreEspecialidad == "ESPECIALIDADES PEDIATRICAS" ||
                  widget.nombreEspecialidad == "DIRECTORIOS")
                Container(child: _llamarEspecialidadesCategoria())
              else
                if (widget.nombreEspecialidad ==
                    "CLINICAS Y HOSPITALES") Container(
                    child: _llamarCategoriasHospitales())
                else
                  Container(child: llarClientesDeCategoria(),),
            ]
        ),
      ),
    );
  }


  _llamarEspecialidadesCategoria() {
    var size = MediaQuery
        .of(context)
        .size;
    final double itemHeight = size.height * 15.8;
    final double itemWidth = size.width * 120;
    return Container(
      child: new GridView.count(
        crossAxisCount: 2,
        childAspectRatio: (itemWidth / itemHeight),
        controller: new ScrollController(keepScrollOffset: false),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: datosEspecialidad.map((espe) {
          return new Container(
            margin: new EdgeInsets.all(1.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute<Null>(
                        builder: (BuildContext context) {
                          String nameCategoria = espe.nombre;
                          String nameEdo = widget.nombreEstado;
                          String nameCd = widget.nombreCiudad;
                          String idCategoria = widget.idCategoria;
                          String idespecialidad = espe.idespecialidad;
                          return MedicosEspecialidad(
                              nameCategoria, nameEdo, nameCd, idCategoria,
                              idespecialidad);
                        }
                    ));
                  },
                  child: Card(
                    child: Row(
                      children: [
                        if(espe.imagen == null || espe.imagen
                            .toString()
                            .isEmpty)
                          Container(
                            width: 30.0,
                            height: 40.0,
                            child: Image.network(urlApi + 'images/default.png'),
                          ) else
                          Container(
                            width: 30.0,
                            height: 40.0,
                            child: Image.network(
                                urlApi + 'images/' + espe.imagen.toString()),
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
                                Text(espe.nombre.toString(), style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 9,
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

  _llamarCategoriasHospitales() {
    var size = MediaQuery
        .of(context)
        .size;
    final double itemHeight = size.height * 15.8;
    final double itemWidth = size.width * 120;
    return Container(
      child: new GridView.count(
        crossAxisCount: 2,
        childAspectRatio: (itemWidth / itemHeight),
        controller: new ScrollController(keepScrollOffset: false),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: modeloClinicas.map((clinicas) {
          return new Container(
            margin: new EdgeInsets.all(1.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    /*Navigator.of(context).push(MaterialPageRoute<Null>(
                    builder:  (BuildContext context){
                         String nameCategoria = espe.nombre;
                          String nameEdo = widget.nombreEstado;
                          String nameCd = widget.nombreCiudad;
                          String idCategoria = widget.idCategoria;
                          String idespecialidad = espe.idespecialidad;
                          return MedicosEspecialidad(nameCategoria,nameEdo,nameCd,idCategoria,idespecialidad);
                        }
                    ));*/
                  },
                  child: Card(
                    child: Row(
                      children: [
                        if(clinicas.imagen == null || clinicas.imagen
                            .toString()
                            .isEmpty)
                          Container(
                            width: 30.0,
                            height: 40.0,
                            child: Image.network(urlApi + 'images/default.png'),
                          ) else
                          Container(
                            width: 30.0,
                            height: 40.0,
                            child: Image.network(urlApi + 'images/' +
                                clinicas.imagen.toString()),
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
                                Text(
                                  clinicas.nombre.toString(), style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold
                                  ,
                                  fontSize: 9,
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

  llarClientesDeCategoria() {
    var size = MediaQuery
        .of(context)
        .size;
    final double itemHeight = size.height * 15.8;
    final double itemWidth = size.width * 120;
    return Container(
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
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute<Null>(
                        builder: (BuildContext context) {
                          String nombreMEdico = medicos.nombre;
                          String idCliente = medicos.idcliente;
                          return InformacionMedico(nombreMEdico, idCliente);
                        }));
                  },
                  child: Card(
                    child: Row(
                      children: [
                        if(medicos.imagenName == null || medicos.imagenName
                            .toString()
                            .isEmpty)
                          Container(
                              width: 30.0,
                              height: 40.0,
                              child: Image.network(urlApi + 'images/default.png')
                          )
                        else
                          Container(
                            width: 30.0,
                            height: 40.0,
                            child:
                            Image.network(urlApi + 'images/'+medicos.imagenName.toString()),
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
                                Text(medicos.nombre, style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold
                                  ,
                                  fontSize: 9,
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

