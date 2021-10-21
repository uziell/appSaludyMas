import 'dart:convert';
import 'package:card_swiper/card_swiper.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:salud_y_mas/src/models/modeloFarmaciasDelAhorro.dart';
import 'package:salud_y_mas/src/models/modelo_categoria.dart';
import 'package:salud_y_mas/src/pages/pantalla_especialidades_categoria.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoriasCiudad extends StatefulWidget {
  String nombreEdo='';
  String colorEdo ='';
  CategoriasCiudad(this.nombreEdo,this.colorEdo,{Key? key}) : super(key: key);

  @override
  _CategoriasCiudadState createState() => _CategoriasCiudadState();
}

class _CategoriasCiudadState extends State<CategoriasCiudad> {
  String vistaCiudad = "Seleccione una ciudad";
  String urlApi = 'https://www.salumas.com/Salud_Y_Mas_Api/';
  List<dynamic> nombreCd = [];
  List<dynamic> imagenes = [];
  List<String> listImagenes = [] ;
  List<MyModel> myData = [];

  List<dynamic> lisId =[];
  String idFa='';

  IdFarmaciasDelAhorro modeloIdFarmacias = new IdFarmaciasDelAhorro('');


  Future consultarAPICiudades(String nameEdo) async {
    final url = Uri.parse(urlApi+'consultas_cd?nameEdo='+nameEdo);
    var response = await http.get(url);
    nombreCd = json.decode(response.body);
    return nombreCd;

  }

  Future consultarImagenes(String nameEdp) async {
    final url = Uri.parse(urlApi+'consultas_carrusel?nameEdo='+nameEdp);
    var response = await http.get(url);
    var respuestaImagen = jsonDecode(response.body);
    for (var valor in respuestaImagen) {
      imagenes.add((valor['imagen']).toString());
    }
  }
  llenarCarrucel(List<dynamic> lista) {
    print('Esto tiene lista:'+lista.toString());
    for (var i = 0; i < lista.length; i++) {
      listImagenes.add(urlApi+'/images/'+lista[i]);
    }
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
  void initState() {
    // TODO: implement initState
    super.initState();
    consultarImagenes(widget.nombreEdo).then((value) {
      llenarCarrucel(imagenes);

    });
    consultarAPICiudades(widget.nombreEdo).then((value){
      setState(() {

      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(int.parse(widget.colorEdo)),
          title:  new Center(child: new Text(widget.nombreEdo,style: GoogleFonts.abrilFatface(), textAlign: TextAlign.center,)),
        ),
        body: ListView(
            children: [
              Padding(padding: EdgeInsetsDirectional.all(5)),
              dropdownCiudades(),
              SizedBox(
                height: 5,
                width: 5,
              ),
              carrucelDeImagenes(),
              SizedBox(
                height: 5,
                width: 5,
              ),
              categorias(),
            ],
          ),
        ),
    );
  }

  dropdownCiudades() {
    return  Container(
      width: 250,
      padding: EdgeInsets.symmetric(horizontal:12, vertical: 4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          //border: Border.all(color: Colors.black,width: 2),
          color: Color(int.parse(widget.colorEdo))
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          items: nombreCd.map((ciudadC) {
            return DropdownMenuItem(
              value: ciudadC['nombre'],
              child: Text(ciudadC['nombre']),
            );
          }).toList(),
          iconSize: 20,
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down, color: Colors.white),
          onChanged: (_ciudadActual){
            setState(() {
              vistaCiudad = _ciudadActual.toString();
              //consultarCategorias(vista,vistaCiudad);
              consultarCategorias(widget.nombreEdo,vistaCiudad).then((value){
                setState(() {

                  });
                });
              
            });
          },
          hint: Text(vistaCiudad,style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold, fontSize: 16),),
        ),
      ),
    );
  }

  carrucelDeImagenes() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color(int.parse(widget.colorEdo)),width: 2),
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

  categorias() {
    var size = MediaQuery.of(context).size;
    final double itemHeight = size.height * 15;
    final double itemWidth = size.width * 50;
    return GridView.count(
      mainAxisSpacing: 5.0,
      crossAxisCount: 2,
      padding: EdgeInsets.all(15),
      scrollDirection: Axis.vertical,
      childAspectRatio: (itemWidth / itemHeight),
      controller: new ScrollController(keepScrollOffset: false),
      shrinkWrap: true,
      children: myData.map((categ) => InkWell(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute<Null>(
              builder:  (BuildContext context){
                String nombreCategoria =  categ.nombrecategoria.toString();
                String idcategoria = categ.idcategoria;
                String nombreEdo = widget.nombreEdo;
                String nombreCd = vistaCiudad;
                String imagenGeneral = categ.imagenGeneral.toString();

                //  String idFarmacias = modeloIdFarmacias.cliente_idcliente.toString();
                return EspecialidadCategoria(nombreCategoria,idcategoria,nombreEdo,nombreCd,imagenGeneral,widget.colorEdo);
              }
          ));
        },
        child: Card(
          margin: EdgeInsets.zero,
          color:  Colors.transparent,
          elevation: 0,
          child: Column(
            children: [
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                   // color: const Color(0xff00838f),
                    borderRadius: BorderRadius.circular(26),
                    image: DecorationImage(
                        image: NetworkImage(urlApi+'images/'+ categ.imagen.toString()),
                        fit:  BoxFit.fill
                    )
                ),
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
                      children:[
                        if(categ.nombrecategoria == "ANÁLISIS CLINICOS")
                          Text("LABORATORIO DE "+categ.nombrecategoria.toString(),
                              style: GoogleFonts.montserrat( fontStyle:  FontStyle.normal,fontSize: 14))
                        else if(categ.nombrecategoria == "ULTRASONIDO Y RAYOS X")
                          Text("RADIOLOGÍA",
                              style: GoogleFonts.montserrat( fontStyle:  FontStyle.normal,fontSize: 14))
                        else
                          Text(categ.nombrecategoria.toString(),
                            style:GoogleFonts.montserrat( fontStyle:  FontStyle.normal)
                          ),
                      ],

                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      )).toList(),
    );
  }
}