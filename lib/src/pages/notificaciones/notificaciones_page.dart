import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:salud_y_mas/preferences/preferences.dart';
import 'package:salud_y_mas/src/models/notificaciones_model.dart';
import 'package:salud_y_mas/src/requests/notificaciones_request.dart';
import 'package:salud_y_mas/src/widgtes/menu.dart';

class NotificacionesPage extends StatefulWidget {
  final bool? isMenu;
  const NotificacionesPage({Key? key, this.isMenu}) : super(key: key);

  @override
  _NotificacionesPageState createState() => _NotificacionesPageState();
}

class _NotificacionesPageState extends State<NotificacionesPage> {

  AppPreferences _prefs = AppPreferences();
  List<bool> isExpandedList = [];
  bool cargando = false;
  List<Notificaciones> notificacionesList = [];

  @override
  void initState() {
    super.initState();
    getNotificaciones();
  }

  getNotificaciones() async {
    cargando = false;
    List<dynamic> notificaciones = await NotificacionesRequest().obtenerNotificaciones();

    print(notificaciones);
    notificacionesList = notificaciones.map((e) => Notificaciones.fromJson(e)).toList();

    for (int i = 0; i < notificacionesList.length; i++) {
      isExpandedList.add(false);
    }

    setState(() {
      cargando = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        drawer: widget.isMenu == true ? MenuPage() : null,
        appBar: AppBar(title: Text('Notificaciones')),
        body: cargando
            ? notificacionesList.length >0 ?  Container(
                margin: EdgeInsets.only(top: 7),
                child: GroupedListView<Notificaciones, dynamic>(
                    elements: notificacionesList,
                    groupBy: (element) => element.estadoNot,
                    groupSeparatorBuilder: (dynamic visto) => Container(
                        margin: EdgeInsets.only(left: 12, top: 12, bottom: 8), child: Text("${visto == "0" ? 'No vistas' : 'Vistas'}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                    indexedItemBuilder: (context, dynamic notificacion, index) {
                      Notificaciones notificacion = notificacionesList[index];
                      return Container(
                          padding: EdgeInsets.only(left: 4, right: 4, bottom: 2),
                          child: Card(
                              shape: BeveledRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              elevation: 5,
                              child: Container(
                                  padding: isExpandedList[index] ? EdgeInsets.only(bottom: 5, top: 5) : null,
                                  child: ListTile(
                                    title: Text("${notificacion.titulo != "" ? notificacion.titulo : 'Sin titulo'}"),
                                    subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Text("20/01/2022 11:56 "),
                                      if (isExpandedList[index]) ...[
                                        Text("${notificacion.descripcion}"),
                                      ]
                                    ]),
                                    trailing: IconButton(
                                      icon: Icon(isExpandedList[index] ? Icons.expand_less : Icons.expand_more),
                                      onPressed: () async {
                                        setState(() {
                                          isExpandedList[index] = !isExpandedList[index];
                                        });

                                        if (notificacion.estadoNot == "0") {
                                          var r = await NotificacionesRequest.cambiarEstatusNotificacion(notificacion.id);

                                          print("cambio");
                                          print(r);
                                        }
                                      },
                                    ),
                                  ))));
                    })):Container(
                      margin: EdgeInsets.all(10),
                      child:  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                    Image.asset('assets/lupa(1).png', alignment: Alignment.center, width: 200, height: 200),
                    Text('NO HAY NOTIFICACIONES REGISTRADAS EN ${_prefs.estado} POR EL MOMENTO', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),)
                    ]))
            : Center(child: CircularProgressIndicator()));
  }
}
