import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:salud_y_mas/apps/ui/pages/home/home_crontroller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:salud_y_mas/src/models/modeloDireccion.dart';

class MapView extends StatefulWidget {
  final ModeloDireccion? direccion;
  const MapView({Key? key, this.direccion}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  bool verificarPermiso = false;
  @override
  void initState() {
    print("hola");

    print("coordenadas");

    print(widget.direccion?.latitud);
    print(widget.direccion?.longitud);
    //this.verificarPermisos();
    verificarPermiso = true;
    super.initState();
  }

  verificarPermisos() async {
    //Verifico si aceptó o no los permisos

    if (await Permission.location.isGranted) {
      verificarPermiso = true;
    } else {
      await Permission.location.request();

      verificarPermiso = false;
      verificarPermisos();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (_, controller, gpsMessageWidget) {
        if (!controller.gpsEnable) {
          return gpsMessageWidget!;
        }

        if (!verificarPermiso) {
          this.verificarPermisos();
        }
        final initialCamaraPosition = CameraPosition(
          target: LatLng(double.parse(widget.direccion!.latitud.toString()), double.parse(widget.direccion!.longitud.toString())),
          zoom: 14,
        );

        print("pasa por aqui");

        for (var c in controller.polylies) {
          print(c.points);
        }
        return widget.direccion!.latitud != 0 && widget.direccion!.longitud != 0
            ? GoogleMap(
                onMapCreated: controller.onMapCreated,
                // polygons: controller.polygons,
                polylines: controller.polylies,
                initialCameraPosition: initialCamaraPosition,
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                markers: controller.markers,
                // onTap: controller.onTap,
              )
            : Center(child: Text('Todavía no tiene la ubicación asignada'));
      },
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("PARA UTILIZAR LA APLICACION DEBE ENCENDER SU GPS"),
            ElevatedButton(
                onPressed: () {
                  final controller = context.read<HomeController>();
                  controller.turnGPS();
                },
                child: Text("Encender GPS")),
          ],
        ),
      ),
    );
  }
}
