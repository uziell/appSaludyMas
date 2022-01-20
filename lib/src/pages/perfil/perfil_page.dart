import 'package:flutter/material.dart';
import 'package:salud_y_mas/src/widgtes/menu.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({Key? key}) : super(key: key);

  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuPage(),
      appBar: AppBar(title: Text('Perfil')),
      body: Center(child: Text('Perfil')),
    );
  }
}
