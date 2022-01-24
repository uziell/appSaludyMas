import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salud_y_mas/apps/ui/pages/home/home_crontroller.dart';
import 'package:salud_y_mas/apps/ui/pages/home/widgets/googleMaps.dart';
import 'package:salud_y_mas/src/models/modeloDireccion.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePageGoogle extends StatelessWidget {
  final ModeloDireccion? direccion;
  const HomePageGoogle({Key? key, this.direccion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeController>(
      create: (_) {
        final controller =
            HomeController(direccion?.latitud, direccion?.longitud, direccion);

        controller.onMarkerTap.listen((String id) {
          print("go to $id");
        });
        return controller;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('Ubicación'),
          ),
          body: Consumer<HomeController>(
            builder: (context, controller, loadingWidget) {
              if (controller.loading) {
                return loadingWidget!;
              }
              return Stack(children: [
                MapView(direccion: direccion),
                Container(
                    margin: EdgeInsets.all(5),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: ElevatedButton(
                            child: Text('¿Cómo llegar?'),
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                        margin: EdgeInsets.only(
                                            left: 5, top: 10, bottom: 10),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                    Text(
                                                        'Distancia aproximada: ${controller.distancia.toStringAsFixed(2)} km',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    Text(
                                                        'Tiempo aproximado: ${controller.tiempo.toStringAsFixed(2)}${controller.tiempo >= 60 ? 'hrs' : 'min'}',
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))
                                                  ])),
                                              Expanded(
                                                  child: Container(
                                                      margin: EdgeInsets.only(
                                                          right: 5),
                                                      child:
                                                          ElevatedButton.icon(
                                                              onPressed: () {
                                                                String urls =
                                                                    "${direccion?.latitud}, ${direccion?.longitud}";
                                                                googleMaps(
                                                                    urls);
                                                              },
                                                              icon: Icon(Icons
                                                                  .open_in_new),
                                                              label: Text(
                                                                  'Visualizar ruta'))))
                                            ]));
                                  });
                            })))
              ]);
            },
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )),
    );
  }

  Future<void> googleMaps(@required urls) async {
    String url() {
      if (Platform.isIOS) {
        return Uri.encodeFull("https://maps.apple.com/?q=$urls");
      } else {
        return "google.navigation:q=$urls";
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else if (!await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }
}
