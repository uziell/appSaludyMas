import 'package:flutter/material.dart';
import 'package:salud_y_mas/src/models/notificaciones_model.dart';

class NotificacionesPage extends StatefulWidget {
  const NotificacionesPage({Key? key}) : super(key: key);

  @override
  _NotificacionesPageState createState() => _NotificacionesPageState();
}

class _NotificacionesPageState extends State<NotificacionesPage> {
  List<bool> isExpandedList = [];
  List<Notificaciones> notificacionesList = [
    Notificaciones(titulo: 'Titulo 1', descripcion: "Descripción de la notificación 1 jaisdjiasdjiasdjiasdjiasdjiasdjiasdjiasdjiasdjiasdjiasdjas", fechaHora: '19-01-2022 05:37 p.m'),
    Notificaciones(titulo: 'Titulo 2', descripcion: "Descripción de la notificación 2 ahuidasjidasjidasjidasjidasjidasjidasjidasjidasjidasjidasj", fechaHora: '19-01-2022 05:37 p.m'),
    Notificaciones(titulo: 'Titulo 3', descripcion: "Descripción de la notificación 3", fechaHora: '19-01-2022 05:37 p.m'),
    Notificaciones(titulo: 'Titulo 4', descripcion: "Descripción de la notificación 4", fechaHora: '19-01-2022 05:37 p.m'),
    Notificaciones(titulo: 'Titulo 5', descripcion: "Descripción de la notificación 5", fechaHora: '19-01-2022 05:37 p.m'),
    Notificaciones(titulo: 'Titulo 6', descripcion: "Descripción de la notificación 6", fechaHora: '19-01-2022 05:37 p.m'),
    Notificaciones(titulo: 'Titulo 7', descripcion: "Descripción de la notificación 7", fechaHora: '19-01-2022 05:37 p.m'),
    Notificaciones(titulo: 'Titulo 8', descripcion: "Descripción de la notificación 8", fechaHora: '19-01-2022 05:37 p.m'),
    Notificaciones(titulo: 'Titulo 9', descripcion: "Descripción de la notificación 9", fechaHora: '19-01-2022 05:37 p.m'),
    Notificaciones(titulo: 'Titulo 10', descripcion: "Descripción de la notificación 10", fechaHora: '19-01-2022 05:37 p.m'),
  ];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < notificacionesList.length; i++) {
      isExpandedList.add(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(title: Text('Notificaciones')),
        body: Container(
            margin: EdgeInsets.only(top: 7),
            child: ListView.builder(
                itemCount: notificacionesList.length,
                itemBuilder: (context, index) {
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
                                title: Text("${notificacion.titulo}"),
                                subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text("${notificacion.fechaHora}"),
                                  if (isExpandedList[index]) ...[
                                    Text("${notificacion.descripcion}"),
                                  ]
                                ]),
                                trailing: IconButton(
                                  icon: Icon(isExpandedList[index] ? Icons.expand_less : Icons.expand_more),
                                  onPressed: () {
                                    setState(() {
                                      isExpandedList[index] = !isExpandedList[index];
                                    });
                                  },
                                ),
                              ))));
                })));
  }
}
