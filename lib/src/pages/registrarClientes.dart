import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:salud_y_mas/src/pages/login_page.dart';
import 'package:salud_y_mas/src/widgtes/pdf.dart';

class RegistrarUsuarios extends StatefulWidget {
  const RegistrarUsuarios({Key? key}) : super(key: key);

  @override
  _RegistrarUsuariosState createState() => _RegistrarUsuariosState();
}

class _RegistrarUsuariosState extends State<RegistrarUsuarios> {
  final _formKey = GlobalKey<FormState>();
  String urlApi = 'https://www.salumas.com/Salud_Y_Mas_Api/';

  //VARIBLE PARA ALMACENAR LOS DATOS DEL JSON DE CONSULTAR ESTADOS
  List<dynamic> nombreEdo = [];
  bool _cargando = false;
  String vistaEstado = "Seleccione Un Estado";
  String vistaCiudad = 'Seleccione la ciudad';
  List<dynamic> nombreCd = [];
  String? nombres, apaterno, amaterno, usuario, pass, idestado, idciudad;
  int res = 0;
  bool? loading = false;
  bool isTerminos = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    consultarAPIEstados().then((resultado) {
      setState(() {
        //  this._cargando = true;
      });
    });
  }

  Future<List<dynamic>> consultarAPIEstados() async {
    final url = Uri.parse(urlApi + 'consultas_edo.php');
    var response = await http.get(url);
    nombreEdo = json.decode(response.body);
    return nombreEdo;
  }

  Future consultarAPICiudades(String nameEdo) async {
    final url = Uri.parse(urlApi + 'consultas_cd?nameEdo=' + nameEdo);
    var response = await http.get(url);
    nombreCd = json.decode(response.body);
    return nombreCd;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.7), BlendMode.dstATop),
              image: AssetImage('assets/fondoPrincipal.jpg'),
              fit: BoxFit.cover,
              //colorFilter: ColorFilter.mode(Colors.white,)
            ),
          ),
        ),
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.teal,
            title: Text('Registro de usuarios'),
          ),
          backgroundColor: Colors.transparent,
          body: Center(
            child: SingleChildScrollView(
              child: Form(key: _formKey, child: principal()),
            ),
          ),
        ),
      ],
    );
  }

  _textFieldNombre() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: TextFormField(
          validator: (value) {
            if (value!.trim().isEmpty) {
              return "El campo nombre está vacío";
            }

            return null;
          },
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              hintText: ("Nombre(s) * "),
              labelText: 'Nombre(s) *',
              fillColor: Colors.blue,
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ))),
          onChanged: (value) {
            nombres = value.toString();
          },
        ),
      );
    });
  }

  _textFieldApellidoPate() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: TextFormField(
          validator: (value) {
            if (value!.trim().isEmpty) {
              return "El campo apellido paterno está vacío";
            }

            return null;
          },
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              hintText: ("Apellido Paterno *"),
              labelText: 'Apellido Paterno *',
              fillColor: Colors.blue,
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ))),
          onChanged: (value) {
            apaterno = value.toString();
          },
        ),
      );
    });
  }

  _textFieldApellidoMate() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: TextFormField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              hintText: ("Apellido materno"),
              labelText: 'Apellido materno',
              fillColor: Colors.blue,
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ))),
          onChanged: (value) {
            amaterno = value.toString();
          },
        ),
      );
    });
  }

  dropdownEstados() {
    return Container(
      color: Colors.white,
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: DropdownButtonFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
        items: nombreEdo.map((ciudadC) {
          return DropdownMenuItem(
            value: ciudadC['nombre'],
            child: Text(ciudadC['nombre']),
          );
        }).toList(),
        iconSize: 20,
        icon: Icon(Icons.arrow_drop_down, color: Colors.white),
        onChanged: (_EstadoActual) {
          setState(() {
            vistaEstado = _EstadoActual.toString();
            // idciudad = _EstadoActual[0]['']
            idestado = vistaEstado.toString();

            consultarAPICiudades(vistaEstado).then((value) {
              setState(() {
                print(value);
                idciudad = value[0]['idciudad'];
                vistaCiudad = value[0]['nombre'];
              });
            });
          });
        },
        hint: Text(
          vistaEstado,
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
    );
  }

  dropdownCiudad() {
    return Container(
      color: Colors.white,
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: DropdownButtonFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
        items: nombreCd.map((ciudadC) {
          return DropdownMenuItem(
            value: ciudadC['idciudad'].toString(),
            child: Text(ciudadC['nombre'].toString()),
          );
        }).toList(),
        iconSize: 20,
        icon: Icon(Icons.arrow_drop_down, color: Colors.white),
        onChanged: (_ciudadActual) {
          setState(() {
            vistaCiudad = _ciudadActual.toString();
            //  print('nombre de la ciudad: '+vistaCiudad.toString());
            idciudad = vistaCiudad.toString();
          });
        },
        hint: Text(
          vistaCiudad,
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
    );
  }

  buttonRegistrase() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
          width: 400,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0)),
                  primary: Colors.teal,
                  textStyle: TextStyle(
                    color: Colors.white,
                  )),
              child: !loading!
                  ? Text("Registrarse")
                  : SizedBox(
                      child: CircularProgressIndicator(color: Colors.white),
                      height: 20.0,
                      width: 20.0,
                    ),
              onPressed: () async {
            
                //Esto es para verificar que esten bien todos tus inputs

                if (idestado == null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Seleccione un estado'),
                      backgroundColor: Colors.red));
                  return;
                }

                if (idciudad == null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Seleccione una ciudad'),
                      backgroundColor: Colors.red));
                  return;
                }

                if (isTerminos == false) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'Debe de marcar los términos y condiciones para poder continuar'),
                      backgroundColor: Colors.red));
                  return;
                }
                if (_formKey.currentState!.validate()) {
                  this.setState(() {
                    this.loading = true;
                  });
                  await insertarUsuario();

                  this.setState(() {
                    this.loading = false;
                  });
                  if (res != 0) {
                    Navigator.of(context).push(MaterialPageRoute<Null>(
                        builder: (BuildContext context) {
                      return LoginPage();
                    }));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Hubo un problema al registrarse'),
                        backgroundColor: Colors.red));
                  }
                }
              }));
    });
  }

  principal() {
    final card = Container(
      width: MediaQuery.of(context).size.width,
      // clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // SizedBox(
          //   height: 50.0,
          // ),
          // Text(
          //   "Registrarse",
          //   style: GoogleFonts.montserrat(
          //       fontSize: 24, color: Colors.blue, fontWeight: FontWeight.bold),
          // ),
          SizedBox(
            height: 20.0,
          ),
          _textFieldNombre(),
          SizedBox(
            height: 10.0,
          ),
          _textFieldApellidoPate(),
          SizedBox(
            height: 10.0,
          ),
          _textFieldApellidoMate(),
          SizedBox(
            height: 10.0,
          ),
          dropdownEstados(),
          SizedBox(
            height: 10.0,
          ),
          idestado != null
              ? Column(children: [
                  dropdownCiudad(),
                  SizedBox(
                    height: 10.0,
                  ),
                ])
              : Container(),

          _textFieldUsuarios(),
          SizedBox(
            height: 10.0,
          ),
          _textFielPass(),
          SizedBox(
            height: 10.0,
          ),
          _avisoPrivacidad(),
          buttonRegistrase(),
          SizedBox(height: 15)
        ],
      ),
    );

    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            spreadRadius: 2.0,
            offset: Offset(2.0, -10.0),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: card,
      ),
    );
  }

  Widget _avisoPrivacidad() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
            value: isTerminos,
            onChanged: (v) {
              setState(() {
                isTerminos = v!;
              });
            }),
        GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Pdf()),
              );
            },
            child: Text('Ver términos y condiciones',
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold)))
      ],
    );
  }

  _textFieldUsuarios() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: TextFormField(
          validator: (value) {
            if (value!.trim().isEmpty) {
              return "El campo usuario está vacío";
            }

            return null;
          },
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              hintText: ("Usuario *"),
              labelText: 'Usuario * ',
              fillColor: Colors.blue,
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ))),
          onChanged: (value) {
            usuario = value.toString();
          },
        ),
      );
    });
  }

  _textFielPass() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: TextFormField(
          validator: (value) {
            if (value!.trim().isEmpty) {
              return "El campo contraseña está vacío";
            }

            return null;
          },
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              hintText: ("Password *"),
              labelText: 'Password',
              fillColor: Colors.blue,
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ))),
          onChanged: (value) {
            pass = value.toString();
          },
        ),
      );
    });
  }

  insertarUsuario() async {
    final url = Uri.parse(urlApi + 'registrar_usuarios');
    var response = await http.post(url,
        body: "{" +
            "\"nombre\":\"" +
            nombres.toString() +
            "\"" +
            "," +
            "\"paterno\":\"" +
            apaterno.toString() +
            "\"" +
            "," +
            "\"materno\":\"" +
            amaterno.toString() +
            "\"" +
            "," +
            "\"estado_idestado\":\"" +
            idestado.toString() +
            "\"" +
            "," +
            "\"idciudad\":\"" +
            idciudad.toString() +
            "\"" +
            "," +
            "\"usuario\":\"" +
            usuario.toString() +
            "\"" +
            "," +
            "\"pass\":\"" +
            pass.toString() +
            "\"}");

    res = int.parse(response.body);
    print(response.body);
  }
}
