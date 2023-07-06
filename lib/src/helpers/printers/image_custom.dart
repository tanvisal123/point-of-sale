import 'dart:typed_data';
import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  const CustomImage({Key key, this.bytes, this.printerStatus})
      : super(key: key);
  final Uint8List bytes;
  final String printerStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: printerStatus == 'Bluetooth' ? 250 : 400,
      child: Image.memory(bytes),
    );
  }
}
