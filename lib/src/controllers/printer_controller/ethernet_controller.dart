import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sale/src/helpers/printers/test_print.dart';

class EthernetController {
  TestPrint _testPrint;
  EthernetController() {
    _testPrint = TestPrint();
  }
  PosPrintResult res;
  Future<void> connectEthernet(String printerIp, BuildContext context) async {
    try {
      const PaperSize paper = PaperSize.mm80;
      final profile = await CapabilityProfile.load();
      final printer = NetworkPrinter(paper, profile);
      res = await printer.connect(printerIp, port: 9100);
      if (res == PosPrintResult.success) {
        await _testPrint.printDemoReceipt(printer);
        printer.disconnect();
      }
    } catch (e) {
      print('Error : $e');
    }
    final snackBar =
        SnackBar(content: Text(res.msg, textAlign: TextAlign.center));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> disconnectEthernet(BuildContext context) async {
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);
    printer.disconnect();
  }
}
