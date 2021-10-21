import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class Background extends StatelessWidget {
  final boxDecoration = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.center,
        end: Alignment.bottomCenter,
        stops: [0.2,0.8],
        colors: [
          Color(0xffb2dfdb),
          Color(0xff26a69a),

      ]
    )
  );
  @override
  Widget build(BuildContext context) {
    return Stack(
     children: [
       Container(decoration: boxDecoration),

      /* Positioned(
           left: 27,
           child:  _Blue()
       )*/
     ],
    );
  }
}

class _Blue extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return Transform.rotate(
      angle: -pi / 12,
      child: Container(
        width: 360,
        height: 360,
        decoration: BoxDecoration(
          color: Colors.cyan,
          borderRadius: BorderRadius.circular(80),

        ),
      ),
    );
  }

}