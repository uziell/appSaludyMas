class Notificaciones {
  final int? id;
  final String? titulo;
  final String? descripcion;
  final String? fechaHora;

  Notificaciones({this.id, this.titulo, this.descripcion, this.fechaHora});

  Notificaciones.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        titulo = json['titulo'],
        descripcion = json['descripcion'],
        fechaHora = json['fechaHora'];

  static List<Notificaciones> toJsonList(List<dynamic> lista) {
    List<Notificaciones> n = [];
    for (Map<String, dynamic> data in lista) {
      n.add(Notificaciones.fromJson(data));
    }
    return n;
  }
}
