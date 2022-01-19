import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:salud_y_mas/src/pages/informacionClientes.dart';
import 'package:salud_y_mas/src/pages/mostrarInformacionClinicasYHospitales.dart';
import 'package:salud_y_mas/src/pages/pantalla_lista_medicos_especialidades.dart';

class EspecialidadCategoria extends StatefulWidget {
  String nombreEspecialidad = '';
  String idCategoria;
  String nombreEstado = '';
  String nombreCiudad = '';
  String imagenGeneral = '';
  String colorEdo = '';
  EspecialidadCategoria(this.nombreEspecialidad, this.idCategoria, this.nombreEstado, this.nombreCiudad, this.imagenGeneral, this.colorEdo, {Key? key}) : super(key: key);

  @override
  _EspecialidadCategoriaState createState() => _EspecialidadCategoriaState();
}

class _EspecialidadCategoriaState extends State<EspecialidadCategoria> {
  final String urlApi = 'https://www.salumas.com/Salud_Y_Mas_Api/';
  List<dynamic> listaEspecialidades = [];
  List<dynamic> listaMedicosEspe = [];
  List<dynamic> listaClinicas = [];
  bool cargando = false;

  @override
  void initState() {
    super.initState();

//aqui verificamos si esta entrando a las categorias que tienen especialidades
    if (widget.nombreEspecialidad == "ESPECIALIDADES" ||
        widget.nombreEspecialidad == "ODONTOLOGÍA" ||
        widget.nombreEspecialidad == "ESPECIALIDADES PEDIATRICAS" ||
        widget.nombreEspecialidad == "DIRECTORIOS") {
      consultarEspecialidades(widget.nombreEstado, widget.nombreCiudad, widget.idCategoria).then((value) {
        print("especialidades");
        setState(() {
          this.cargando = true;
        });
      });
      //aqui obtendremos a la categoria farmacias y obtendremos su inf
    } else if (widget.nombreEspecialidad == "CLINICAS Y HOSPITALES") {
      ConsultarClinicas(widget.nombreEstado, widget.nombreCiudad, widget.idCategoria).then((value) {
        setState(() {
          this.cargando = true;
        });
      });
    } else
      consultarClientesSinEspecialidad(widget.nombreEstado, widget.nombreCiudad, widget.idCategoria, widget.nombreEspecialidad).then((value) {
        setState(() {
          this.cargando = true;
        });
      });
  }

// en este método vamos a obtener las especialidades de las 4 categorias que tienen especialidad
  Future consultarEspecialidades(String nombreEstado, String nombreCiudad, String idCategoria) async {
    final urlApi = Uri.parse("https://www.salumas.com/Salud_Y_Mas_Api/consultas_especialidad?nameEdo=" + nombreEstado + "&nameCd=" + nombreCiudad + "&idCate=" + idCategoria);
    var response = await http.get(urlApi);
    listaEspecialidades = json.decode(response.body);
    return listaEspecialidades;
  }

  //en este metodo consultamos las clinicas
  Future ConsultarClinicas(String nombreEstado, String nombreCiudad, String idCategoria) async {
    final urlApi = Uri.parse("https://www.salumas.com/Salud_Y_Mas_Api/consultas_clinicas?nameEdo=" + nombreEstado + "&nameCd=" + nombreCiudad + "&idCate=" + idCategoria);
    var response = await http.get(urlApi);
    listaClinicas = json.decode(response.body);
    return listaClinicas;
  }

  //método para consultar las categorias que no tienen especialidad
  Future consultarClientesSinEspecialidad(String nombreEstado, String nombreCiudad, String idCategoria, String nameCate) async {
    final urlApi =
        Uri.parse("https://www.salumas.com/Salud_Y_Mas_Api/consultas_clientesSinEspecialidad?nameEdo=" + nombreEstado + "&nameCd=" + nombreCiudad + "&idCat=" + idCategoria + "&nameCate=" + nameCate);
    var response = await http.get(urlApi);
    listaMedicosEspe = json.decode(response.body);
    return listaMedicosEspe;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/fondoPrincipal.jpg'),
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.dstATop),
              //colorFilter: ColorFilter.mode(Colors.white,)
            ),
          ),
        ),
        Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Color(int.parse(widget.colorEdo)),
              title: Text(widget.nombreEspecialidad, style: GoogleFonts.montserrat(color: Colors.white, fontSize: 14)),
              actions: [
                Badge(
                  position: BadgePosition.topEnd(top: 5, end: 3),
                  badgeColor: Colors.red,
                  badgeContent: Text('3', style: TextStyle(color: Colors.white)),
                  child: IconButton(
                    icon: Icon(Icons.notifications),
                    onPressed: () {
                      Navigator.pushNamed(context, 'notificaciones');
                    },
                  ),
                ),
              ],
            ),
            body: this.cargando == true
                ? SingleChildScrollView(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
                      //imagenGeneral(),
                      //En este if vamos verfiricas las categorias que tienen especialidad y se ejecuta el metodo  _llamarEspecialidadesCategoria()
                      if (widget.nombreEspecialidad == "ESPECIALIDADES" ||
                          widget.nombreEspecialidad == "ODONTOLOGÍA" ||
                          widget.nombreEspecialidad == "ESPECIALIDADES PEDIATRICAS" ||
                          widget.nombreEspecialidad == "DIRECTORIOS")
                        Container(child: _llamarEspecialidadesCategoria())
                      //en este if solo sera para las clinicas y se ejecuta el metodo  _llamarCategoriasHospitales()
                      else if (widget.nombreEspecialidad == "CLINICAS Y HOSPITALES")
                        Container(child: _llamarCategoriasHospitales())
                      //en este else vamos a ejecutar el metodo y llamar las categorias que no tengan especialidad que muestre directo los clientes
                      else
                        Container(alignment: Alignment.center, child: llarClientesDeCategoria()),
                    ]),
                  )
                : Center(child: Container(child: CircularProgressIndicator(color: Colors.white))))
      ],
    );
  }

  _llamarEspecialidadesCategoria() {
    var size = MediaQuery.of(context).size;
    final double itemHeight = size.height * 35;
    final double itemWidth = size.width * 160;

    if (listaEspecialidades.isEmpty)
      return this.emptyLista();
    else
      return Container(
          margin: EdgeInsets.only(top: 4, left: 4, right: 4),
          child: ListView(
            controller: new ScrollController(keepScrollOffset: false),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: listaEspecialidades.map((espe) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute<Null>(builder: (BuildContext context) {
                    String nameCategoria = espe['nombre'];
                    String nameEdo = widget.nombreEstado;
                    String nameCd = widget.nombreCiudad;
                    String idCategoria = widget.idCategoria;
                    String idespecialidad = espe['idespecialidad'];
                    String? imagenEspe = espe['imagen'];
                    return MedicosEspecialidad(nameCategoria, nameEdo, nameCd, idCategoria, idespecialidad, imagenEspe.toString(), widget.colorEdo);
                  }));
                },
                child: Card(
                  margin: EdgeInsets.all(4),
                  child: Row(
                    children: [
                      if (espe['imagen'] == null || espe['imagen'].toString().isEmpty)
                        Container(
                          margin: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue, width: 2),
                            // color:const Color(0xff00838f),
                          ),
                          width: 50.0,
                          height: 60.0,
                          child: Image.network(urlApi + 'images/default.png'),
                        )
                      else
                        Container(
                          margin: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue, width: 2),
                            // color:const Color(0xff00838f),
                          ),
                          width: 50.0,
                          height: 60.0,
                          child: Image.network(urlApi + 'images/' + espe['imagen']),
                        ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(child: Text(espe['nombre'], style: GoogleFonts.montserrat(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.bold))),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ));
  }

  _llamarCategoriasHospitales() {
    var size = MediaQuery.of(context).size;
    final double itemHeight = size.height * 35;
    final double itemWidth = size.width * 160;
    if (listaClinicas.isEmpty)
      return this.emptyLista();
    else
      return Container(
        child: new GridView.count(
          crossAxisCount: 2,
          childAspectRatio: (itemWidth / itemHeight),
          controller: new ScrollController(keepScrollOffset: false),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          //en este children mapeamos la listaClinicas para obtener lo que tiene almacenado
          children: listaClinicas.map((clinicas) {
            return GestureDetector(
              //En este ontap le damos para pasar a la siguiente pantalla
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute<Null>(builder: (BuildContext context) {
                  String idclinica = clinicas['idclinicasyhospitales'];
                  String idedo = clinicas['idedo'];
                  String idcd = clinicas['idcd'];
                  String idCateg = clinicas['idcat'];
                  String nameClinica = clinicas['nombre'];
                  return ClinicasInformacion(idclinica, idedo, idcd, idCateg, nameClinica, widget.colorEdo);
                }));
              },
              child: Card(
                margin: EdgeInsets.all(2),
                child: Row(
                  children: [
                    if (clinicas['imagen'] == null || clinicas['imagen'].toString().isEmpty)
                      Container(
                        width: 60.0,
                        height: 70.0,
                        child: Image.network(urlApi + 'images/default.png'),
                      )
                    else
                      Container(
                        width: 60.0,
                        height: 70.0,
                        child: Image.network(urlApi + 'images/' + clinicas['imagen']),
                      ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text(clinicas['nombre'], style: GoogleFonts.montserrat(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.bold))],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      );
  }

  Widget emptyLista() {
    return Container(
        margin: EdgeInsets.only(top: 48),
        padding: EdgeInsets.all(10),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/lupa(1).png', alignment: Alignment.center, width: 200, height: 200),
            Container(
                margin: EdgeInsets.only(top: 15),
                child: Text("POR EL MOMENTO NO TENEMOS " + widget.nombreEspecialidad + " AGREGADOS A NUESTRO CATÁLOGO...",
                    textAlign: TextAlign.center, style: GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey.shade800)))
          ],
        ));
  }

  llarClientesDeCategoria() {
    if (listaMedicosEspe.isEmpty)
      return this.emptyLista();
    else
      return Container(
        child: new ListView(
          controller: new ScrollController(keepScrollOffset: false),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          //en este children mapeamos lista medicos para ver lo que tiene almacenado
          children: listaMedicosEspe.map((medicos) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute<Null>(builder: (BuildContext context) {
                  String nombreMedico = medicos['nombre'];
                  String idCliente = medicos['idcliente'];
                  String? imagenCliente = medicos['imagenName'];

                  return InformacionMedico(nombreMedico, idCliente, imagenCliente.toString(), widget.colorEdo);
                }));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                ),
                margin: EdgeInsets.all(6),
                width: 200,
                height: 65,
                child: Card(
                    elevation: 6,
                    child: Container(
                        padding: EdgeInsets.all(3),
                        child: Row(
                          children: [
                            if (medicos['imagenName'] == null || medicos['imagenName'].toString().isEmpty)
                              Container(width: 60.0, height: 70.0, child: Image.network(urlApi + 'images/default.png'))
                            else
                              Container(
                                width: 60.0,
                                height: 70.0,
                                child: Image.network(urlApi + 'images/' + medicos['imagenName']),
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
                                    Center(
                                      child: Text(
                                        medicos['nombre'],
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ))),
              ),
            );
          }).toList(),
        ),
      );
  }

  imagenGeneral() {}
}
