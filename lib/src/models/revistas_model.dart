class Revistas {
  final String? id;
  final String? estadoRevista;
  final String? linkRevista;
  final String? linkPortada;
  final String? fechaHora;
  Revistas({this.id, this.estadoRevista, this.linkRevista, this.fechaHora, this.linkPortada});

  Revistas.fromJson(Map<String, dynamic> json)
      : id = json['idNotificacion'],
        estadoRevista = json['estado_revista'],
        linkRevista = json['link_revista'],
        fechaHora = json['feha_hora'],
        linkPortada = json['link_portada'];

  static List<Revistas> toJsonList(List<dynamic> lista) {
    List<Revistas> n = [];
    for (Map<String, dynamic> data in lista) {
      n.add(Revistas.fromJson(data));
    }
    return n;
  }
}
