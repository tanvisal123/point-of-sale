import 'package:intl/intl.dart';
import 'package:flutter_sunmi_printer/flutter_sunmi_printer.dart';
import 'package:point_of_sale/src/models/fetch_oreder_model.dart';
import 'package:point_of_sale/src/models/receipt_info_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Englist Receipt Has Logo
class PrintNewPaymant {
  final ReceiptInfoModel receiptInfoModel;
  final DisplayPayOtherCurrency displayCurrency;
  PrintNewPaymant({this.receiptInfoModel, this.displayCurrency});
  Future<void> startPrintPayment(String payBy, double received, String changed,
      String systemType, String customerName) async {
    var _f = NumberFormat('#,##0.00');
    var prefs = await SharedPreferences.getInstance();
    String img = prefs.getString('img');
    bool logoPrint = prefs.getBool('logoPrint') ?? false;
    bool _isPrintAddress = prefs.getBool("isPrintAddress") ?? false;
    bool _isPrintBranch = prefs.getBool("isPrintBranch") ?? false;
    bool _isShowCount = prefs.getBool("isShowCount") ?? false;
    bool _isShowDateIn = prefs.getBool("isShowDateIn") ?? true;
    bool _isShowDateOut = prefs.getBool("isShowDateOut") ?? true;
    var curency = displayCurrency;
    img != null && logoPrint
        ? SunmiPrinter.image(img)
        : SunmiPrinter.text(
            '${receiptInfoModel.printInvoice.companyName}',
            styles: SunmiStyles(
                size: SunmiSize.xl, bold: true, align: SunmiAlign.center),
          );
    if (_isPrintBranch) {
      if (receiptInfoModel.printInvoice.branchName == null ||
          receiptInfoModel.printInvoice.branchName == "") {
      } else {
        SunmiPrinter.text("${receiptInfoModel.printInvoice.branchName}",
            styles: SunmiStyles(
                size: SunmiSize.md, bold: true, align: SunmiAlign.center));
      }
    }
    if (_isPrintAddress) {
      SunmiPrinter.text("${receiptInfoModel.printInvoice.address}",
          styles: SunmiStyles(
              size: SunmiSize.md, bold: true, align: SunmiAlign.center));
    }
    SunmiPrinter.text(
      '${receiptInfoModel.printInvoice.tel} | ${receiptInfoModel.printInvoice.tel2}',
      styles:
          SunmiStyles(size: SunmiSize.md, bold: true, align: SunmiAlign.center),
    );
    if (systemType == "KRMS") {
      SunmiPrinter.row(cols: [
        SunmiCol(
            text: "Cashier : ${receiptInfoModel.printInvoice.userOrder}",
            width: 6),
        SunmiCol(text: "PayBy : $payBy", width: 6, align: SunmiAlign.right),
      ]);
    }
    if (systemType == "KBMS") {
      SunmiPrinter.row(cols: [
        SunmiCol(text: "Cashier", width: 4, align: SunmiAlign.left),
        SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
        SunmiCol(text: '${receiptInfoModel.printInvoice.userOrder}', width: 7),
      ]);
    }
    SunmiPrinter.row(cols: [
      SunmiCol(text: "ReceiptNo", width: 4, align: SunmiAlign.left),
      SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
      SunmiCol(text: '#${receiptInfoModel.printInvoice.receiptNo}', width: 7),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: "Customer", width: 4, align: SunmiAlign.left),
      SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
      SunmiCol(
          text: '${receiptInfoModel.printInvoice.customerInfo.split("/")[1]}',
          width: 7),
    ]);
    if (_isShowCount) {
      SunmiPrinter.row(cols: [
        SunmiCol(text: "Count", width: 4, align: SunmiAlign.left),
        SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
        SunmiCol(
            text: '${receiptInfoModel.printInvoice.countReceipt}', width: 7),
      ]);
    }

    // if (customerName != null) {
    //   SunmiPrinter.row(cols: [
    //     SunmiCol(text: "Customer", width: 4, align: SunmiAlign.left),
    //     SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
    //     SunmiCol(text: '$customerName', width: 7),
    //   ]);
    // }
    if (systemType == "KBMS") {
      SunmiPrinter.row(cols: [
        SunmiCol(text: "PayBy", width: 4, align: SunmiAlign.left),
        SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
        SunmiCol(text: '$payBy', width: 7),
      ]);
    }
    if (systemType == "KRMS") {
      SunmiPrinter.row(cols: [
        SunmiCol(text: "Table", width: 4, align: SunmiAlign.left),
        SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
        SunmiCol(text: '${receiptInfoModel.printInvoice.tableName}', width: 7),
      ]);
    }

    if (_isShowDateIn) {
      SunmiPrinter.row(cols: [
        SunmiCol(text: "Date-In", width: 4, align: SunmiAlign.left),
        SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
        SunmiCol(
          text:
              "${receiptInfoModel.printInvoice.dateIn.substring(0, receiptInfoModel.printInvoice.dateIn.length - 3)}",
          width: 7,
        )
      ]);
    }
    if (_isShowDateOut) {
      SunmiPrinter.row(cols: [
        SunmiCol(text: "Date-Out", width: 4, align: SunmiAlign.left),
        SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
        SunmiCol(
            text:
                "${receiptInfoModel.printInvoice.dateOut.substring(0, receiptInfoModel.printInvoice.dateOut.length - 3)}",
            width: 7)
      ]);
    }

    SunmiPrinter.hr();
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
        SunmiPrinter.text(
            '    ${temp.qty} x ${temp.unitPrice} = ${temp.total}  ${curency.baseCurrency}');
      } else {
        SunmiPrinter.text(
            '${temp.qty} x ${temp.unitPrice} = ${temp.total}  ${curency.baseCurrency}');
      }
    }
    SunmiPrinter.hr();
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'Sub-Total', align: SunmiAlign.left, width: 5),
      SunmiCol(text: ':', align: SunmiAlign.center, width: 1),
      SunmiCol(
          text: '${receiptInfoModel.printInvoice.subtotal} ',
          align: SunmiAlign.center,
          width: 4),
      SunmiCol(
          text: '${curency.baseCurrency}', align: SunmiAlign.right, width: 2),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'Discount', align: SunmiAlign.left, width: 5),
      SunmiCol(text: ':', align: SunmiAlign.center, width: 1),
      SunmiCol(
          text: '${receiptInfoModel.printInvoice.discountValue} ',
          align: SunmiAlign.center,
          width: 4),
      SunmiCol(
          text: '${curency.baseCurrency}', align: SunmiAlign.right, width: 2),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'GrandTotal', align: SunmiAlign.left, width: 5),
      SunmiCol(text: ':', align: SunmiAlign.center, width: 1),
      SunmiCol(
          text: '${receiptInfoModel.printInvoice.grandTotal} ',
          align: SunmiAlign.center,
          width: 4),
      SunmiCol(
          text: '${curency.baseCurrency}', align: SunmiAlign.right, width: 2),
    ]);
    SunmiPrinter.hr();
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'Receive', align: SunmiAlign.left, width: 5),
      SunmiCol(text: ':', align: SunmiAlign.center, width: 1),
      SunmiCol(
          text: '${_f.format(received)}', align: SunmiAlign.center, width: 4),
      SunmiCol(
          text: '${curency.baseCurrency}', align: SunmiAlign.right, width: 2),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'Return', align: SunmiAlign.left, width: 5),
      SunmiCol(text: ':', align: SunmiAlign.center, width: 1),
      SunmiCol(text: '$changed', align: SunmiAlign.center, width: 4),
      SunmiCol(
          text: '${curency.baseCurrency}', align: SunmiAlign.right, width: 2),
    ]);
    SunmiPrinter.hr();
    SunmiPrinter.text('${receiptInfoModel.printInvoice.description2}',
        styles: SunmiStyles(align: SunmiAlign.center));
    SunmiPrinter.emptyLines(3);
  }
}

//English Receipt No Logo
class PrintEngNoLogoPaymant {
  final ReceiptInfoModel receiptInfoModel;
  final DisplayPayOtherCurrency displayCurrency;
  PrintEngNoLogoPaymant({this.receiptInfoModel, this.displayCurrency});
  Future<void> startPrintPayment(String payBy, double received, String changed,
      String systemType, String customerName) async {
    var _f = NumberFormat('#,##0.00');
    var prefs = await SharedPreferences.getInstance();
    bool _isPrintAddress = prefs.getBool("isPrintAddress") ?? false;
    bool _isPrintBranch = prefs.getBool("isPrintBranch") ?? false;
    bool _isShowCount = prefs.getBool("isShowCount") ?? false;
    bool _isShowDateIn = prefs.getBool("isShowDateIn") ?? true;
    bool _isShowDateOut = prefs.getBool("isShowDateOut") ?? true;
    var curency = displayCurrency;
    SunmiPrinter.text(
      '${receiptInfoModel.printInvoice.companyName}',
      styles:
          SunmiStyles(size: SunmiSize.xl, bold: true, align: SunmiAlign.center),
    );
    if (_isPrintBranch) {
      if (receiptInfoModel.printInvoice.branchName == null ||
          receiptInfoModel.printInvoice.branchName == "") {
      } else {
        SunmiPrinter.text("${receiptInfoModel.printInvoice.branchName}",
            styles: SunmiStyles(
                size: SunmiSize.md, bold: true, align: SunmiAlign.center));
      }
    }
    if (_isPrintAddress) {
      SunmiPrinter.text("${receiptInfoModel.printInvoice.address}",
          styles: SunmiStyles(
              size: SunmiSize.md, bold: true, align: SunmiAlign.center));
    }
    SunmiPrinter.text(
      '${receiptInfoModel.printInvoice.tel} | ${receiptInfoModel.printInvoice.tel2}',
      styles:
          SunmiStyles(size: SunmiSize.md, bold: true, align: SunmiAlign.center),
    );
    if (systemType == "KRMS") {
      SunmiPrinter.row(cols: [
        SunmiCol(
            text: "Cashier : ${receiptInfoModel.printInvoice.userOrder}",
            width: 6),
        SunmiCol(text: "PayBy : $payBy", width: 6, align: SunmiAlign.right),
      ]);
    }
    if (systemType == "KBMS") {
      SunmiPrinter.row(cols: [
        SunmiCol(text: "Cashier", width: 4, align: SunmiAlign.left),
        SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
        SunmiCol(text: '${receiptInfoModel.printInvoice.userOrder}', width: 7),
      ]);
    }
    SunmiPrinter.row(cols: [
      SunmiCol(text: "ReceiptNo", width: 4, align: SunmiAlign.left),
      SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
      SunmiCol(text: '#${receiptInfoModel.printInvoice.receiptNo}', width: 7),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: "Customer", width: 4, align: SunmiAlign.left),
      SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
      SunmiCol(
          text: '${receiptInfoModel.printInvoice.customerInfo.split("/")[1]}',
          width: 7),
    ]);
    if (_isShowCount) {
      SunmiPrinter.row(cols: [
        SunmiCol(text: "Count", width: 4, align: SunmiAlign.left),
        SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
        SunmiCol(
            text: '${receiptInfoModel.printInvoice.countReceipt}', width: 7),
      ]);
    }
    if (systemType == "KBMS") {
      SunmiPrinter.row(cols: [
        SunmiCol(text: "PayBy", width: 4, align: SunmiAlign.left),
        SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
        SunmiCol(text: '$payBy', width: 7),
      ]);
    }
    if (systemType == "KRMS") {
      SunmiPrinter.row(cols: [
        SunmiCol(text: "Table", width: 4, align: SunmiAlign.left),
        SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
        SunmiCol(text: '${receiptInfoModel.printInvoice.tableName}', width: 7),
      ]);
    }
    if (_isShowDateIn) {
      SunmiPrinter.row(cols: [
        SunmiCol(text: "Date-In", width: 4, align: SunmiAlign.left),
        SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
        SunmiCol(
          text:
              "${receiptInfoModel.printInvoice.dateIn.substring(0, receiptInfoModel.printInvoice.dateIn.length - 3)}",
          width: 7,
        )
      ]);
    }
    if (_isShowDateOut) {
      SunmiPrinter.row(cols: [
        SunmiCol(text: "Date-Out", width: 4, align: SunmiAlign.left),
        SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
        SunmiCol(
            text:
                "${receiptInfoModel.printInvoice.dateOut.substring(0, receiptInfoModel.printInvoice.dateOut.length - 3)}",
            width: 7)
      ]);
    }
    SunmiPrinter.hr();
    for (var temp in receiptInfoModel.printInvoice.lineItems) {
      if (temp.comment == null || temp.comment.isEmpty) {
        if (temp.itemType.toLowerCase() == "addOn".toLowerCase()) {
          SunmiPrinter.text('    ${temp.itemName}',
              styles: SunmiStyles(bold: true));
        } else {
          SunmiPrinter.text('${temp.itemName}',
              styles: SunmiStyles(bold: true));
        }
      } else {
        if (temp.itemType.toLowerCase() == "addOn".toLowerCase()) {
          SunmiPrinter.text('    ${temp.itemName} (${temp.comment})',
              styles: SunmiStyles(bold: true));
        } else {
          SunmiPrinter.text('${temp.itemName} (${temp.comment})',
              styles: SunmiStyles(bold: true));
        }
      }
      // if (temp.comment != null || temp.comment.isNotEmpty) {
      //   if (temp.itemType.toLowerCase() == "addOn".toLowerCase()) {
      //     SunmiPrinter.text('    ${temp.itemName} (${temp.comment})',
      //         styles: SunmiStyles(bold: true));
      //   } else {
      //     SunmiPrinter.text('${temp.itemName} (${temp.comment})',
      //         styles: SunmiStyles(bold: true));
      //   }
      // }
      // else {
      //   if (temp.itemType.toLowerCase() == "addOn".toLowerCase()) {
      //     SunmiPrinter.text('    ${temp.itemName}',
      //         styles: SunmiStyles(bold: true));
      //   } else {
      //     SunmiPrinter.text('${temp.itemName}',
      //         styles: SunmiStyles(bold: true));
      //   }
      // }
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
        SunmiPrinter.text(
            '    ${temp.qty} x ${temp.unitPrice} = ${temp.total}  ${curency.baseCurrency}');
      } else {
        SunmiPrinter.text(
            '${temp.qty} x ${temp.unitPrice} = ${temp.total}  ${curency.baseCurrency}');
      }
    }
    SunmiPrinter.hr();
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'Sub-Total', align: SunmiAlign.left, width: 5),
      SunmiCol(text: ':', align: SunmiAlign.center, width: 1),
      SunmiCol(
          text: '${receiptInfoModel.printInvoice.subtotal} ',
          align: SunmiAlign.center,
          width: 4),
      SunmiCol(
          text: '${curency.baseCurrency}', align: SunmiAlign.right, width: 2),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'Discount', align: SunmiAlign.left, width: 5),
      SunmiCol(text: ':', align: SunmiAlign.center, width: 1),
      SunmiCol(
          text: '${receiptInfoModel.printInvoice.discountValue} ',
          align: SunmiAlign.center,
          width: 4),
      SunmiCol(
          text: '${curency.baseCurrency}', align: SunmiAlign.right, width: 2),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'GrandTotal', align: SunmiAlign.left, width: 5),
      SunmiCol(text: ':', align: SunmiAlign.center, width: 1),
      SunmiCol(
          text: '${receiptInfoModel.printInvoice.grandTotal} ',
          align: SunmiAlign.center,
          width: 4),
      SunmiCol(
          text: '${curency.baseCurrency}', align: SunmiAlign.right, width: 2),
    ]);
    SunmiPrinter.hr();
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'Receive', align: SunmiAlign.left, width: 5),
      SunmiCol(text: ':', align: SunmiAlign.center, width: 1),
      SunmiCol(
          text: '${_f.format(received)}', align: SunmiAlign.center, width: 4),
      SunmiCol(
          text: '${curency.baseCurrency}', align: SunmiAlign.right, width: 2),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'Return', align: SunmiAlign.left, width: 5),
      SunmiCol(text: ':', align: SunmiAlign.center, width: 1),
      SunmiCol(text: '$changed', align: SunmiAlign.center, width: 4),
      SunmiCol(
          text: '${curency.baseCurrency}', align: SunmiAlign.right, width: 2),
    ]);
    SunmiPrinter.hr();
    SunmiPrinter.text('${receiptInfoModel.printInvoice.description2}',
        styles: SunmiStyles(align: SunmiAlign.center));
    SunmiPrinter.emptyLines(3);
  }
}

//Khmer Receipt has logo
class PrintKhHasLogoPaymant {
  final ReceiptInfoModel receiptInfoModel;
  final DisplayPayOtherCurrency displayCurrency;
  PrintKhHasLogoPaymant({this.receiptInfoModel, this.displayCurrency});
  Future<void> startPrintPayment(String payBy, double received, String changed,
      String systemType, String customerName) async {
    var _f = NumberFormat('#,##0.00');
    var prefs = await SharedPreferences.getInstance();
    bool _isPrintAddress = prefs.getBool("isPrintAddress") ?? false;
    String img = prefs.getString('img');
    bool logoPrint = prefs.getBool('logoPrint') ?? false;
    bool _isPrintBranch = prefs.getBool("isPrintBranch") ?? false;
    bool _isShowCount = prefs.getBool("isShowCount");
    bool _isShowDateIn = prefs.getBool("isShowDateIn") ?? true;
    bool _isShowDateOut = prefs.getBool("isShowDateOut") ?? true;
    var curency = displayCurrency;
    img != null && logoPrint
        ? SunmiPrinter.image(img)
        : SunmiPrinter.text(
            '${receiptInfoModel.printInvoice.companyName}',
            styles: SunmiStyles(
                size: SunmiSize.xl, bold: true, align: SunmiAlign.center),
          );
    if (_isPrintBranch) {
      if (receiptInfoModel.printInvoice.branchName == null ||
          receiptInfoModel.printInvoice.branchName == "") {
      } else {
        SunmiPrinter.text("${receiptInfoModel.printInvoice.branchName}",
            styles: SunmiStyles(
                size: SunmiSize.md, bold: true, align: SunmiAlign.center));
      }
    }
    if (_isPrintAddress) {
      SunmiPrinter.text("${receiptInfoModel.printInvoice.address}",
          styles: SunmiStyles(
              size: SunmiSize.md, bold: true, align: SunmiAlign.center));
    }
    SunmiPrinter.text(
      '${receiptInfoModel.printInvoice.tel} | ${receiptInfoModel.printInvoice.tel2}',
      styles:
          SunmiStyles(size: SunmiSize.md, bold: true, align: SunmiAlign.center),
    );
    if (systemType == "KRMS") {
      SunmiPrinter.row(cols: [
        SunmiCol(
            text: "បុគ្គលិក : ${receiptInfoModel.printInvoice.userOrder}",
            width: 6),
        SunmiCol(text: "បង់ដោយ : $payBy", width: 6, align: SunmiAlign.right),
      ]);
    }
    if (systemType == "KBMS") {
      SunmiPrinter.row(cols: [
        SunmiCol(text: "បុគ្គលិក", width: 4, align: SunmiAlign.left),
        SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
        SunmiCol(text: '${receiptInfoModel.printInvoice.userOrder}', width: 7),
      ]);
    }
    SunmiPrinter.row(cols: [
      SunmiCol(text: "លេខវិក្កយបត្រ", width: 4, align: SunmiAlign.left),
      SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
      SunmiCol(text: '#${receiptInfoModel.printInvoice.receiptNo}', width: 7),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: "អតិថិជន", width: 4, align: SunmiAlign.left),
      SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
      SunmiCol(
          text: '${receiptInfoModel.printInvoice.customerInfo.split("/")[1]}',
          width: 7),
    ]);
    if (_isShowCount) {
      SunmiPrinter.row(cols: [
        SunmiCol(text: "ចំនួនដង", width: 4, align: SunmiAlign.left),
        SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
        SunmiCol(
            text: '${receiptInfoModel.printInvoice.countReceipt}', width: 7),
      ]);
    }
    if (systemType == "KBMS") {
      SunmiPrinter.row(cols: [
        SunmiCol(text: "បង់ដោយ", width: 4, align: SunmiAlign.left),
        SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
        SunmiCol(text: '$payBy', width: 7),
      ]);
    }
    if (systemType == "KRMS") {
      SunmiPrinter.row(cols: [
        SunmiCol(text: "តុ", width: 4, align: SunmiAlign.left),
        SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
        SunmiCol(text: '${receiptInfoModel.printInvoice.tableName}', width: 7),
      ]);
    }
    if (_isShowDateIn) {
      SunmiPrinter.row(cols: [
        SunmiCol(text: "ម៉ោងចូល", width: 4, align: SunmiAlign.left),
        SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
        SunmiCol(
          text:
              "${receiptInfoModel.printInvoice.dateIn.substring(0, receiptInfoModel.printInvoice.dateIn.length - 3)}",
          width: 7,
        )
      ]);
    }
    if (_isShowDateOut) {
      SunmiPrinter.row(cols: [
        SunmiCol(text: "ម៉ោងចេញ", width: 4, align: SunmiAlign.left),
        SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
        SunmiCol(
            text:
                "${receiptInfoModel.printInvoice.dateOut.substring(0, receiptInfoModel.printInvoice.dateOut.length - 3)}",
            width: 7)
      ]);
    }
    SunmiPrinter.hr();
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
            '    បញ្ចុះតម្លៃ % : ${temp.discountRate} ',
          );
        } else {
          SunmiPrinter.text(
            'បញ្ចុះតម្លៃ % : ${temp.discountRate} ',
          );
        }
      }
      if (temp.itemType.toLowerCase() == "addon") {
        SunmiPrinter.text(
            '    ${temp.qty} x ${temp.unitPrice} = ${temp.total}  ${curency.baseCurrency}');
      } else {
        SunmiPrinter.text(
            '${temp.qty} x ${temp.unitPrice} = ${temp.total}  ${curency.baseCurrency}');
      }
    }
    SunmiPrinter.hr();
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'ថ្លៃដើម', align: SunmiAlign.left, width: 3),
      SunmiCol(text: ':', align: SunmiAlign.center, width: 1),
      SunmiCol(
          text: '${receiptInfoModel.printInvoice.subtotal} ',
          align: SunmiAlign.center,
          width: 6),
      SunmiCol(
          text: '${curency.baseCurrency}', align: SunmiAlign.right, width: 2),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'បញ្ចុះតម្លៃ', align: SunmiAlign.left, width: 3),
      SunmiCol(text: ':', align: SunmiAlign.center, width: 1),
      SunmiCol(
          text: '${receiptInfoModel.printInvoice.discountValue} ',
          align: SunmiAlign.center,
          width: 6),
      SunmiCol(
          text: '${curency.baseCurrency}', align: SunmiAlign.right, width: 2),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'តម្លៃសរុប', align: SunmiAlign.left, width: 3),
      SunmiCol(text: ':', align: SunmiAlign.center, width: 1),
      SunmiCol(
          text: '${receiptInfoModel.printInvoice.grandTotal} ',
          align: SunmiAlign.center,
          width: 6),
      SunmiCol(
          text: '${curency.baseCurrency}', align: SunmiAlign.right, width: 2),
    ]);
    SunmiPrinter.hr();
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'លុយទទួល', align: SunmiAlign.left, width: 4),
      SunmiCol(text: ':', align: SunmiAlign.center, width: 1),
      SunmiCol(
          text: '${_f.format(received)}', align: SunmiAlign.center, width: 5),
      SunmiCol(
          text: '${curency.baseCurrency}', align: SunmiAlign.right, width: 2),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'លុយអាប់', align: SunmiAlign.left, width: 4),
      SunmiCol(text: ':', align: SunmiAlign.center, width: 1),
      SunmiCol(text: '$changed', align: SunmiAlign.center, width: 5),
      SunmiCol(
          text: '${curency.baseCurrency}', align: SunmiAlign.right, width: 2),
    ]);
    SunmiPrinter.hr();
    SunmiPrinter.text('${receiptInfoModel.printInvoice.description}',
        styles: SunmiStyles(align: SunmiAlign.center));
    SunmiPrinter.emptyLines(3);
  }
}

//print receipt khmer no logo
class PrintKhNoLogoPaymant {
  final ReceiptInfoModel receiptInfoModel;
  final DisplayPayOtherCurrency displayCurrency;
  PrintKhNoLogoPaymant({this.receiptInfoModel, this.displayCurrency});
  Future<void> startPrintPayment(String payBy, double received, String changed,
      String systemType, String customerName) async {
    var _f = NumberFormat('#,##0.00');
    var prefs = await SharedPreferences.getInstance();
    bool _isPrintAddress = prefs.getBool("isPrintAddress") ?? false;
    bool _isPrintBranch = prefs.getBool("isPrintBranch") ?? false;
    bool _isShowCount = prefs.getBool("isShowCount") ?? false;
    bool _isShowDateIn = prefs.getBool("isShowDateIn") ?? true;
    bool _isShowDateOut = prefs.getBool("isShowDateOut") ?? true;
    var curency = displayCurrency;
    SunmiPrinter.text(
      '${receiptInfoModel.printInvoice.companyName}',
      styles:
          SunmiStyles(size: SunmiSize.xl, bold: true, align: SunmiAlign.center),
    );
    if (_isPrintBranch) {
      if (receiptInfoModel.printInvoice.branchName == null ||
          receiptInfoModel.printInvoice.branchName == "") {
      } else {
        SunmiPrinter.text("${receiptInfoModel.printInvoice.branchName}",
            styles: SunmiStyles(
                size: SunmiSize.md, bold: true, align: SunmiAlign.center));
      }
    }
    if (_isPrintAddress) {
      SunmiPrinter.text("${receiptInfoModel.printInvoice.address}",
          styles: SunmiStyles(
              size: SunmiSize.md, bold: true, align: SunmiAlign.center));
    }
    SunmiPrinter.text(
      '${receiptInfoModel.printInvoice.tel} | ${receiptInfoModel.printInvoice.tel2}',
      styles:
          SunmiStyles(size: SunmiSize.md, bold: true, align: SunmiAlign.center),
    );
    if (systemType == "KRMS") {
      SunmiPrinter.row(cols: [
        SunmiCol(
            text: "បុគ្គលិក : ${receiptInfoModel.printInvoice.userOrder}",
            width: 6),
        SunmiCol(text: "បង់ដោយ : $payBy", width: 6, align: SunmiAlign.right),
      ]);
    }
    if (systemType == "KBMS") {
      SunmiPrinter.row(cols: [
        SunmiCol(text: "បុគ្គលិក", width: 4, align: SunmiAlign.left),
        SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
        SunmiCol(text: '${receiptInfoModel.printInvoice.userOrder}', width: 7),
      ]);
    }
    SunmiPrinter.row(cols: [
      SunmiCol(text: "លេខវិក្កយបត្រ", width: 4, align: SunmiAlign.left),
      SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
      SunmiCol(text: '#${receiptInfoModel.printInvoice.receiptNo}', width: 7),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: "អតិថិជន", width: 4, align: SunmiAlign.left),
      SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
      SunmiCol(
          text: '${receiptInfoModel.printInvoice.customerInfo.split("/")[1]}',
          width: 7),
    ]);
    if (_isShowCount) {
      SunmiPrinter.row(cols: [
        SunmiCol(text: "ចំនួនដង", width: 4, align: SunmiAlign.left),
        SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
        SunmiCol(
            text: '${receiptInfoModel.printInvoice.countReceipt}', width: 7),
      ]);
    }
    if (systemType == "KBMS") {
      SunmiPrinter.row(cols: [
        SunmiCol(text: "បង់ដោយ", width: 4, align: SunmiAlign.left),
        SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
        SunmiCol(text: '$payBy', width: 7),
      ]);
    }
    if (systemType == "KRMS") {
      SunmiPrinter.row(cols: [
        SunmiCol(text: "តុ", width: 4, align: SunmiAlign.left),
        SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
        SunmiCol(text: '${receiptInfoModel.printInvoice.tableName}', width: 7),
      ]);
    }
    if (_isShowDateIn) {
      SunmiPrinter.row(cols: [
        SunmiCol(text: "ម៉ោងចូល", width: 4, align: SunmiAlign.left),
        SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
        SunmiCol(
          text:
              "${receiptInfoModel.printInvoice.dateIn.substring(0, receiptInfoModel.printInvoice.dateIn.length - 3)}",
          width: 7,
        )
      ]);
    }
    if (_isShowDateOut) {
      SunmiPrinter.row(cols: [
        SunmiCol(text: "ម៉ោងចេញ", width: 4, align: SunmiAlign.left),
        SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
        SunmiCol(
            text:
                "${receiptInfoModel.printInvoice.dateOut.substring(0, receiptInfoModel.printInvoice.dateOut.length - 3)}",
            width: 7)
      ]);
    }
    SunmiPrinter.hr();
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
            '    បញ្ចុះតម្លៃ % : ${temp.discountRate} ',
          );
        } else {
          SunmiPrinter.text(
            'បញ្ចុះតម្លៃ % : ${temp.discountRate} ',
          );
        }
      }
      if (temp.itemType.toLowerCase() == "addon") {
        SunmiPrinter.text(
            '    ${temp.qty} x ${temp.unitPrice} = ${temp.total}  ${curency.baseCurrency}');
      } else {
        SunmiPrinter.text(
            '${temp.qty} x ${temp.unitPrice} = ${temp.total}  ${curency.baseCurrency}');
      }
    }
    SunmiPrinter.hr();
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'ថ្លៃដើម', align: SunmiAlign.left, width: 3),
      SunmiCol(text: ':', align: SunmiAlign.center, width: 1),
      SunmiCol(
          text: '${receiptInfoModel.printInvoice.subtotal} ',
          align: SunmiAlign.center,
          width: 6),
      SunmiCol(
          text: '${curency.baseCurrency}', align: SunmiAlign.right, width: 2),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'បញ្ចុះតម្លៃ', align: SunmiAlign.left, width: 3),
      SunmiCol(text: ':', align: SunmiAlign.center, width: 1),
      SunmiCol(
          text: '${receiptInfoModel.printInvoice.discountValue} ',
          align: SunmiAlign.center,
          width: 6),
      SunmiCol(
          text: '${curency.baseCurrency}', align: SunmiAlign.right, width: 2),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'តម្លៃសរុប', align: SunmiAlign.left, width: 3),
      SunmiCol(text: ':', align: SunmiAlign.center, width: 1),
      SunmiCol(
          text: '${receiptInfoModel.printInvoice.grandTotal} ',
          align: SunmiAlign.center,
          width: 6),
      SunmiCol(
          text: '${curency.baseCurrency}', align: SunmiAlign.right, width: 2),
    ]);
    SunmiPrinter.hr();
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'លុយទទួល', align: SunmiAlign.left, width: 4),
      SunmiCol(text: ':', align: SunmiAlign.center, width: 1),
      SunmiCol(
          text: '${_f.format(received)}', align: SunmiAlign.center, width: 5),
      SunmiCol(
          text: '${curency.baseCurrency}', align: SunmiAlign.right, width: 2),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'លុយអាប់', align: SunmiAlign.left, width: 4),
      SunmiCol(text: ':', align: SunmiAlign.center, width: 1),
      SunmiCol(text: '$changed', align: SunmiAlign.center, width: 5),
      SunmiCol(
          text: '${curency.baseCurrency}', align: SunmiAlign.right, width: 2),
    ]);
    SunmiPrinter.hr();
    SunmiPrinter.text('${receiptInfoModel.printInvoice.description}',
        styles: SunmiStyles(align: SunmiAlign.center));
    SunmiPrinter.emptyLines(3);
  }
}
