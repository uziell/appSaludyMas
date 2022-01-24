import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:salud_y_mas/preferences/preferences.dart';

class NotificacionesRequest {

  AppPreferences _prefs = AppPreferences();
   Future<dynamic> obtenerNotificaciones() async {
    http.Response response = await http.get(Uri.parse('https://www.salumas.com/Salud_Y_Mas_Api/consultaNotificaciones?nombre_estado=${_prefs.estado}'));

    if (response.statusCode != 200) throw Exception('Error del servidor');

    return json.decode(response.body);
  }

  static Future<dynamic> cambiarEstatusNotificacion(notificacionId) async {
    Map jsonData = {'idNotificacion': notificacionId};

    print(jsonData);
    http.Response response = await http.post(Uri.parse('https://www.salumas.com/Salud_Y_Mas_Api/updateStatusNotificacion'), body: json.encode(jsonData));

    if (response.statusCode != 200) throw Exception('Error del servidor');

    return json.decode(response.body);
  }

   Future<dynamic> registrarNotificacion(titulo, mensaje) async {
    Map jsonData = {'titulo': titulo, 'mensaje': mensaje, 'nombre_estado': _prefs.estado};
    http.Response response = await http.post(Uri.parse('https://www.salumas.com/Salud_Y_Mas_Api/registrarNotificacion'), body: json.encode(jsonData));

    if (response.statusCode != 200) throw Exception('Error del servidor');

    return json.decode(response.body);
  }
}
