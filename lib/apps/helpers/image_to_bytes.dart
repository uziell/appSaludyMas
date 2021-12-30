import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

Future<Uint8List> imageToBytes(
  String path, {
  int witdh = 100,
  bool fromNetwork = false,
}) async {
  late Uint8List byte;
  if (fromNetwork) {
    final file = await DefaultCacheManager().getSingleFile(path);
    byte = await file.readAsBytes();
  } else {
    final byteData = await rootBundle.load(path);
    byte = byteData.buffer.asUint8List();
  }

  final codec = await ui.instantiateImageCodec(byte, targetWidth: witdh);

  final frame = await codec.getNextFrame();
  final newByteData =
      await frame.image.toByteData(format: ui.ImageByteFormat.png);

  return newByteData!.buffer.asUint8List();
}
