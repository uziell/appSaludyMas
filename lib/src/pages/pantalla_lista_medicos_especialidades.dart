import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';


class MedicosEspecialidad extends StatefulWidget {

  String nameEspecialidad, nameEdo,nameCd,idCategoria,idEspecialidad;
  MedicosEspecialidad(this.nameEspecialidad,this.nameEdo,this.nameCd,this.idCategoria,this.idEspecialidad,{Key? key}) : super(key: key);
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
        title: Text(widget.nameEspecialidad ),
      ),
      body: mostrarMedicos(),
    );
  }

  mostrarMedicos() {
    return  Container(
      child: new ListView(
        controller: new ScrollController(keepScrollOffset: false),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: listaMedicos.map((medicos) {
          return new Container(
            margin: new EdgeInsets.all(1.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: (){
                   /* Navigator.of(context).push(MaterialPageRoute<Null>(
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
                        if(medicos['imagenName'] == null || medicos['imagenName'].toString().isEmpty)
                          Container(
                            width: 30.0,
                            height: 40.0,
                          child: Image.network(urlApi+'images/default.png')
                        )
                        else Container(
                          width: 30.0,
                          height: 40.0,
                          child:
                           Image.network(urlApi+'images/'+medicos['imagenName']),
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
                              Text(medicos['nombre'], style: TextStyle(
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