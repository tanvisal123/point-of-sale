import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter_sunmi_printer/flutter_sunmi_printer.dart';
import 'package:point_of_sale/src/models/order_detail_modal.dart';
import 'package:point_of_sale/src/models/receipt_info_model.dart';

class PrintOrder {
  final String receiptNo;
  final String cashier;
  final String table;
  final List<OrderDetail> orderDetailList;
  PrintOrder({
    this.cashier,
    this.table,
    this.receiptNo,
    this.orderDetailList,
  });
  Future<void> startPrintOrder() async {
    var _f = NumberFormat('#,##0.00');
    SunmiPrinter.text(
      '$receiptNo',
      styles:
          SunmiStyles(size: SunmiSize.xl, bold: true, align: SunmiAlign.center),
    );
    SunmiPrinter.text('Table     : $table');
    SunmiPrinter.text('Cashier   : $cashier');
    SunmiPrinter.text(
        'Date: ${DateFormat('yyyy-MM-dd HH:mm a').format(DateTime.now())}');
    SunmiPrinter.hr();
    for (var temp in orderDetailList) {
      if (temp.qty > 0) {
        SunmiPrinter.text('${temp.khmerName}(${temp.uomName})',
            styles: SunmiStyles(bold: true));
        if (temp.discountValue > 0) {
          if (temp.typeDis == 'Cash') {
            SunmiPrinter.text(
                'Discount :  ${_f.format(temp.discountValue)} ${temp.currency}');
          } else {
            SunmiPrinter.text(
                'Discount : ${temp.discountRate.toStringAsFixed(0)}%');
          }
        }
        SunmiPrinter.text('Quantity : ${temp.qty.toStringAsFixed(0)}');
      }
    }
    SunmiPrinter.hr();
    SunmiPrinter.emptyLines(3);
  }
}

class NewPrintOrder {
  final ReceiptInfoModel receiptInfoModel;

  NewPrintOrder({@required this.receiptInfoModel});
  Future<void> startPrintOrder() async {
    //  SunmiPrinter.text('Table     : ${receiptInfoModel.printInvoice.tableName}');
    //SunmiPrinter.text('Cashier   : ${receiptInfoModel.printInvoice.userOrder}');
    SunmiPrinter.text(
        'Date: ${DateFormat('yyyy-MM-dd HH:mm a').format(DateTime.now())}');
    SunmiPrinter.hr();
    if (receiptInfoModel.printInvoice != null)
      for (var temp in receiptInfoModel.printInvoice.lineItems) {
        if (temp.comment.isNotEmpty) {
          if (temp.itemType.toLowerCase() == "addOn".toLowerCase()) {
            SunmiPrinter.text('    ${temp.itemName} (${temp.comment})',
                styles: SunmiStyles(bold: true));
          } else {
            SunmiPrinter.text('${temp.itemName} (${temp.comment})',
                styles: SunmiStyles(bold: true));
          }
        } else {
          if (temp.itemType.toLowerCase() == "addOn".toLowerCase()) {
            SunmiPrinter.text('    ${temp.itemName}',
                styles: SunmiStyles(bold: true));
          } else {
            SunmiPrinter.text('${temp.itemName}',
                styles: SunmiStyles(bold: true));
          }
        }
        if (temp.discountRate != '0%') {
          if (temp.itemType.toLowerCase() == "addon".toLowerCase()) {
            SunmiPrinter.text(
              '    Discount % : ${temp.discountRate} ',
            );
          } else {
            SunmiPrinter.text(
              'Discount % : ${temp.discountRate} ',
            );
          }
        }
        if (temp.itemType.toLowerCase() == "addon") {
          SunmiPrinter.text('    Quantity : ${temp.qty}');
        } else {
          SunmiPrinter.text('Quantity : ${temp.qty}');
        }
      }
    else
      SunmiPrinter.text('No Invoice......');
    SunmiPrinter.hr();
    SunmiPrinter.emptyLines(3);
  }
}
