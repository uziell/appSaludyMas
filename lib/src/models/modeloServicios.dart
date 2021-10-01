

class ModeloServicios{
  final String? idcliente;
  final String? idservicios;
  final String? nombre;
  final String? descripcion;
  final double? costo;
  final String? cliente_idcliente;

  ModeloServicios(this.idcliente, this.idservicios, this.nombre,
      this.descripcion, this.costo, this.cliente_idcliente);

  /*ModeloServicios.fromJson(Map<String, dynamic>json)
     : idcliente = json['idcliente'],
       idservicios = json['idservicios'],
       nombre = json['nombre'],
       descripcion = json['descripcion'],
       costo = json['costo'],
       cliente_idcliente = json['cliente_idcliente'];*/
}