

class ModeloMedicoClinicas{
  String idcliente;
  String nombre;
  String? descripcion_espe;
  String? telefono1;
  String? telefono2;
  String? telefono_emergencias;
  String? facebook;
  String? instagram;
  String? twitter;
  String? e_mail;
  String? horario;
  String? whatsapp;
  String? pagina_web;
  String? datos_extra;
  String? estatus;
  String? serviciosNombre;
  String? clinicasyhospitales_idclinicasyhospitales;
  String? direccion;
  String?  imagenName;

  ModeloMedicoClinicas(
      this.idcliente,
      this.nombre,
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
      this.estatus,
      this.serviciosNombre,
      this.clinicasyhospitales_idclinicasyhospitales,
      this.direccion,
      this.imagenName);



  /*ModeloMedicoClinicas.fromJson(Map<String, dynamic> json)
      : idcliente = json['idcliente'],
        nombre = json['nombre'],
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
        estatus = json['estatus'],
        serviciosNombre =  json['serviciosNombre'],
        clinicasyhospitales_idclinicasyhospitales = json['clinicasyhospitales_idclinicasyhospitales'],
        direccion = json['direccion'],
        imagenName = json['imagenName'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idcliente'] = idcliente;
    data['nombre'] = this.nombre;
    data['clinicasyhospitales_idclinicasyhospitales'] = this.clinicasyhospitales_idclinicasyhospitales;
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
    data['estatus'] = this.estatus;
    data['clinicasyhospitales_idclinicasyhospitales'] = this.clinicasyhospitales_idclinicasyhospitales;
    data['direccion'] = this.direccion;
    return data;
  }*/
}