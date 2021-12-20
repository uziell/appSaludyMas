import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salud_y_mas/apps/ui/pages/home/home_crontroller.dart';
import 'package:salud_y_mas/apps/ui/pages/home/widgets/googleMaps.dart';
import 'package:salud_y_mas/src/models/modeloDireccion.dart';

class HomePageGoogle extends StatelessWidget {
  final ModeloDireccion? direccion;
  const HomePageGoogle({Key? key, this.direccion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeController>(
      create: (_) {
        final controller = HomeController(direccion?.latitud, direccion?.longitud, direccion);
        controller.onMarkerTap.listen((String id) {
          print("go to $id");
        });
        return controller;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('Ubicación'),
            actions: [
              Builder(
                builder: (context) => IconButton(
                    onPressed: () {
                      final controller = context.read<HomeController>();
                      controller.newPolygon();
                    },
                    icon: Icon(Icons.map)),
              ),
            ],
          ),
          body: Selector<HomeController, bool>(
            selector: (_, controller) => controller.loading,
            builder: (context, loading, loadingWidget) {
              if (loading) {
                return loadingWidget!;
              }
              return MapView(direccion: direccion);
            },
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )),
    );
  }
}
