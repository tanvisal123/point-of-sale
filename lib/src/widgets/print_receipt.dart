import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sale/src/controllers/receipt_information_controller.dart';
import 'package:point_of_sale/src/controllers/sale_controller.dart';

class PrintReceipt {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  printRe(String pathImage, bool isInternet, String ip) async {
    bluetooth.isConnected.then((isConnected) async {
      var date = DateTime.now();
      var order = SaleController().selectOrder();
      if (isConnected) {
        bluetooth.printCustom(
            DateFormat("dd-MM-yyyy HH:mm:ss").format(date).toString(), 0, 0);
        if (isInternet) {
          ReceiptInformationController.eachRI(ip).then((value) {
            bluetooth.printCustom(
                "Branch :${value.first.branchName != null ? value.first.branchName : ""}",
                0,
                0);
            bluetooth.printCustom(
                "Address :${value.first.address != null ? value.first.address : ""}",
                0,
                0);
            bluetooth.printCustom(
                "Phone 1: ${value.first.phone1 != null ? value.first.phone1 : ""}",
                0,
                0);
            bluetooth.printCustom(
                "Phone 2: ${value.first.phone2 != null ? value.first.phone2 : ""}",
                0,
                0);
          });
        } else {
          ReceiptInformationController().getReceipt().then((value) {
            bluetooth.printCustom(
                "Branch :${value.first.branchName != null ? value.first.branchName : ""}",
                0,
                0);
            bluetooth.printCustom(
                "Address :${value.first.address != null ? value.first.address : ""}",
                0,
                0);
            bluetooth.printCustom(
                "Phone 1: ${value.first.phone1 != null ? value.first.phone1 : ""}",
                0,
                0);
            bluetooth.printCustom(
                "Phone 2: ${value.first.phone2 != null ? value.first.phone2 : ""}",
                0,
                0);
          });
        }
        order.then((value) {
          bluetooth.printCustom("Receipt #:${value.first.receiptNo}", 0, 0);
          bluetooth.printCustom("Transaction #:${value.first.orderNo}", 0, 0);
          bluetooth.printCustom("Pay By #:${value.first.paymentType}", 0, 0);
          bluetooth.printNewLine();
        });
        bluetooth.printCustom("Receipt", 3, 1);
        // bluetooth.printImage(pathImage);
        SaleController().selectOrderDetail().then((value) {
          value.where((x) => x.qty > 0).forEach((element) {
            bluetooth.printLeftRight("Name :", "${element.khmerName}", 0);
            bluetooth.printLeftRight(
                "Price :", "${element.unitPrice.toStringAsFixed(2)}", 0);
            bluetooth.printLeftRight("Qty :", "${element.qty}", 0);
            bluetooth.printLeftRight(
                "Discount :",
                "${(element.discountValue * element.qty).toStringAsFixed(2)}",
                0);
            bluetooth.printLeftRight(
                "Amount :",
                "${((element.qty * element.unitPrice) - (element.discountValue * element.qty)).toStringAsFixed(2)}",
                0);
            bluetooth.printNewLine();
          });

          bluetooth.printCustom("--------------------------------", 3, 1);
          order.then((value) {
            bluetooth.printLeftRight(
                "Sub Total", "${value.first.subTotal.toStringAsFixed(2)}", 1);
            bluetooth.printLeftRight("Discount",
                "${value.first.discountValue.toStringAsFixed(2)}", 1);
            bluetooth.printLeftRight(
                "Total",
                "${value.first.currencyDisplay} ${value.first.grandTotal.toStringAsFixed(2)}",
                1);

            bluetooth.printNewLine();
            bluetooth.printCustom("--------------------------------", 3, 1);
            bluetooth.printCustom("--------------------------------", 3, 1);
            if (value.first.paymentType.contains(',')) {
              var type = value.first.receivedType.split(',');
              var cash = double.parse(type[0]).toStringAsFixed(2);
              var bank = double.parse(type[1]).toStringAsFixed(2);
              bluetooth.printLeftRight("Cash Pay", "$cash", 1);
              bluetooth.printLeftRight("Bank Pay", "$bank", 1);
            } else {
              if (value.first.paymentType == "Cash") {
                bluetooth.printLeftRight(
                    "Cash Pay", "${value.first.receivedType}", 1);
              } else {
                bluetooth.printLeftRight(
                    "Bank Pay", "${value.first.receivedType}", 1);
              }
            }
            bluetooth.printLeftRight("Received", "${value.first.received}", 1);
            // bluetooth.printLeftRight(
            //     "Credit",
            //     "${value.first.currencyDisplay} ${value.first.credit.toStringAsFixed(2)}",
            //     1);
            bluetooth.printLeftRight(
                "Change",
                "${value.first.currencyDisplay} ${value.first.change.toStringAsFixed(2)}",
                1);

            bluetooth.printNewLine();
            bluetooth.printCustom("Thank you for your purchase !", 1, 1);
            bluetooth.printNewLine();
            bluetooth.printCustom("សូមអរគុណ", 1, 1);
            //bluetooth.writeBytes(utf8.encode("សូមអរគុណ"));
            order.then((value) {
              bluetooth.printNewLine();
              bluetooth.printQRcode("${value.first.orderNo}", 200, 200, 1);
              bluetooth.printNewLine();
              bluetooth.printNewLine();
              bluetooth.paperCut();
            });
          });
        });
        //-----------------------------
      }
    });
  }
}
