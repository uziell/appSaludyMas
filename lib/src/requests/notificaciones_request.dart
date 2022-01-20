import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificacionesRequest {
  static Future<dynamic> obtenerNotificaciones() async {
    http.Response response = await http.get(Uri.parse('https://www.salumas.com/Salud_Y_Mas_Api/consultaNotificaciones'));

    if (response.statusCode != 200) throw Exception('Error del servidor');

    return json.decode(response.body);
  }

  static Future<dynamic> cambiarEstatusNotificacion(notificacionId) async {
    Map jsonData = {'notificacionId': notificacionId};

    print(jsonData);
    http.Response response = await http.post(Uri.parse('https://www.salumas.com/Salud_Y_Mas_Api/updateStatusNotificacion'), body: jsonData);

    if (response.statusCode != 200) throw Exception('Error del servidor');

    return json.decode(response.body);
  }

  static Future<dynamic> registrarNotificacion(titulo, mensaje) async {
    Map jsonData = {'titulo': titulo, 'mensaje': mensaje};
    http.Response response = await http.post(Uri.parse('https://www.salumas.com/Salud_Y_Mas_Api/registrarNotificacion'), body: json.encode(jsonData));

    if (response.statusCode != 200) throw Exception('Error del servidor');

    return json.decode(response.body);
  }
}
