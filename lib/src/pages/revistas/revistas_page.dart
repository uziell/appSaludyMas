import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:salud_y_mas/src/models/revistas_model.dart';
import 'package:salud_y_mas/src/requests/revistas_request.dart';
import 'package:salud_y_mas/src/widgtes/menu.dart';

class RevistasPage extends StatefulWidget {
  const RevistasPage({Key? key}) : super(key: key);

  @override
  _RevistasPageState createState() => _RevistasPageState();
}

class _RevistasPageState extends State<RevistasPage> {
  bool cargando = false;
  List<Revistas> revistasList = [];

  @override
  void initState() {
    super.initState();
    getRevistas();
  }

  getRevistas() async {
    cargando = false;
    List<dynamic> revistas = await RevistasRequest.obtenerRevistas();

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
        appBar: AppBar(title: Text('Revistas')),
        body: cargando
            ? Container(
                margin: EdgeInsets.only(top: 7),
                child: GroupedListView<Revistas, dynamic>(
                    elements: revistasList,
                    groupBy: (element) => element.estadoRevista,
                    groupSeparatorBuilder: (dynamic estado) =>
                        Container(margin: EdgeInsets.only(left: 12, top: 12, bottom: 8), child: Text("$estado", style: GoogleFonts.abrilFatface(fontSize: 18, fontWeight: FontWeight.bold))),
                    indexedItemBuilder: (context, dynamic revista, index) {
                      Revistas revista = revistasList[index];
                      return Container(
                          padding: EdgeInsets.only(left: 4, right: 4, bottom: 2),
                          child: Card(
                              shape: BeveledRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              elevation: 5,
                              child: Container(
                                  padding: EdgeInsets.only(bottom: 5, top: 5),
                                  child: ListTile(
                                    title: Text("REVISTAS DE ${revista.estadoRevista}"),
                                    subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Text("20/01/2022 11:56 "),
                                    ]),
                                    trailing: IconButton(
                                      icon: Icon(Icons.picture_as_pdf, color: Colors.red),
                                      onPressed: () async {
                                        FlutterWebBrowser.openWebPage(
                                          url: "${revista.linkRevista}",
                                          safariVCOptions: SafariViewControllerOptions(
                                            barCollapsingEnabled: true,
                                            preferredBarTintColor: Colors.green,
                                            preferredControlTintColor: Colors.amber,
                                            dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
                                            modalPresentationCapturesStatusBarAppearance: true,
                                          ),
                                        );
                                      },
                                    ),
                                  ))));
                    }))
            : Center(child: CircularProgressIndicator()));
  }
}
