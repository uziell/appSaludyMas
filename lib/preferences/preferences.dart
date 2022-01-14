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

  bool get logIn => this.prefs!.getBool('logIn') ?? false;

  set logIn(bool value) {
    this.prefs?.setBool('logIn', value);
  }

  /// Getter para obtener el usuario autenticado */

  String get nombre => this.prefs!.getString('nombre') ?? '';
  set nombre(String nombre) {
    this.prefs!.setString('nombre', nombre);
  }

  String get paterno => this.prefs!.getString('paterno') ?? '';
  set paterno(String paterno) {
    this.prefs!.setString('paterno', paterno);
  }

  //Metodo para limpiar todas las preferencias
  Future<bool> clear() async {
    var r = await prefs!.clear();
    return r;
  }
}
