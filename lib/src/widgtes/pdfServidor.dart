import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:salud_y_mas/preferences/preferences.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:square_percent_indicater/square_percent_indicater.dart';

AppPreferences pref = AppPreferences();

class ViewPDFServidor extends StatefulWidget {
  final String uri;
  final Text? title;
  const ViewPDFServidor({Key? key, required this.uri, this.title}) : super(key: key);

  @override
  _ViewPDFServidorState createState() => _ViewPDFServidorState();
}

class _ViewPDFServidorState extends State<ViewPDFServidor> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: widget.title ?? const Text("Revista")),
        body: PDF().cachedFromUrl(
          'https://www.salumas.com/Salud_Y_Mas_Api/${widget.uri}',
          placeholder: (progress) => Center(child: CircularPercentIndicator(radius: 60.0, lineWidth: 5.0, percent: progress, center: new Text("$progress%"), progressColor: Colors.green)),
          errorWidget: (error) => Center(child: Text(error.toString())),
        ));
  }
}
