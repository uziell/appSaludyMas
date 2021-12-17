import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' show ChangeNotifier, ImageConfiguration, Offset;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:salud_y_mas/apps/helpers/image_to_bytes.dart';
import 'package:salud_y_mas/apps/ui/utils/map_style.dart';

class HomeController extends ChangeNotifier{

  final Map<MarkerId,Marker> _markers = {};
  final Map<PolylineId,Polyline> _polylies = {};
  final Map<PolygonId,Polygon> _polygons = {};
  Set<Marker> get markers => _markers.values.toSet();
  Set<Polyline> get polylies => _polylies.values.toSet();
  Set<Polygon> get polygons => _polygons.values.toSet();

  late BitmapDescriptor _cardPin;

  final _markersController = StreamController<String >.broadcast();
  Stream<String> get onMarkerTap => _markersController.stream;

  Position? _initialPosition, _lastPosition;
  Position? get initialPosition =>_initialPosition;


 bool _loading = true;
 bool get loading => _loading;

 late bool _gpsEnable;
 bool get gpsEnable => _gpsEnable;
 StreamSubscription? _gpssubscription,_positionsubscription;
 GoogleMapController? _mapController;

 String _polylineId= '0';
  String _polygonId= '0';

 HomeController(){
   _init();
  }


  Future<void> _init() async{
  _cardPin = BitmapDescriptor.fromBytes(await imageToBytes('assets/cards.png', witdh: 60),

  );
  _gpsEnable = await Geolocator.isLocationServiceEnabled();
  _loading=false;
  _gpssubscription = Geolocator.getServiceStatusStream().listen((status) async{
    _gpsEnable =status == ServiceStatus.enabled;
    if(_gpsEnable) {
      _initLocationUpdate();
    }
   });
  _initLocationUpdate();

  }

   Future<void>  _initLocationUpdate() async{
    bool _initialized = false;
    await _positionsubscription?.cancel();
   _positionsubscription = Geolocator.getPositionStream().listen((position) async {
     _setMyPositionMarker(position);
     if(_initialized){
       notifyListeners();
     }
     if(!_initialized) {
       _setInitialPosition(position);
       _initialized = true;
       notifyListeners();
     }


     if(_mapController!=null){
       final zoom = await _mapController!.getZoomLevel();
       final cameraUpdate = CameraUpdate.newLatLngZoom(
           LatLng(position.latitude, position.longitude),
           zoom,
       );
       _mapController!.animateCamera(cameraUpdate);
     }

   },
     onError: (e){
     print("Erroor....");
     if(e is LocationServiceDisabledException){
       _gpsEnable = false;
       notifyListeners();
     }
     }
   );

  }
   void _setInitialPosition(Position position) {
    if(_gpsEnable && _initialPosition ==null){
     // _initialPosition = await Geolocator.getLastKnownPosition();
      _initialPosition = position;
    }
  }

  void _setMyPositionMarker(Position position){
   double rotation = 0;
   if(_lastPosition != null){
     rotation = Geolocator.bearingBetween(_lastPosition!.latitude, _lastPosition!.longitude,
         position.latitude, position.longitude);
   }
   const MarkerId markerId = MarkerId('my-position');
   final marker = Marker(markerId: markerId,
   position: LatLng(position.latitude, position.longitude),
     icon: _cardPin,
     anchor: const Offset(0.5,0.5),
     rotation: rotation,
   );
   _markers[markerId] = marker;
   _lastPosition = position;
  }
  void onMapCreated(GoogleMapController controller){
    controller.setMapStyle(mapSatyle);
    _mapController = controller;
  }

  Future<void> turnGPS() => Geolocator.openLocationSettings();

 void newPolyline(){
   _polylineId = DateTime.now().microsecondsSinceEpoch.toString();
 }
  void newPolygon(){
    _polylineId = DateTime.now().microsecondsSinceEpoch.toString();
  }


  void onTap(LatLng position) async {
   final PolylineId polylineId = PolylineId(_polylineId);
   late Polyline polyline;
   if(_polylies.containsKey(polylineId)){
     final tmp = _polylies[polylineId]!;
     polyline =tmp.copyWith(pointsParam: [...tmp.points,position]);
   }else{
     final color = Colors.primaries[_polylies.length];
     polyline = Polyline(
       polylineId: polylineId,
       points: [position],
       width: 5,
       color: color,
       startCap: Cap.roundCap,
       endCap: Cap.roundCap,
     );

   }
   _polylies[polylineId] = polyline;
   notifyListeners();

  }


  @override
  void dispose() {
    // TODO: implement dispose
    _positionsubscription?.cancel();
    _gpssubscription?.cancel();
    _markersController.close();
    super.dispose();
  }
}