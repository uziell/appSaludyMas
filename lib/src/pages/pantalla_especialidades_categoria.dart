import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:salud_y_mas/src/pages/informacionClientes.dart';
import 'package:salud_y_mas/src/pages/mostrarInformacionClinicasYHospitales.dart';
import 'package:salud_y_mas/src/pages/pantalla_lista_medicos_especialidades.dart';


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

  final String urlApi = 'https://www.salumas.com/Salud_Y_Mas_Api/';
  List<dynamic> listaEspecialidades =[];
  List<dynamic>listaMedicosEspe = [];
  List<dynamic> listaClinicas=[];

  @override
  void initState() {
    super.initState();
//aqui verificamos si esta entrando a las categorias que tienen especialidades
    if (widget.nombreEspecialidad == "ESPECIALIDADES"
        || widget.nombreEspecialidad == "ODONTOLOGÍA"
        || widget.nombreEspecialidad == "ESPECIALIDADES PEDIATRICAS"
        || widget.nombreEspecialidad == "DIRECTORIOS") {

      consultarEspecialidades(
          widget.nombreEstado, widget.nombreCiudad, widget.idCategoria).then((
          value) {
        setState(() {});
      });
      //aqui obtendremos a la categoria farmacias y obtendremos su inf
    } else if (widget.nombreEspecialidad == "CLINICAS Y HOSPITALES") {
      ConsultarClinicas(
          widget.nombreEstado, widget.nombreCiudad, widget.idCategoria).then((
          value) {
        setState(() {
        });
      });
    }
    else consultarClientesSinEspecialidad(
          widget.nombreEstado, widget.nombreCiudad, widget.idCategoria,
          widget.nombreEspecialidad).then((value) {
        setState(() {
        });
      });
  }

// en este método vamos a obtener las especialidades de las 4 categorias que tienen especialidad
  Future consultarEspecialidades(String nombreEstado, String nombreCiudad,String idCategoria) async {
    final urlApi = Uri.parse("https://www.salumas.com/Salud_Y_Mas_Api/consultas_especialidad?nameEdo="
        +nombreEstado+"&nameCd="+nombreCiudad+"&idCate="+idCategoria);
    var response = await http.get(urlApi);
    listaEspecialidades = json.decode(response.body);
    return listaEspecialidades;
  }

  //en este metodo consultamos las clinicas
  Future ConsultarClinicas(String nombreEstado, String nombreCiudad, String idCategoria) async {
    final urlApi = Uri.parse("https://www.salumas.com/Salud_Y_Mas_Api/consultas_clinicas?nameEdo="+nombreEstado +"&nameCd="+nombreCiudad+"&idCate=" + idCategoria);
    var response = await http.get(urlApi);
    listaClinicas = json.decode(response.body);
    return listaClinicas;
  }

  //método para consultar las categorias que no tienen especialidad
  Future consultarClientesSinEspecialidad(String nombreEstado,String nombreCiudad, String idCategoria, String nameCate) async {
    final urlApi = Uri.parse("https://www.salumas.com/Salud_Y_Mas_Api/consultas_clientesSinEspecialidad?nameEdo="
        +nombreEstado + "&nameCd=" + nombreCiudad + "&idCat=" + idCategoria + "&nameCate=" + nameCate);
    var response = await http.get(urlApi);
    listaMedicosEspe = json.decode(response.body);
    return listaMedicosEspe;
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
              else if (widget.nombreEspecialidad == "CLINICAS Y HOSPITALES") Container(child: _llamarCategoriasHospitales())
                  else Container(child: llarClientesDeCategoria()),
            ]
        ),
      ),
    );
  }


  _llamarEspecialidadesCategoria() {
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
        children: listaEspecialidades.map((espe) {
          return new Container(
            margin: new EdgeInsets.all(1.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute<Null>(
                        builder: (BuildContext context) {
                          String nameCategoria = espe['nombre'];
                          String nameEdo = widget.nombreEstado;
                          String nameCd = widget.nombreCiudad;
                          String idCategoria = widget.idCategoria;
                          String idespecialidad = espe['idespecialidad'];
                          return MedicosEspecialidad(nameCategoria, nameEdo, nameCd, idCategoria,idespecialidad);
                        }
                    ));
                  },
                  child: Card(
                    child: Row(
                      children: [
                        if(espe['imagen'] == null || espe['imagen'].toString().isEmpty)
                          Container(
                            width: 30.0,
                            height: 40.0,
                            child: Image.network(urlApi + 'images/default.png'),
                          ) else
                          Container(
                            width: 30.0,
                            height: 40.0,
                            child: Image.network(urlApi +'images/'+espe['imagen']),
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
                                Text(espe['nombre'], style: TextStyle(
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
        children: listaClinicas.map((clinicas) {
          return new Container(
            margin: new EdgeInsets.all(1.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute<Null>(
                    builder:  (BuildContext context){
                          String idclinica = clinicas['idclinicasyhospitales'];
                          String idedo = clinicas['idedo'];
                          String idcd = clinicas['idcd'];
                          String idCateg = clinicas['idcat'];
                          String nameClinica = clinicas['nombre'];
                          return ClinicasInformacion(idclinica,idedo,idcd,idCateg,nameClinica);
                        }
                    ));
                  },
                  child: Card(
                    child: Row(
                      children: [
                        if(clinicas['imagen'] == null || clinicas['imagen'].toString().isEmpty)
                          Container(
                            width: 30.0,
                            height: 40.0,
                            child: Image.network(urlApi + 'images/default.png'),
                          ) else
                          Container(
                            width: 30.0,
                            height: 40.0,
                            child: Image.network(urlApi + 'images/'+clinicas['imagen']),
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
                                  clinicas['nombre'], style: TextStyle(
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
            )
          );
        }).toList(),
      ),
    );
  }

  llarClientesDeCategoria() {
    return Container(
      child: new ListView(
        controller: new ScrollController(keepScrollOffset: false),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: listaMedicosEspe.map((medicos) {
          return new Container(
            margin: new EdgeInsets.all(1.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute<Null>(
                        builder: (BuildContext context) {
                          String nombreMedico = medicos['nombre'];
                          String idCliente = medicos['idcliente'];
                          String? imagenCliente = medicos['imagenName'];
                          return InformacionMedico(nombreMedico, idCliente,imagenCliente.toString());
                        }));
                  },
                  child: Card(
                    child: Row(
                      children: [
                        if(medicos['imagenName'] == null || medicos['imagenName'].toString().isEmpty)
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
                            Image.network(urlApi + 'images/'+medicos['imagenName']),
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
                                Text(medicos['nombre'], style: TextStyle(
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

}

