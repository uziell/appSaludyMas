import 'package:flutter/material.dart';

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
          placeholder: (progress) => Center(
              child: SquarePercentIndicator(
            width: 140,
            height: 140,
            startAngle: StartAngle.bottomRight,
            reverse: true,
            borderRadius: 12,
            shadowWidth: 1.5,
            progressWidth: 5,
            shadowColor: Colors.grey,
            progressColor: Colors.blue,
            progress: progress / 100,
            child: Center(
                child: Text(
              "$progress %",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            )),
          )),
          errorWidget: (error) => Center(child: Text(error.toString())),
        ));
  }
}
