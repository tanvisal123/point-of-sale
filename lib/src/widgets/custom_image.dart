import 'dart:typed_data';
import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  const CustomImage({
    Key key,
    this.bytes,
  }) : super(key: key);
  final Uint8List bytes;

  @override
  Widget build(BuildContext context) {
    return bytes != null
        ? SizedBox(
            width: 250,
            child: Image.memory(bytes),
          )
        : SizedBox(height: 0, width: 0);
  }
}
