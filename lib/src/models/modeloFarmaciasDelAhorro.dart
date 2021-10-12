


class IdFarmaciasDelAhorro{

  String? idclie;

  IdFarmaciasDelAhorro(this.idclie);

  IdFarmaciasDelAhorro.fromJson(Map<String, dynamic> json)
      : idclie = json['idclie'];
}