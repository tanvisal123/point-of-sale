import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

class Utility {
  static Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.cover,
    );
  }

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }
}

class Utils {
  static Future capture(GlobalKey key) async {
    if (key == null) return null;
    RenderRepaintBoundary boundary = key.currentContext.findRenderObject();
    final image = await boundary.toImage(pixelRatio: 6);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData.buffer.asUint8List();
    return pngBytes;
  }
}
