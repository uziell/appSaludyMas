import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:salud_y_mas/src/models/revistas_model.dart';
import 'package:salud_y_mas/src/widgtes/appBarNotificaciones.dart';
import 'package:salud_y_mas/src/widgtes/pdfServidor.dart';

// ignore: must_be_immutable
class RevistasEstadoPage extends StatefulWidget {
  List<Revistas>? revistaList = [];
  RevistasEstadoPage({Key? key, this.revistaList}) : super(key: key);

  @override
  _RevistasEstadoPageState createState() => _RevistasEstadoPageState();
}

class _RevistasEstadoPageState extends State<RevistasEstadoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(preferredSize: Size.fromHeight(50.0), child: AppBarNotificaciones(titulo: 'Revistas')),
        body: GridView.builder(
            padding: EdgeInsets.all(20),
            itemCount: widget.revistaList!.length + 9,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 3.0, mainAxisSpacing: 5.0, childAspectRatio: 0.85),
            itemBuilder: (context, index) {
              Revistas revista = widget.revistaList![0];

              return Card(
                elevation: 5,
                child: revista.linkPortada != ""
                    ? GestureDetector(
                        onTap: () async {
                          await Navigator.of(context).push(PageTransition(
                            child: ViewPDFServidor(
                              uri: "${revista.linkRevista}",
                            ),
                            type: PageTransitionType.rightToLeft,
                          ));
                        },
                        child: Image.network(
                          "https://www.salumas.com/Salud_Y_Mas_Api/${revista.linkPortada}",
                          fit: BoxFit.fill,
                        ))
                    : Image.asset('assets/noimage.jpg'),
              );
            }));
  }
}
