
import 'package:flutter/material.dart';
import 'package:salud_y_mas/src/routes/routes.dart';

  
 void main() => runApp(MyApp());
  
 class MyApp extends StatelessWidget {
   @override
   Widget build(BuildContext context) {
     return MaterialApp(
       title: 'Material App',
       debugShowCheckedModeBanner: false,
       //home:HomePage(),
       initialRoute: '/',
       routes: getApplicationRoutes(),
     );
   }
 }