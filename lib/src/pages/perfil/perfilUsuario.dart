import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:salud_y_mas/preferences/preferences.dart';
import 'package:salud_y_mas/src/pages/login_page.dart';
import 'package:salud_y_mas/src/widgtes/appBarNotificaciones.dart';
import 'package:salud_y_mas/src/widgtes/menu.dart';

class PerfilUsuario extends StatefulWidget {
  String? nombre;
  PerfilUsuario(this.nombre, {Key? key}) : super(key: key);

  @override
  _PerfilUsuarioState createState() => _PerfilUsuarioState();
}

class _PerfilUsuarioState extends State<PerfilUsuario> {
  final _formKey = GlobalKey<FormState>();
  AppPreferences prefs = AppPreferences();
  String urlApi = 'https://www.salumas.com/Salud_Y_Mas_Api/';
  List<dynamic> listaUsuarios = [];
  bool cargando = false;
  bool visibilty = false;
  TextEditingController? _controller;
  bool isUpdate = false;
  bool noEnable = false;
  bool? loading = false;
  bool resultadoAct= false;


  String? nombres, apaterno, amaterno, usuario, pass, idestado, idciudad;

  @override
  initState() {
    super.initState();
    print(widget.nombre.toString());
    consultarUsusarios(widget.nombre.toString()).then((value) {
      setState(() {
        this.cargando = true;
      });
    });
  }

  Future consultarUsusarios(String nombre) async {
    //final url = Uri.parse(urlApi + 'consultas_cd?nameEdo=' + nameEdo);
    final url = Uri.parse(urlApi + "consultaUsuarios?nombre=" + nombre);
    var response = await http.get(url);
    listaUsuarios = json.decode(response.body);
    print("lista de usuario" + listaUsuarios.toString());
    return listaUsuarios;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/fondoPrincipal.jpg'),
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.dstATop),
              //colorFilter: ColorFilter.mode(Colors.white,)
            ),
          ),
        ),
        Scaffold(
            appBar: PreferredSize(preferredSize: Size.fromHeight(50.0), child: AppBarNotificaciones(titulo: 'Mi perfil')),
            drawer: MenuPage(),
            backgroundColor: Colors.transparent,
            body: this.cargando
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        mostarUsuarios(),
                      ],
                    ),
                  )
                : Center(child: CircularProgressIndicator(color: Colors.white)))
      ],
    );
  }

  mostarUsuarios() {
    final card = Container(
      width: MediaQuery.of(context).size.width,
      // clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          SizedBox(
            height: 50.0,
          ),
          imagenSaludYMas(),
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
          _textFieldUsuarios(),
          SizedBox(
            height: 10.0,
          ),
          _textFielPass(),
          SizedBox(
            height: 10.0,
          ),
          _checkBoxActualizar(),
          _btonActualizar(),
          SizedBox(
            height: 10.0,
          ),
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

  _textFieldNombre() {
    return StreamBuilder(builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: TextFormField(
          controller: _controller = new TextEditingController(text: listaUsuarios[0]["nombre"]),
          keyboardType: TextInputType.text,
          enabled: noEnable,
          decoration: InputDecoration(
              fillColor: Colors.blue,
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ))),
          onChanged: (value) {

          },
        ),
      );
    });
  }

  _textFieldApellidoPate() {
    return StreamBuilder(builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: TextFormField(
          controller: _controller = new TextEditingController(text: listaUsuarios[0]["paterno"]),
          keyboardType: TextInputType.text,
          enabled: noEnable,
          decoration: InputDecoration(
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
    return StreamBuilder(builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: TextFormField(
          controller: _controller = new TextEditingController(text: listaUsuarios[0]["materno"]),
          keyboardType: TextInputType.text,
          enabled: noEnable,
          decoration: InputDecoration(
              labelText: listaUsuarios[0]["materno"],
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

  _textFieldUsuarios() {
    return StreamBuilder(builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: TextFormField(
          controller: _controller = new TextEditingController(text: listaUsuarios[0]["usuario"]),
          keyboardType: TextInputType.text,
          enabled: noEnable,
          decoration: InputDecoration(
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
    return StreamBuilder(builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: TextFormField(
          controller: _controller = new TextEditingController(text: listaUsuarios[0]["pass"]),
          obscureText: !visibilty,
          keyboardType: TextInputType.text,
          enabled: noEnable,
          decoration: InputDecoration(
              fillColor: Colors.blue,
              prefixIcon: Icon(Icons.person),
              suffixIcon: InkWell(
                onTap: () => setState(() => visibilty = !visibilty),
                child: Icon(!visibilty ? Icons.visibility : Icons.visibility_off),
              ),
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

  imagenSaludYMas() {
    return FadeInImage(
      height: 140,
      image: AssetImage('assets/Saludymas.png'),
      placeholder: AssetImage('assets/jar-loading.gif'),
      fadeInDuration: Duration(milliseconds: 200),
      //height: 230.0,
      fit: BoxFit.fill,
    );
  }

  _checkBoxActualizar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
            value: isUpdate,
            onChanged: (v) {
              setState(() {
                isUpdate = v!;
                if (isUpdate) {
                  noEnable = true;
                } else {
                  noEnable = false;
                }
              });
            }),
        Text('Actualizar Datos', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold))
      ],
    );
  }

  _btonActualizar() {
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
                      ? Text("Actualizar")
                      : SizedBox(
                    child: CircularProgressIndicator(color: Colors.white),
                    height: 20.0,
                    width: 20.0,
                  ),
                  onPressed: () async {
                    print("tiene registrarse:  " +
                        nombres.toString() +
                        " " +
                        apaterno.toString() +
                        " " +
                        amaterno.toString() +
                        " " +
                        usuario.toString() +
                        "" +
                        pass.toString());

                    //Esto es para verificar que esten bien todos tus inputs

                    if (_formKey.currentState!.validate()) {
                      this.setState(() {
                        this.loading = true;
                      });
                      await insertarUsuario();

                      this.setState(() {
                        this.loading = false;
                      });
                      if (resultadoAct == true) {
                        Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context) {
                              prefs.clear();
                              return LoginPage();
                            }));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Hubo un problema al Actualizar'),
                            backgroundColor: Colors.red));
                      }
                    }
                  }));
        });
  }

  insertarUsuario() async{

    final url = Uri.parse(urlApi + 'updateUsuario');
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
            "\"usuario\":\"" +
            usuario.toString() +
            "\"" +
            "," +
            "\"pass\":\"" +
            pass.toString() +
            "\"}");

     //resultadoAct = response.body;
    print(response.body);

  }
}
