import 'dart:convert';
import 'package:http/http.dart' as http;

class RevistasRequest {
  static Future<dynamic> obtenerRevistas() async {
    http.Response response = await http.get(Uri.parse('https://www.salumas.com/Salud_Y_Mas_Api/consultar_revistas.php'));

    if (response.statusCode != 200) throw Exception('Error del servidor');

    return json.decode(response.body);
  }
}
