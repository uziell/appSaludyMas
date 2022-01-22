import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:salud_y_mas/apps/helpers/image_to_bytes.dart';
import 'package:salud_y_mas/apps/ui/utils/map_style.dart';
import 'package:salud_y_mas/src/models/modeloDireccion.dart';
import 'dart:math';
import 'package:http/http.dart' as http;

class HomeController extends ChangeNotifier {
  final Map<MarkerId, Marker> _markers = {};
  final Map<PolylineId, Polyline> _polylies = {};
  final Map<PolygonId, Polygon> _polygons = {};
  Set<Marker> get markers => _markers.values.toSet();
  Set<Polyline> get polylies => _polylies.values.toSet();
  Set<Polygon> get polygons => _polygons.values.toSet();

  late BitmapDescriptor _cardPin;

  final _markersController = StreamController<String>.broadcast();
  Stream<String> get onMarkerTap => _markersController.stream;

  Position? _initialPosition, _lastPosition;
  Position? get initialPosition => _initialPosition;

  bool _loading = true;
  bool get loading => _loading;

  late bool _gpsEnable = false;
  bool get gpsEnable => _gpsEnable;
  StreamSubscription? _gpssubscription, _positionsubscription;
  GoogleMapController? _mapController;

  String _polylineId = '0';
  String _polygonId = '0';
  double _distancia = 0;
  double get distancia => _distancia;
  double _tiempo = 0;
  double get tiempo => _tiempo;

  String _tiempoLabel  = "";
  String get tiempoLabel => _tiempoLabel;

  HomeController(String? latitudDestino, String? longitudDestino, ModeloDireccion? direccion) {
    _init(latitudDestino, longitudDestino, direccion);
  }

  Future<void> _init(latitudDestino, longitudDestino, direccion) async {
    _cardPin = BitmapDescriptor.fromBytes(
      await imageToBytes('assets/cards.png', witdh: 60),
    );
    _gpsEnable = await Geolocator.isLocationServiceEnabled();
    _loading = false;
    notifyListeners();
    _gpssubscription = Geolocator.getServiceStatusStream().listen((status) async {
      _gpsEnable = status == ServiceStatus.enabled;
      if (_gpsEnable) {
        _initLocationUpdate(latitudDestino, longitudDestino, direccion);
      }
    });
    _initLocationUpdate(latitudDestino, longitudDestino, direccion);
  }

  verificarPermisos() async {
    print("verificar permisos");
    //Verifico si aceptó o no los permisos
    final status = await permission.Permission.location.isGranted;

    if (status) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _initLocationUpdate(latitudDestino, longitudDestino, direccion) async {
    bool resultPermisos = await this.verificarPermisos();

    if (!resultPermisos) {
      permission.Permission.location.request();
      return;
    }
    bool _initialized = false;
    await _positionsubscription?.cancel();

    var position = await Geolocator.getCurrentPosition();
    // _positionsubscription = Geolocator.getPositionStream().((position) async {
    _setMyPositionMarker(position, latitudDestino, longitudDestino, direccion);

    if (!_initialized) {
      _setInitialPosition(position);
      _initialized = true;
      notifyListeners();
    }

    if (_mapController != null) {
      final zoom = await _mapController!.getZoomLevel();
      final cameraUpdate = CameraUpdate.newLatLngZoom(
        LatLng(position.latitude, position.longitude),
        zoom,
      );
      _mapController!.animateCamera(cameraUpdate);
    }
  }

  void _setInitialPosition(Position position) {
    if (_gpsEnable && _initialPosition == null) {
      // _initialPosition = await Geolocator.getLastKnownPosition();
      _initialPosition = position;
    }
  }

  void _setMyPositionMarker(Position position, latitudDestino, longitudDestino, ModeloDireccion? direccion) async {
    double rotation = 0;
    if (_lastPosition != null) {
      rotation = Geolocator.bearingBetween(_lastPosition!.latitude, _lastPosition!.longitude, position.latitude, position.longitude);
    }
    print("position");
    print(position);
    const MarkerId markerId = MarkerId('my-position');
    final marker = Marker(
        markerId: markerId,
        position: LatLng(double.parse(latitudDestino), double.parse(longitudDestino)),
        anchor: const Offset(0.5, 0.5),
        rotation: rotation,
        infoWindow: InfoWindow(title: 'Dirección', snippet: '${direccion?.direccion}'));
    _markers[markerId] = marker;
    _lastPosition = position;

    // _distancia = Geolocator.distanceBetween(position.latitude, position.longitude, double.parse(latitudDestino), double.parse(longitudDestino));
    // _distancia = calcularDistancia(position.latitude, position.longitude, double.parse(latitudDestino), double.parse(longitudDestino));

    var objDis = await obtenerDistanciaTiempoMapbox(position.latitude, position.longitude, double.parse(latitudDestino), double.parse(longitudDestino));


    print("distance");
    _distancia = objDis['routes'][0]['distance'] / 1000;
    _tiempo = objDis['routes'][0]['duration'] / 60;

  

    print("geometry");
    print(objDis['routes'][0]['geometry']['coordinates']);

    List coordenadas = objDis['routes'][0]['geometry']['coordinates'];

    if (_tiempo >= 60) {
      _tiempo = _tiempo / 60;
    }

    List<String> _tiempoTemp =_tiempo.toStringAsFixed(2).split('.');

    _tiempoLabel ="${_tiempoTemp[0]}:${_tiempoTemp[1]}";

  

    List<LatLng> puntos = [];

    for (int i = 0; i < coordenadas.length; i++) {
      var latitudSplit = coordenadas[i].toString().split(',');
      var longitudSplit = coordenadas[i].toString().split(',');

      var latitud = latitudSplit[1].split(']');
      var longitud = longitudSplit[0].split('[');
      print("primer split");
      print("${latitud[0]}");
      print("${longitud[1]}");

      puntos.add(LatLng(double.parse(latitud[0].toString()), double.parse(longitud[1].toString())));
    }
    onTap(position, latitudDestino, longitudDestino, puntos);
  }

  obtenerDistanciaTiempoMapbox(latitud, longitud, latitudDestino, longitudDestino) async {
    final urlApi = Uri.parse(
        "https://api.mapbox.com/directions/v5/mapbox/driving/$longitud,$latitud;$longitudDestino,$latitudDestino?geometries=geojson&access_token=pk.eyJ1IjoidXppZWxsIiwiYSI6ImNreGdzdTBrNjAxMzUydm84cGVuYjhsdTIifQ.NV5w6a3syc4AwKQ-V4FKDQ");
    var response = await http.get(urlApi);
    var resp = json.decode(response.body);

    return resp;
  }

  double calcularDistancia(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(mapSatyle);

    _mapController = controller;
  }

  Future<void> turnGPS() => Geolocator.openLocationSettings();

  void newPolyline() {
    _polylineId = DateTime.now().microsecondsSinceEpoch.toString();
  }

  void newPolygon() {
    print("pol");
    _polylineId = DateTime.now().microsecondsSinceEpoch.toString();
  }

  void onTap(Position position, String latitudDestino, String longitudDestino, List<LatLng> puntos) async {
    final PolylineId polylineId = PolylineId(_polylineId);
    late Polyline polyline;
    if (_polylies.containsKey(polylineId)) {
      final tmp = _polylies[polylineId]!;
      polyline = tmp.copyWith(pointsParam: [
        LatLng(position.latitude, position.longitude),
        LatLng(double.parse(latitudDestino), double.parse(longitudDestino)),
      ]);
    } else {
      final color = Colors.primaries[_polylies.length];
      polyline = Polyline(
        geodesic: true,
        visible: true,
        polylineId: polylineId,
        points: puntos,
        width: 5,
        color: Colors.blue,
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
