import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:salud_y_mas/apps/ui/pages/home/home_crontroller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:salud_y_mas/apps/ui/utils/map_style.dart';
import 'package:salud_y_mas/src/models/modeloDireccion.dart';

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
    _cameraPosition = CameraPosition(
      target: LatLng(double.parse("0"), double.parse("0")),
      zoom: 14,
    );
    print("coordenadas");

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
    return Scaffold(
        body: GoogleMap(
      onMapCreated: onMapCreated,

      initialCameraPosition: _cameraPosition,
      myLocationButtonEnabled: true,
      myLocationEnabled: true,

      // onTap: controller.onTap,
    ));
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
