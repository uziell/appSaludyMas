
class ModeloInfomacionClientesMedicos{
  final String idcliente;
  final String? descripcion_espe;
  final String? telefono1;
  final String? telefono2;
  final String? telefono_emergencias;
  final String? facebook;
  final String? instagram;
  final String? twitter;
  final String? e_mail;
  final String? horario;
  final String? whatsapp;
  final String? pagina_web;
  final String? datos_extra;
  final String? direccion;
  final String? tipoCedula;
  final String? cedula;
  final String? escuela;
  final String? nombre;

  ModeloInfomacionClientesMedicos(
      this.idcliente,
      this.descripcion_espe,
      this.telefono1,
      this.telefono2,
      this.telefono_emergencias,
      this.facebook,
      this.instagram,
      this.twitter,
      this.e_mail,
      this.horario,
      this.whatsapp,
      this.pagina_web,
      this.datos_extra,
      this.direccion,
      this.tipoCedula,
      this.cedula,
      this.escuela,
      this.nombre);


  ModeloInfomacionClientesMedicos.fromJson(Map<String, dynamic> json)
      : idcliente = json['idcliente'],
        descripcion_espe = json['descripcion_espe'],
        telefono1 = json['telefono1'],
        telefono2 = json['telefono2'],
        telefono_emergencias = json['telefono_emergencias'],
        facebook = json['facebook'],
        instagram = json['instagram'],
        twitter = json['twitter'],
        e_mail = json['e_mail'],
        horario = json['horario'],
        whatsapp = json['whatsapp'],
        pagina_web = json['pagina_web'],
        datos_extra = json['datos_extra'],
        direccion = json['direccion'],
        tipoCedula = json['tipoCedula'],
        cedula = json['cedula'],
        escuela = json['escuela'],
        nombre = json['nombre'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idcliente'] = idcliente;
    data['descripcion_espe'] = this.descripcion_espe;
    data['telefono1'] = this.telefono1;
    data['telefono2'] = this.telefono2;
    data['telefono_emergencias'] = this.telefono_emergencias;
    data['facebook'] = this.facebook;
    data['instagram'] = this.instagram;
    data['e_mail'] = this.e_mail;
    data['horario'] = this.horario;
    data['whatsapp'] = this.whatsapp;
    data['pagina_web'] = this.pagina_web;
    data['datos_extra'] = this.datos_extra;
    data['direccion'] = this.direccion;
    data['tipoCedula'] = this.tipoCedula;
    data['cedula'] = this.cedula;
    data['escuela'] = this.escuela;
    data['nombre'] = this.nombre;

    return data;
  }
}