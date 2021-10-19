


class IdFarmaciasDelAhorro{

  String? cliente_idcliente;

  IdFarmaciasDelAhorro(this.cliente_idcliente);

  IdFarmaciasDelAhorro.fromJson(Map<String, dynamic> json)
      : cliente_idcliente = json['cliente_idcliente'];
}