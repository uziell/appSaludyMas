

class ModeloCedulas{
  final String? idcliente;
  final String? idcedula;
  final String? tipoCedula;
  final String? cedula;
  final String? escuela;
  final String? cliente_idcliente;


  ModeloCedulas(this.idcliente, this.idcedula, this.tipoCedula, this.cedula,
      this.escuela, this.cliente_idcliente);

  ModeloCedulas.fromJson(Map<String, dynamic> json)
      : idcliente = json['idcliente'],
        idcedula = json['idcedula'],
        tipoCedula = json['tipoCedula'],
        cedula = json['cedula'],
        escuela = json['escuela'],
        cliente_idcliente = json['cliente_idcliente'];

 /* Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idcliente'] = idcliente;
    data['idcedula'] = this.idcedula;
    data['tipoCedula'] = this.tipoCedula;
    data['cedula'] = this.cedula;
    data['escuela'] = this.escuela;
    data['cliente_idcliente'] = this.cliente_idcliente;


    return data;
  }*/
}