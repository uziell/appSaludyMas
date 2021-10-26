import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:salud_y_mas/src/pages/informacionClientes.dart';


class MedicosEspecialidad extends StatefulWidget {

  String nameEspecialidad, nameEdo,nameCd,idCategoria,idEspecialidad;
  String? imagen;
  String colorEdo='';
  MedicosEspecialidad(this.nameEspecialidad,this.nameEdo,this.nameCd,this.idCategoria,this.idEspecialidad,this.imagen,this.colorEdo,{Key? key}) : super(key: key);
  @override
  _MedicosEspecialidadState createState() => _MedicosEspecialidadState();
}



class _MedicosEspecialidadState extends State<MedicosEspecialidad> {
  String urlApi = 'https://www.salumas.com/Salud_Y_Mas_Api/';
  List<dynamic> listaMedicos=[];

  @override
initState() {
  super.initState();

  consultarMedicos(widget.nameEdo,widget.nameCd,widget.idCategoria,widget.idEspecialidad).then((value) {
    setState(() {

    });
  });

}
 Future consultarMedicos(String nEdo, String nCd, String idCate, String idEspe)async{
    final  urlApi = Uri.parse("https://www.salumas.com/Salud_Y_Mas_Api/consultas_clientesDespecialidad?nameEdo="+nEdo+"&nameCd="+nCd+"&idCat="+idCate+"&idEspec="+idEspe);
    var response = await http.get(urlApi);
    listaMedicos = json.decode(response.body);
    return listaMedicos;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(int.parse(widget.colorEdo)),
        title: Center(child: Text(widget.nameEspecialidad, style: TextStyle(color: Colors.white,fontSize: 15))),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 25,
            ),
            imagenGeneral(),
            mostrarMedicos(),
          ],
        ),
      )
    );
  }

  mostrarMedicos() {
    var size = MediaQuery.of(context).size;
    return ListView(
        controller: new ScrollController(keepScrollOffset: false),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: listaMedicos.map((medicos) {
          return GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute<Null>(
                        builder:  (BuildContext context){
                          String nombreMEdico = medicos['nombre'];
                          String idCliente = medicos['idcliente'];
                          String? imagenName = medicos['imagenName'];
                          /*String nameCd = widget.nombreCiudad;
                           String idCategoria = widget.idCategoria;
                           String idEspeciliad = espe.idespecialidad;*/
                          return InformacionMedico(nombreMEdico,idCliente,imagenName.toString());
                        }));
                    },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xff00838f),width: 2),
                    ),
                    margin: EdgeInsets.all(4),
                    width: 200,
                    height: 60,
                    child: Card(
                      child: Row(
                        children: [
                          if(medicos['imagenName'] == null || medicos['imagenName'].toString().isEmpty)
                            Container(
                                width: 60.0,
                                height: 70.0,
                                child: Image.network(urlApi+'images/default.png')
                          )
                          else Container(
                            width: 60.0,
                            height: 70.0,
                            child: Image.network(urlApi+'images/'+medicos['imagenName']),
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
                                Center(
                                  child: Text(medicos['nombre'],
                                    style: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),),
                                ),
                              ],
                            ),
                          ),
                          ),
                         ],
                      ),
                    ),
                  ),
          );
        }).toList(),
    );
  }

  imagenGeneral() {
    final card = Container(
      //clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          if(widget.imagen == 'null' || widget.imagen.toString().isEmpty)
            FadeInImage(
              image:AssetImage('assets/jar-loading.gif'),
              placeholder: AssetImage('assets/jar-loading.gif'),
              fadeInDuration: Duration(milliseconds: 200),
              height: 230.0,
              fit: BoxFit.cover,
            )
           else FadeInImage(
            image:NetworkImage(urlApi+'images/'+widget.imagen.toString()),
            placeholder: AssetImage('assets/jar-loading.gif'),
            fadeInDuration: Duration(milliseconds: 200),
            height: 230.0,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.white,
        boxShadow:<BoxShadow>[
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            spreadRadius: 2.0,
            offset: Offset(2.0,-10.0),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.0),
        child: card,
      ),
    );
  }
}