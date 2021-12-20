class ModeloDireccion {
  final String idcliente;
  final String? direccion;
  final String? latitud;
  final String? longitud;

  ModeloDireccion(this.idcliente, this.direccion, this.latitud, this.longitud);

  ModeloDireccion.jsonFrom(Map<String, dynamic> json)
      : idcliente = json['idcliente'],
        direccion = json['direccion'],
        latitud = json['Latitud'],
        longitud = json['Longitud'];

  static List<ModeloDireccion> toListJson(List<dynamic> lista) {
    return lista.map((e) => ModeloDireccion.jsonFrom(e)).toList();
  }
}
