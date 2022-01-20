import 'package:flutter/material.dart';
import 'package:salud_y_mas/src/widgtes/menu.dart';

class RevistasPage extends StatefulWidget {
  const RevistasPage({Key? key}) : super(key: key);

  @override
  _RevistasPageState createState() => _RevistasPageState();
}

class _RevistasPageState extends State<RevistasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuPage(),
      appBar: AppBar(title: Text('Revistas')),
      body: Center(child: Text('Revistas')),
    );
  }
}
