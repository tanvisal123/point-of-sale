import 'package:collection/collection.dart';
import 'package:flutter_sunmi_printer/flutter_sunmi_printer.dart';
import 'package:point_of_sale/src/models/receipt_reprint_close_shift.dart';
import 'package:point_of_sale/src/models/reprint_close_shift_model.dart';

class ReprintCashOut {
  final List<ReceiptReprintCloseShift> recipt;
  final ReprintCloseShiftModel reprint;

  ReprintCashOut({this.recipt, this.reprint});
  Future<void> startPrint() async {
    SunmiPrinter.text("#REPRINT CASH OUT REPORT",
        styles: SunmiStyles(
            align: SunmiAlign.center, size: SunmiSize.md, bold: true));
    SunmiPrinter.hr();
    SunmiPrinter.text(
        'Date Time In :${reprint.dateIn} ${reprint.timeIn.split(" ").first}');
    SunmiPrinter.text(
        'Date Time Out:${reprint.dateOut} ${reprint.timeOut.split(" ").first}');
    SunmiPrinter.hr();
    SunmiPrinter.row(cols: [
      SunmiCol(text: '#CASHIER  :', width: 6),
      SunmiCol(text: reprint.empName, width: 6),
    ]);
    SunmiPrinter.hr();
    var group = groupBy(recipt, (ReceiptReprintCloseShift re) {
      return re.itemGroup1;
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
          text: recipt.last.totalSoldAmount, width: 5, align: SunmiAlign.right),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'DiscountItem', width: 5, align: SunmiAlign.left),
      SunmiCol(text: ":", width: 2, align: SunmiAlign.center),
      SunmiCol(
          text: recipt.last.totalDiscountItem,
          width: 5,
          align: SunmiAlign.right),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'DiscountTotal', width: 5, align: SunmiAlign.left),
      SunmiCol(text: ":", width: 2, align: SunmiAlign.center),
      SunmiCol(
          text: recipt.last.totalDiscountTotal,
          width: 5,
          align: SunmiAlign.right),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'GrandTotalSSC', width: 5, align: SunmiAlign.left),
      SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
      SunmiCol(
          text: "${recipt.last.grandTotalSys} ${recipt.last.currencySys}",
          width: 6,
          align: SunmiAlign.right),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'GrandTotalLCC', width: 5, align: SunmiAlign.left),
      SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
      SunmiCol(
          text: "${recipt.last.grandTotal} ${recipt.last.currency}",
          width: 6,
          align: SunmiAlign.right),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'Total CASHIN', width: 5, align: SunmiAlign.left),
      SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
      SunmiCol(
          text: recipt.last.totalCashInSys, width: 6, align: SunmiAlign.right),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'TOTAL CASHOUT', width: 5, align: SunmiAlign.left),
      SunmiCol(text: ":", width: 2, align: SunmiAlign.center),
      SunmiCol(
          text: recipt.last.totalCashOutSys, width: 5, align: SunmiAlign.right),
    ]);
    SunmiPrinter.emptyLines(3);
  }
}
