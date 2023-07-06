import 'dart:io';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class BluetoothController {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
      buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
    );
  }

  Future<String> initSaveToPath() async {
    String pathImage;
    //read and write
    //image max 300px X 300px
    final filename = 'logo.jpg';
    var bytes = await rootBundle.load("assets/images/logo.jpg");
    String dir = (await getApplicationDocumentsDirectory()).path;
    writeToFile(bytes, '$dir/$filename');
    pathImage = '$dir/$filename';
    return pathImage;
  }
}
