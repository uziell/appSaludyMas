import 'package:flutter/material.dart';

class FarmaciasDelAhorro extends StatefulWidget {
  String ciudad='';
  String? idFar = '';

  FarmaciasDelAhorro(this.ciudad,this.idFar,{Key? key}) : super(key: key);

  @override
  _FarmaciasDelAhorroState createState() => _FarmaciasDelAhorroState();
}

class _FarmaciasDelAhorroState extends State<FarmaciasDelAhorro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Soy yomero'+ widget.idFar.toString()),
      ),
    );
  }
}
