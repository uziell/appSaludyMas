

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salud_y_mas/src/pages/registrarClientes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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

  principal(){

    final card = Container(
      width: MediaQuery.of(context).size.width,
     // clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          SizedBox(height: 50.0,),
          imagenSaludYMas(),
          SizedBox(height:20.0,),
          _TexFieldUser(),
          SizedBox(height: 15.0,),
          _TexfeldPassword(),
          SizedBox(height: 15.0,),
          _buttonAceptar(),
          SizedBox(height: 15.0,),
          _crearCuenta(),
          SizedBox(height: 15.0,),
        ],
      ),
    );

    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        border: Border.all(color: Colors.blue, width: 2),
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

  imagenSaludYMas(){
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
    Size size= MediaQuery.of(context).size;
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot){
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
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
                      )
                  )
              ),
              onChanged: (value){

              },
            ),
          );
        }
    );
 }

  _TexfeldPassword() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot){
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              obscureText: true,
              decoration: InputDecoration(
                hintText: ("Passsword"),
                labelText: 'Password',
                fillColor: Colors.blue,
                prefixIcon: Icon(Icons.password),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )
                )
              ),
              onChanged: (value){

              },
            ),
          );
        }
    );
  }

  _buttonAceptar() {
   return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot){
          return RaisedButton(
            color: Colors.teal,
            textColor: Colors.white,
            child: Text(
              "Ingresar"
            ),
              onPressed: (){

              }

          );
        }
    );
  }

  _crearCuenta() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("¿NO TIENES CUENTA?"),
        SizedBox(width: 10),
        GestureDetector(
         onTap: (){
           Navigator.of(context).push(MaterialPageRoute<Null>(builder: (BuildContext context) {
             return RegistrarUsuarios();
           }));
         },
         child: Text("Registrase", style: TextStyle(
           color: Colors.blue,
           fontWeight: FontWeight.bold,
         ),),
       )
      ],
    );
  }
}
