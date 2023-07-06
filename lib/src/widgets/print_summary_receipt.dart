import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sale/src/models/receipt_information.dart';

class PrintReceiptSummary {
  // final Receipts receipts;
  // final int receiptId;
  // PrintReceiptSummary({this.receipts, this.receiptId});
  ReceiptInformation receiptInfo = new ReceiptInformation();
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  sample(bool isInternet) async {
    bluetooth.isConnected.then((isConnected) async {
      var date = DateTime.now();
      if (isConnected) {
        bluetooth.printCustom(
            DateFormat("dd-MM-yyyy HH:mm:ss").format(date).toString(), 0, 0);
        if (isInternet) {
          bluetooth.printCustom(
              "Branch :${receiptInfo.branchName != null ? receiptInfo.branchName : ""}",
              0,
              0);
          bluetooth.printCustom(
              "Address :${receiptInfo.address != null ? receiptInfo.address : ""}",
              0,
              0);
          bluetooth.printCustom(
              "Phone 1: ${receiptInfo.phone1 != null ? receiptInfo.phone1 : ""}",
              0,
              0);
          bluetooth.printCustom(
              "Phone 2: ${receiptInfo.phone2 != null ? receiptInfo.phone2 : ""}",
              0,
              0);
        } else {
          bluetooth.printCustom(
              "Branch :${receiptInfo.branchName != null ? receiptInfo.branchName : ""}",
              0,
              0);
          bluetooth.printCustom(
              "Address :${receiptInfo.address != null ? receiptInfo.address : ""}",
              0,
              0);
          bluetooth.printCustom(
              "Phone 1: ${receiptInfo.phone1 != null ? receiptInfo.phone1 : ""}",
              0,
              0);
          bluetooth.printCustom(
              "Phone 2: ${receiptInfo.phone2 != null ? receiptInfo.phone2 : ""}",
              0,
              0);
        }
        bluetooth.printCustom("RECEIPT", 3, 1);

        // bluetooth.printImage(pathImage);
      }
    });
  }
}
