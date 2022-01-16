import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:salud_y_mas/preferences/preferences.dart';

AppPreferences pref = AppPreferences();

class Pdf extends StatefulWidget {
  const Pdf({Key? key}) : super(key: key);

  @override
  _PdfState createState() => _PdfState();
}

class _PdfState extends State<Pdf> {
  final StreamController<String> _streamController = StreamController<String>();
  File? _file;


  @override
  void initState() {
    super.initState();

    createFileOfPdfUrl().then((File file) {
      _streamController.sink.add(file.path);
    });
  }

  @override
  void dispose() {
    _streamController.close();
    if (_file != null) _file!.delete();
    super.dispose();
  }

  Future<File> createFileOfPdfUrl() async {
    Completer<File> completer = Completer();
    try {
     
      _file = await getImageFileFromAssets('aviso_privacidad.pdf');

      print("file");
      print(_file);

      completer.complete(_file);
    } catch (e) {

      print("e");
      print(e);
      _streamController.sink.add('');
    }

    return completer.future;
  }


  Future<File> getImageFileFromAssets(String path) async {
  final byteData = await rootBundle.load('assets/$path');

  final file = File('${(await getTemporaryDirectory()).path}/$path');
  await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

  return file;
}





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Términos y condiciones"), backgroundColor: Colors.teal),
      body: StreamBuilder(
          stream: _streamController.stream,
          builder: (_, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              return PDFView(
                filePath: snapshot.data,
                enableSwipe: true,
                swipeHorizontal: true,
                autoSpacing: true,
                pageFling: true,
                pageSnap: true,
                fitPolicy: FitPolicy.BOTH,
                preventLinkNavigation: true,
                onError: (error) {
                 print("ocurrio un error");
                 print(error);
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
