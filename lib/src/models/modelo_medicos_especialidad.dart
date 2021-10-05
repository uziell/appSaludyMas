import 'package:salud_y_mas/src/models/modeloEspecialidades.dart';

class ModeloMedicosEspecialidad {
  
  final String idcliente;
  final String nombre;
  final String? imagenName;
  final String? especialidad_idespecialidad;
  final String? cliente_idcliente;
  final String? ciudad_has_categoria_ciudad_idciudad;
  final String? ciudad_has_categoria_ciudad_estado_idestado;
  final String? ciudad_has_categoria_categoria_idcategoria;

  ModeloMedicosEspecialidad(this.idcliente,this.nombre,this.imagenName,
  this.especialidad_idespecialidad,this.cliente_idcliente,this.ciudad_has_categoria_ciudad_idciudad,
  this.ciudad_has_categoria_ciudad_estado_idestado,this.ciudad_has_categoria_categoria_idcategoria);

}