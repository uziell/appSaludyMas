import 'dart:convert';
import 'package:badges/badges.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:salud_y_mas/src/models/modeloFarmaciasDelAhorro.dart';
import 'package:salud_y_mas/src/models/modelo_categoria.dart';
import 'package:salud_y_mas/src/pages/pantalla_especialidades_categoria.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoriasCiudad extends StatefulWidget {
  String nombreEdo = '';
  String colorEdo = '';
  CategoriasCiudad(this.nombreEdo, this.colorEdo, {Key? key}) : super(key: key);

  @override
  _CategoriasCiudadState createState() => _CategoriasCiudadState();
}

class _CategoriasCiudadState extends State<CategoriasCiudad> {
  String vistaCiudad = '';
  String urlApi = 'https://www.salumas.com/Salud_Y_Mas_Api/';
  List<dynamic> nombreCd = [];
  List<dynamic> imagenes = [];
  List<String> listImagenes = [];
  List<MyModel> myData = [];
  bool cargandoGrid = false;
  List<dynamic> lisId = [];
  String idFa = '';

  IdFarmaciasDelAhorro modeloIdFarmacias = new IdFarmaciasDelAhorro('');

  List<String> ciudadesConsulta = [];
  String _estadoActual = '', _ciudad = "";
  List<DropdownMenuItem<String>> _dropDownMenuCiudades = [];

  Future consultarAPICiudades(String nameEdo) async {
    final url = Uri.parse(urlApi + 'consultas_cd?nameEdo=' + nameEdo);
    var response = await http.get(url);
    nombreCd = json.decode(response.body);
    return nombreCd;
  }

  Future consultarImagenes(String nameEdp) async {
    final url = Uri.parse(urlApi + 'consultas_carrusel?nameEdo=' + nameEdp);
    var response = await http.get(url);
    var respuestaImagen = jsonDecode(response.body);
    for (var valor in respuestaImagen) {
      imagenes.add((valor['imagen']).toString());
    }
  }

  llenarCarrucel(List<dynamic> lista) {
    print('Esto tiene lista:' + lista.toString());
    for (var i = 0; i < lista.length; i++) {
      listImagenes.add(urlApi + '/images/' + lista[i]);
    }
  }

  Future consultarCategorias(String actualStado, String actualCiudad) async {
    print('Esto tiene ' + actualStado + 'y ciudad ' + actualCiudad);
    myData.clear();
    final urlApi = Uri.parse("https://www.salumas.com/Salud_Y_Mas_Api/consultas_categorias?nameEdo=" + actualStado + "&nameCd=" + actualCiudad);

    setState(() {
      this.cargandoGrid = false;
    });

    var response = await http.get(urlApi);
    var jsonBody = json.decode(response.body);
    print(urlApi);

    for (var data in jsonBody) {
      myData.add(new MyModel(data['idcategoria'], data['nombrecategoria'], data['descripccion'], data['imagen'].toString(), data['imagen_general'].toString()));
    }
    myData.forEach((someData) => print('Name : ${someData.nombrecategoria}'));
    setState(() {
      this.cargandoGrid = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    consultarImagenes(widget.nombreEdo).then((value) {
      llenarCarrucel(imagenes);
    });
    consultarAPICiudades(widget.nombreEdo).then((value) {
      setState(() {
        vistaCiudad = nombreCd[0]['nombre'];
        //_ciudad = _dropDownMenuCiudades[0].value.toString();
        print("tiene pos0 ... " + vistaCiudad);

        this.cargandoGrid = false;
        consultarCategorias(widget.nombreEdo, vistaCiudad).then((value) {
          print("entra aqui");
          setState(() {});
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(children: [
      Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.dstATop),
            image: AssetImage('assets/fondoPrincipal.jpg'),
            fit: BoxFit.cover,
            //colorFilter: ColorFilter.mode(Colors.white,)
          ),
        ),
      ),
      Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Color(int.parse(widget.colorEdo)),
            title: Text(
              widget.nombreEdo,
              style: GoogleFonts.abrilFatface(),
            ),
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
          body: Container(
              padding: EdgeInsets.all(5),
              child: ListView(
                children: [
                  dropdownCiudades(),
                  //dropCid(),

                  carrucelDeImagenes(),
                  SizedBox(height: 5),
                  categorias(),
                ],
              )))
    ]));
  }

  dropdownCiudades() {
    return Container(
      color: Colors.white,
      width: 250,
      height: 70,
      padding: EdgeInsets.only(top: 5, bottom: 5, left: 4, right: 4),
      child: DropdownButtonFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
        items: nombreCd.map((ciudadC) {
          return DropdownMenuItem(
            value: ciudadC['nombre'],
            child: Text(ciudadC['nombre']),
          );
        }).toList(),
        iconSize: 20,
        icon: Icon(Icons.arrow_drop_down, color: Colors.white),
        onChanged: (_ciudadActual) {
          setState(() {
            vistaCiudad = _ciudadActual.toString();

            consultarCategorias(widget.nombreEdo, vistaCiudad).then((value) {
              setState(() {});
            });
          });
        },
        hint: Text(
          vistaCiudad,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
    );
  }

  carrucelDeImagenes() {
    return Container(
        margin: EdgeInsets.only(top: 4, bottom: 2),
        height: 230.0,
        child: CarouselSlider(
          options: CarouselOptions(
            height: 230.0,
            initialPage: 0,
            autoPlay: true,
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            aspectRatio: 2.0,
            viewportFraction: 1.0,
          ),
          items: listImagenes.map((imagen) {
            return Builder(
              builder: (BuildContext context) {
                return Container(width: MediaQuery.of(context).size.width, child: Image.network("$imagen", fit: BoxFit.fill));
              },
            );
          }).toList(),
        ));
  }

  categorias() {
    var size = MediaQuery.of(context).size;
    final double itemHeight = size.height * 20;
    final double itemWidth = size.width * 50;

    /*  if(vistaCiudad == "Seleccione una ciudad")return CupertinoAlertDialog(
      title: Text('Seleccione Una Ciudad'),

    );
    else*/
    return cargandoGrid == true
        ? GridView.count(
            mainAxisSpacing: 5.0,
            crossAxisSpacing: 5.0,
            crossAxisCount: 3,
            scrollDirection: Axis.vertical,
            childAspectRatio: (itemWidth / itemHeight),
            controller: new ScrollController(keepScrollOffset: false),
            shrinkWrap: true,
            children: myData
                .map((categ) => InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute<Null>(builder: (BuildContext context) {
                          String nombreCategoria = categ.nombrecategoria.toString();
                          String idcategoria = categ.idcategoria;
                          String nombreEdo = widget.nombreEdo;
                          String nombreCd = vistaCiudad;
                          String imagenGeneral = categ.imagenGeneral.toString();

                          //  String idFarmacias = modeloIdFarmacias.cliente_idcliente.toString();
                          return EspecialidadCategoria(nombreCategoria, idcategoria, nombreEdo, nombreCd, imagenGeneral, widget.colorEdo);
                        }));
                      },
                      child: Card(
                        margin: EdgeInsets.zero,
                        elevation: 0,
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 5, bottom: 5),
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                  //color: Color(int.parse(widget.colorEdo)),
                                  borderRadius: BorderRadius.circular(26),
                                  image: DecorationImage(image: NetworkImage(urlApi + 'images/' + categ.imagen.toString()), fit: BoxFit.fill)),
                            ),
                            SizedBox(
                              width: 2.5,
                            ),
                            Expanded(
                              child: Container(
                                child: Container(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (categ.nombrecategoria == "ANÁLISIS CLINICOS")
                                        Center(
                                            child: Text(
                                          "LABORATORIO DE " + categ.nombrecategoria.toString(),
                                          style: GoogleFonts.montserrat(fontStyle: FontStyle.normal, fontSize: 9, fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ))
                                      else if (categ.nombrecategoria == "ULTRASONIDO Y RAYOS X")
                                        Center(
                                            child: Text("RADIOLOGÍA",
                                                style: GoogleFonts.montserrat(
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center))
                                      else
                                        Center(
                                            child: Text(categ.nombrecategoria.toString(),
                                                style: GoogleFonts.montserrat(fontStyle: FontStyle.normal, fontSize: 9, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))
                .toList(),
          )
        : Center(
            child: CircularProgressIndicator(
            color: Colors.white,
          ));
  }
}
