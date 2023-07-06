import 'package:collection/collection.dart';
import 'package:flutter_sunmi_printer/flutter_sunmi_printer.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sale/src/models/close_shift_model.dart';

class PrintCashOut {
  final ProccesCloseShift proccesCloseShift;
  PrintCashOut({this.proccesCloseShift});
  void startPrint() {
    SunmiPrinter.text('#CASH OUT REPORT',
        styles: SunmiStyles(
            align: SunmiAlign.center, size: SunmiSize.md, bold: true));
    SunmiPrinter.hr();
    SunmiPrinter.text(
        'Date Out :${DateFormat("dd-MM-yyyy hh:mm a").format(DateTime.now())}');
    SunmiPrinter.hr();
    SunmiPrinter.row(cols: [
      SunmiCol(text: '#CASHIER  :', width: 6),
      SunmiCol(text: proccesCloseShift.items.closeShift.last.empName, width: 6),
    ]);
    SunmiPrinter.hr();
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'ReceiptNo', width: 4),
      SunmiCol(text: 'Date', width: 4),
      SunmiCol(text: 'Amount', width: 4, align: SunmiAlign.right),
    ]);
    var group =
        groupBy(proccesCloseShift.items.closeShift, (CloseShift closeShift) {
      return closeShift.itemGroup1;
    });
    Map<String, String> subtotalByGroup = Map();
    group.forEach((key, value) {
      SunmiPrinter.text(key, styles: SunmiStyles(bold: true));
      value.forEach((element) {
        subtotalByGroup[key] = value.fold(0, (pre, element) {
          return pre + double.parse(element.total.replaceAll(",", ""));
        }).toString();
        if (element.id < 0 ||
            element.code == null ||
            element.barcode == null ||
            element.code == "" ||
            element.barcode == "") {
          SunmiPrinter.row(cols: [
            SunmiCol(text: element.receiptNo, width: 4),
            SunmiCol(text: element.dateOut.split(" ").first, width: 5),
            SunmiCol(text: element.total, width: 3)
          ]);
        } else {
          SunmiPrinter.text("${element.khmerName}");
          SunmiPrinter.text("discount : ${element.disItemValue}");
          SunmiPrinter.text(
              "${element.qty} X ${element.price} = ${element.total}");
        }
      });
      SunmiPrinter.text("Sub-Total : ${subtotalByGroup[key]}",
          styles: SunmiStyles(align: SunmiAlign.right));
    });

    SunmiPrinter.hr();
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'SoldAmount', width: 5, align: SunmiAlign.left),
      SunmiCol(text: ":", width: 2, align: SunmiAlign.center),
      SunmiCol(
          text: proccesCloseShift.items.closeShift.last.totalSoldAmount,
          width: 5,
          align: SunmiAlign.right),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'DiscountItem', width: 5, align: SunmiAlign.left),
      SunmiCol(text: ":", width: 2, align: SunmiAlign.center),
      SunmiCol(
          text: proccesCloseShift.items.closeShift.last.totalDiscountItem,
          width: 5,
          align: SunmiAlign.right),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'DiscountTotal', width: 5, align: SunmiAlign.left),
      SunmiCol(text: ":", width: 2, align: SunmiAlign.center),
      SunmiCol(
          text: proccesCloseShift.items.closeShift.last.totalDiscountTotal,
          width: 5,
          align: SunmiAlign.right),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'GrandTotalSSC', width: 5, align: SunmiAlign.left),
      SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
      SunmiCol(
          text:
              "${proccesCloseShift.items.closeShift.last.grandTotalSys} ${proccesCloseShift.items.closeShift.last.currencySys}",
          width: 6,
          align: SunmiAlign.right),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'GrandTotalLCC', width: 5, align: SunmiAlign.left),
      SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
      SunmiCol(
          text:
              "${proccesCloseShift.items.closeShift.last.grandTotal} ${proccesCloseShift.items.closeShift.last.currency}",
          width: 6,
          align: SunmiAlign.right),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'Total CASHIN', width: 5, align: SunmiAlign.left),
      SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
      SunmiCol(
          text: proccesCloseShift.items.closeShift.last.totalCashInSys,
          width: 6,
          align: SunmiAlign.right),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'TOTAL CASHOUT', width: 5, align: SunmiAlign.left),
      SunmiCol(text: ":", width: 2, align: SunmiAlign.center),
      SunmiCol(
          text: proccesCloseShift.items.closeShift.last.totalCashOutSys,
          width: 5,
          align: SunmiAlign.right),
    ]);
    SunmiPrinter.emptyLines(3);
  }
}
