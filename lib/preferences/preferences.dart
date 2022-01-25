import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  SharedPreferences? prefs;

  AppPreferences._internal();
  static final AppPreferences _instancia = new AppPreferences._internal();

  factory AppPreferences() {
    return _instancia;
  }

  initPrefs() async {
    // ignore: invalid_use_of_visible_for_testing_member
    // SharedPreferences.setMockInitialValues({});
    WidgetsFlutterBinding.ensureInitialized();
    this.prefs = await SharedPreferences.getInstance();
  }

  /// Variable para ver si esta autenticado */

  /// Getter para obtener el usuario autenticado */

  String get nombre => this.prefs!.getString('nombre') ?? '';
  set nombre(String nombre) {
    this.prefs!.setString('nombre', nombre);
  }

  String get id => this.prefs!.getString('id') ?? '';
  set id(String id) {
    this.prefs!.setString('id', id);
  }

  String get paterno => this.prefs!.getString('paterno') ?? '';
  set paterno(String paterno) {
    this.prefs!.setString('paterno', paterno);
  }

  String get estado =>
      this.prefs!.getString('estado') ?? 'Seleccione el estado';
  set estado(String estado) {
    this.prefs!.setString('estado', estado);
  }

  //Metodo para limpiar todas las preferencias
  Future<bool> clear() async {
    var r = await prefs!.clear();
    return r;
  }
}
