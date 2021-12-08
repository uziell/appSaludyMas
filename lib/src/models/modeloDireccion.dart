class ModeloDireccion {
  final String idcliente;
  final String? direccion;

  ModeloDireccion(this.idcliente, this.direccion);

  ModeloDireccion.jsonFrom(Map<String, dynamic> json)
      : idcliente = json['idcliente'],
        direccion = json['direccion'];

  static List<ModeloDireccion> toListJson(List<dynamic> lista) {
    return lista.map((e) => ModeloDireccion.jsonFrom(e)).toList();
  }
}
