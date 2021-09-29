import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class Background extends StatelessWidget {
  final boxDecoration = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.center,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xff005661),
          Color(0xff00838e)
      ]
    )
  );
  @override
  Widget build(BuildContext context) {
    return Stack(
     children: [
       Container(
       decoration: boxDecoration,
      ),
     ],
    );
  }
}