import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:salud_y_mas/apps/ui/pages/home/home_crontroller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:salud_y_mas/apps/ui/utils/map_style.dart';
import 'package:salud_y_mas/src/models/modeloDireccion.dart';
import 'package:salud_y_mas/src/widgtes/appBarNotificaciones.dart';
import 'package:salud_y_mas/src/widgtes/menu.dart';

class UbicacionPage extends StatefulWidget {
  const UbicacionPage({Key? key}) : super(key: key);

  @override
  _UbicacionPageState createState() => _UbicacionPageState();
}

class _UbicacionPageState extends State<UbicacionPage> {
  bool verificarPermiso = false;
  double latitud = 0;
  double longitud = 0;
  CameraPosition _cameraPosition = CameraPosition(target: LatLng(0, 0));
  GoogleMapController? _mapController;
  bool isFinished = false;

  @override
  void initState() {
    print("hola");

    print("coordenadas");

    this.verificarPermisos();

    super.initState();
  }

  verificarPermisos() async {
    //Verifico si aceptó o no los permisos

    if (await Permission.location.isGranted) {
      Position position = await Geolocator.getCurrentPosition();

      print("position");
      print(position);

      _cameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 14,
      );

      setState(() {});

      verificarPermiso = true;
    } else {
      await Permission.location.request();

      verificarPermiso = false;
      verificarPermisos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MenuPage(),
        appBar: PreferredSize(preferredSize: Size.fromHeight(50.0), child: AppBarNotificaciones(titulo: 'Mi ubicación')),
        body: verificarPermiso
            ? GoogleMap(
                onMapCreated: onMapCreated,

                initialCameraPosition: _cameraPosition,
                myLocationButtonEnabled: true,
                myLocationEnabled: true,

                // onTap: controller.onTap,
              )
            : Center(child: CircularProgressIndicator()));
  }

  void onMapCreated(GoogleMapController controller) async {
    print("entra on created");
    controller.setMapStyle(mapSatyle);

    print("terminar on created");

    _mapController = controller;

    setState(() {
      isFinished = true;
    });
  }
}
