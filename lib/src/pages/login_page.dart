import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salud_y_mas/notification_providers/push_notification_providers.dart';
import 'package:salud_y_mas/preferences/preferences.dart';
import 'package:salud_y_mas/src/pages/pantalla_inicio.dart';
import 'package:salud_y_mas/src/pages/registrarClientes.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool? loading = false;
  AppPreferences prefs = AppPreferences();
  String urlApi = 'https://www.salumas.com/Salud_Y_Mas_Api/';
  String usuario = '';
  String pass = '';
  var datos;
  String? nombre;
  String? paterno;
  bool visibilty = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mostrarDatos();
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
              colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.9), BlendMode.dstATop),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: SingleChildScrollView(
              child: principal(),
            ),
          ),
        ),
      ],
    );
  }

  principal() {
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
          _TexFieldUser(),
          SizedBox(
            height: 15.0,
          ),
          _TexfeldPassword(),
          SizedBox(
            height: 15.0,
          ),
          _buttonAceptar(),
          SizedBox(
            height: 15.0,
          ),
          _crearCuenta(),
          SizedBox(
            height: 45.0,
          ),
        ],
      ),
    );

    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        // border: Border.all(color: Colors.blue, width: 2),
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

  _TexFieldUser() {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 40.0),
        child: TextFormField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              hintText: ("Usuario"),
              labelText: 'Usuario',
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

  _TexfeldPassword() {
    return StreamBuilder(builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 40.0),
        child: TextFormField(
          obscureText: !visibilty,
          decoration: InputDecoration(
              hintText: ("Passsword"),
              labelText: 'Password',
              fillColor: Colors.blue,
              prefixIcon: Icon(Icons.lock),
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

  _buttonAceptar() {
    return StreamBuilder(builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
          width: 400,
          height: 45,
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.teal, textStyle: TextStyle(color: Colors.white)),
              child: !loading!
                  ? Text("Iniciar sesión")
                  : SizedBox(
                      child: CircularProgressIndicator(color: Colors.white),
                      height: 20.0,
                      width: 20.0,
                    ),
              onPressed: () async {
                if (usuario.toString().isEmpty && pass.toString().isEmpty) {
                  print("USUARIO O PASSWORD INCORRECTOS");
                  showDialog(context: context, builder: createDialog);
                } else {
                  this.setState(() {
                    this.loading = true;
                  });
                  await ingresar(usuario.toString(), pass.toString());

                  if (datos != '0' && datos != 0) {
                    prefs.logIn = true;

                    print("datos");
                    print(datos[0]);
                    print(datos[0]['nombre']);
                    print(datos[0]['paterno']);
                    prefs.id = datos[0]['idusuario'];
                    prefs.nombre = datos[0]['nombre'];
                    prefs.paterno = datos[0]['paterno'];
                    prefs.estado = datos[0]['estado_idestado'];

                    print("subscribe");

                    FirebaseMessaging.instance.requestPermission(sound: true, badge: true, alert: true, provisional: false);

                    //Utilizo esto para que pueda ingresarse en un topic (tag) es decir si es YUCATAN a todos los de YUCATAN les llegará la notificación
                    await PushNotificationProvider.firebaseMessaging.subscribeToTopic("${prefs.estado}");

                    print("termina subscribe");

                    // guardar_datos(datos[0]['nombre'], datos[0]['paterno']);

                    this.setState(() {
                      this.loading = false;
                    });
                  Navigator.pushNamedAndRemoveUntil(context, "inicio", (Route<dynamic> route) => false);
                  } else {
                    this.setState(() {
                      this.loading = false;
                    });
                    showDialog(context: context, builder: createDialog);
                  }
                }
              }));
    });
  }

  _crearCuenta() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("¿NO TIENES CUENTA?"),
        SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute<Null>(builder: (BuildContext context) {
              return RegistrarUsuarios();
            }));
          },
          child: Text(
            "Registrarse",
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }

  Future ingresar(String string, String string2) async {
    final url = Uri.parse(urlApi + 'login');
    var response = await http.post(url, body: "{" + "\"usuario\":\"" + usuario.toString() + "\"" + "," + "\"pass\":\"" + pass.toString() + "\"}");

    datos = json.decode(response.body);
    print(datos);
  }

  Future<void> guardar_datos(String? nombre, String? paterno) async {
    print("esto hay en guardar datos  " + nombre.toString());
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('nombre', nombre.toString());
    await pref.setString('paterno', paterno.toString());
  }

  Future<void> mostrarDatos() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    nombre = await pref.get('nombre') as String?;
    paterno = await pref.get('paterno') as String?;

    if (nombre != null) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute<Null>
        (builder: (BuildContext context) {
        return HomePage();
      }

      ), (Route<dynamic> route) => false);

      print(nombre.toString() + " " + paterno.toString());
    }
  }
  Widget createDialog(BuildContext context) => CupertinoAlertDialog(
        title: Text('USUARIO O PASSWORD INCORRECTOS'),
        actions: [
          CupertinoDialogAction(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
        ],
      );
}
