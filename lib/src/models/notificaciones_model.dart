class Notificaciones {
  final String? id;
  final String? titulo;
  final String? descripcion;
  final String? fechaHora;
  final String? estadoNot;

  Notificaciones({this.id, this.titulo, this.descripcion, this.fechaHora, this.estadoNot});

  Notificaciones.fromJson(Map<String, dynamic> json)
      : id = json['idNotificacion'],
        titulo = json['titulo'],
        descripcion = json['mensaje'],
        estadoNot = json['estadoNot'],
        fechaHora = json['fechaHora'];

  static List<Notificaciones> toJsonList(List<dynamic> lista) {
    List<Notificaciones> n = [];
    for (Map<String, dynamic> data in lista) {
      n.add(Notificaciones.fromJson(data));
    }
    return n;
  }
}
