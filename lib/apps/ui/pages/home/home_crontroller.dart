import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' show ChangeNotifier, ImageConfiguration, Offset;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:salud_y_mas/apps/helpers/image_to_bytes.dart';
import 'package:salud_y_mas/apps/ui/utils/map_style.dart';
import 'package:salud_y_mas/src/models/modeloDireccion.dart';

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

  HomeController(String? latitudDestino, String? longitudDestino, ModeloDireccion? direccion) {
    _init(latitudDestino, longitudDestino, direccion);
  }

  Future<void> _init(latitudDestino, longitudDestino, direccion) async {
    _cardPin = BitmapDescriptor.fromBytes(
      await imageToBytes('assets/cards.png', witdh: 60),
    );
    _gpsEnable = await Geolocator.isLocationServiceEnabled();
    _loading = false;
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
    final status = await permission.Permission.location.request();

    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _initLocationUpdate(latitudDestino, longitudDestino, direccion) async {
    bool resultPermisos = await this.verificarPermisos();

    if (!resultPermisos) {
      return;
    }
    bool _initialized = false;
    await _positionsubscription?.cancel();
    _positionsubscription = Geolocator.getPositionStream().listen((position) async {
      _setMyPositionMarker(position, latitudDestino, longitudDestino, direccion);
      if (_initialized) {
        notifyListeners();
      }
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
    }, onError: (e) {
      print("Erroor....");
      print(e);
      if (e is LocationServiceDisabledException) {
        _gpsEnable = false;
        notifyListeners();
      }
    });
  }

  void _setInitialPosition(Position position) {
    if (_gpsEnable && _initialPosition == null) {
      // _initialPosition = await Geolocator.getLastKnownPosition();
      _initialPosition = position;
    }
  }

  void _setMyPositionMarker(Position position, latitudDestino, longitudDestino, ModeloDireccion? direccion) {
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

    onTap(position, latitudDestino, longitudDestino);
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

  void onTap(Position position, String latitudDestino, String longitudDestino) async {
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
        visible: true,
        polylineId: polylineId,
        points: [LatLng(position.latitude, position.longitude), LatLng(double.parse(latitudDestino), double.parse(longitudDestino))],
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
