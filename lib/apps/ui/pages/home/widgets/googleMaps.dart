

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:salud_y_mas/apps/ui/pages/home/home_crontroller.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (_,controller,gpsMessageWidget){
        if(!controller.gpsEnable){
          return gpsMessageWidget!;
        }
        final initialCamaraPosition = CameraPosition(target:
        LatLng(
          controller.initialPosition!.latitude,
          controller.initialPosition!.longitude,
        ),
          zoom: 15,
        );
        return GoogleMap(
          onMapCreated: controller.onMapCreated,
         // polygons: controller.polygons,
          polylines: controller.polylies,
          initialCameraPosition: initialCamaraPosition,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          markers:controller.markers,
          onTap: controller.onTap,
        );
      },
      child: Center(
        child: Column(
          mainAxisSize:  MainAxisSize.min,
          children: [
            Text("PARA UTILIZAR LA APLICACION DEBE ENCENDER SU GPS"),
            ElevatedButton(
                onPressed: (){
                  final controller = context.read<HomeController>();
                  controller.turnGPS();
                },
                child: Text("Turn GPS")
            ),
          ],
        ),
      ),
    );
  }
}
