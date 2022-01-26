import 'package:flutter/material.dart';

import 'package:salud_y_mas/src/models/revistas_model.dart';
import 'package:salud_y_mas/src/pages/revistas/revista_estado_page.dart';
import 'package:salud_y_mas/src/requests/revistas_request.dart';
import 'package:salud_y_mas/src/widgtes/appBarNotificaciones.dart';
import 'package:salud_y_mas/src/widgtes/menu.dart';

class RevistasPage extends StatefulWidget {
  const RevistasPage({Key? key}) : super(key: key);

  @override
  _RevistasPageState createState() => _RevistasPageState();
}

class _RevistasPageState extends State<RevistasPage> {
  bool cargando = false;
  List<Revistas> revistasList = [];

  List<dynamic> listaEstados = [];

  @override
  void initState() {
    super.initState();
    getRevistas();
  }

  getRevistas() async {
    cargando = false;
    List<dynamic> revistas = await RevistasRequest.obtenerRevistas();

    listaEstados = revistas.map((e) => e['estado_revista']).toList();

    print(revistas);
    revistasList = revistas.map((e) => Revistas.fromJson(e)).toList();

    setState(() {
      cargando = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        drawer: MenuPage(),
        appBar: PreferredSize(preferredSize: Size.fromHeight(50.0), child: AppBarNotificaciones(titulo: 'Revistas')),
        body: cargando
            ? ListView.builder(
                itemCount: listaEstados.length,
                itemBuilder: (context, index) {
                  String estado = listaEstados[index];
                  return Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Card(
                          child: Container(
                              padding: EdgeInsets.all(15),
                              child: ListTile(
                                title: Text('$estado'),
                                subtitle: Text('Presione el botón para visualizar el catalogo de  revistas de $estado'),
                                trailing: IconButton(
                                  onPressed: () {
                                    List<Revistas> revistaEstado = revistasList.where((element) => element.estadoRevista == estado).toList();
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => RevistasEstadoPage(revistaList: revistaEstado)));
                                  },
                                  icon: Icon(Icons.now_wallpaper_sharp),
                                  color: Colors.blue,
                                ),
                              ))));
                })
            : Center(child: CircularProgressIndicator()));
  }
}
