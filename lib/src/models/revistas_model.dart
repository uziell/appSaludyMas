class Revistas {
  final String? id;
  final String? estadoRevista;
  final String? linkRevista;

  Revistas({this.id, this.estadoRevista, this.linkRevista});

  Revistas.fromJson(Map<String, dynamic> json)
      : id = json['idNotificacion'],
        estadoRevista = json['estado_revista'],
        linkRevista = json['link_revista'];

  static List<Revistas> toJsonList(List<dynamic> lista) {
    List<Revistas> n = [];
    for (Map<String, dynamic> data in lista) {
      n.add(Revistas.fromJson(data));
    }
    return n;
  }
}
