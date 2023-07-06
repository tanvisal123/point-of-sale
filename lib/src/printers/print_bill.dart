import 'package:flutter/cupertino.dart';
import 'package:flutter_sunmi_printer/flutter_sunmi_printer.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sale/src/models/fetch_oreder_model.dart';
import 'package:point_of_sale/src/models/receipt_info_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

//English Receipt Has Logo
class NewPrintBill {
  final ReceiptInfoModel receiptInfoModel;
  final FetchOrderModel fetchOrderModel;
  NewPrintBill(
      {@required this.receiptInfoModel, @required this.fetchOrderModel});
  Future<void> startPrintBill(
      String payBy, DisplayPayOtherCurrency currency) async {
    var prefs = await SharedPreferences.getInstance();
    String img = prefs.getString('img');
    bool logoPrint = prefs.getBool('logoPrint') ?? false;
    bool _isPrintAdress = prefs.getBool("isPrintAddress") ?? false;
    bool _isPrintBranch = prefs.getBool("isPrintBranch") ?? false;
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
    if (_isPrintAdress) {
      SunmiPrinter.text(
        '${receiptInfoModel.printInvoice.address}',
        styles: SunmiStyles(
            size: SunmiSize.md, bold: true, align: SunmiAlign.center),
      );
    }
    SunmiPrinter.text(
      '${receiptInfoModel.printInvoice.tel} | ${receiptInfoModel.printInvoice.tel2}',
      styles:
          SunmiStyles(size: SunmiSize.md, bold: true, align: SunmiAlign.center),
    );
    SunmiPrinter.row(cols: [
      SunmiCol(text: "Cashier", width: 4, align: SunmiAlign.left),
      SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
      SunmiCol(text: '#${receiptInfoModel.printInvoice.userOrder}', width: 7),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: "Table", width: 4, align: SunmiAlign.left),
      SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
      SunmiCol(text: '#${receiptInfoModel.printInvoice.tableName}', width: 7),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: "TimeIn", width: 4, align: SunmiAlign.left),
      SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
      SunmiCol(
          text: '${DateFormat('dd-MM-yyy hh:mm').format(DateTime.now())}',
          width: 7),
    ]);

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
            '    ${temp.qty} x ${temp.unitPrice} = ${temp.total}  ${currency.baseCurrency}');
      } else {
        SunmiPrinter.text(
            '${temp.qty} x ${temp.unitPrice} = ${temp.total}  ${currency.baseCurrency}');
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
          text: '${currency.baseCurrency}', align: SunmiAlign.right, width: 2),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'Discount', align: SunmiAlign.left, width: 5),
      SunmiCol(text: ':', align: SunmiAlign.center, width: 1),
      SunmiCol(
          text: '${receiptInfoModel.printInvoice.discountValue} ',
          align: SunmiAlign.center,
          width: 4),
      SunmiCol(
          text: '${currency.baseCurrency}', align: SunmiAlign.right, width: 2),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'GrandTotal', align: SunmiAlign.left, width: 5),
      SunmiCol(text: ':', align: SunmiAlign.center, width: 1),
      SunmiCol(
          text: '${receiptInfoModel.printInvoice.grandTotal} ',
          align: SunmiAlign.center,
          width: 4),
      SunmiCol(
          text: '${currency.baseCurrency}', align: SunmiAlign.right, width: 2),
    ]);

    SunmiPrinter.hr();
    // SunmiPrinter.text('Wifi Password: ${fetchOrderModel.setting.wifi}',
    //     styles: SunmiStyles(align: SunmiAlign.center));
    SunmiPrinter.text('${receiptInfoModel.printInvoice.description2}',
        styles: SunmiStyles(align: SunmiAlign.center));
    SunmiPrinter.emptyLines(3);
  }
}

//Englist receipt no logo
class EnPrintBillNoLogo {
  final ReceiptInfoModel receiptInfoModel;
  final FetchOrderModel fetchOrderModel;
  EnPrintBillNoLogo(
      {@required this.receiptInfoModel, @required this.fetchOrderModel});
  Future<void> startPrintBill(
      String payBy, DisplayPayOtherCurrency currency) async {
    var prefs = await SharedPreferences.getInstance();

    bool _isPrintAdress = prefs.getBool("isPrintAddress") ?? false;
    bool _isPrintBranch = prefs.getBool("isPrintBranch") ?? false;
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
    if (_isPrintAdress) {
      SunmiPrinter.text(
        '${receiptInfoModel.printInvoice.address}',
        styles: SunmiStyles(
            size: SunmiSize.md, bold: true, align: SunmiAlign.center),
      );
    }
    SunmiPrinter.text(
      '${receiptInfoModel.printInvoice.tel} | ${receiptInfoModel.printInvoice.tel2}',
      styles:
          SunmiStyles(size: SunmiSize.md, bold: true, align: SunmiAlign.center),
    );
    SunmiPrinter.row(cols: [
      SunmiCol(text: "Cashier", width: 4, align: SunmiAlign.left),
      SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
      SunmiCol(text: '#${receiptInfoModel.printInvoice.userOrder}', width: 7),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: "Table", width: 4, align: SunmiAlign.left),
      SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
      SunmiCol(text: '#${receiptInfoModel.printInvoice.tableName}', width: 7),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: "TimeIn", width: 4, align: SunmiAlign.left),
      SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
      SunmiCol(
          text: '${DateFormat('dd-MM-yyy hh:mm').format(DateTime.now())}',
          width: 7),
    ]);

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
            '    ${temp.qty} x ${temp.unitPrice} = ${temp.total}  ${currency.baseCurrency}');
      } else {
        SunmiPrinter.text(
            '${temp.qty} x ${temp.unitPrice} = ${temp.total}  ${currency.baseCurrency}');
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
          text: '${currency.baseCurrency}', align: SunmiAlign.right, width: 2),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'Discount', align: SunmiAlign.left, width: 5),
      SunmiCol(text: ':', align: SunmiAlign.center, width: 1),
      SunmiCol(
          text: '${receiptInfoModel.printInvoice.discountValue} ',
          align: SunmiAlign.center,
          width: 4),
      SunmiCol(
          text: '${currency.baseCurrency}', align: SunmiAlign.right, width: 2),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'GrandTotal', align: SunmiAlign.left, width: 5),
      SunmiCol(text: ':', align: SunmiAlign.center, width: 1),
      SunmiCol(
          text: '${receiptInfoModel.printInvoice.grandTotal} ',
          align: SunmiAlign.center,
          width: 4),
      SunmiCol(
          text: '${currency.baseCurrency}', align: SunmiAlign.right, width: 2),
    ]);
    SunmiPrinter.hr();
    // SunmiPrinter.text('Wifi Password: ${fetchOrderModel.setting.wifi}',
    //     styles: SunmiStyles(align: SunmiAlign.center));

    SunmiPrinter.text('${receiptInfoModel.printInvoice.description2}',
        styles: SunmiStyles(align: SunmiAlign.center));
    SunmiPrinter.emptyLines(3);
  }
}

//Khmer has Logo
class KhPrintBillHasLogo {
  final ReceiptInfoModel receiptInfoModel;
  final FetchOrderModel fetchOrderModel;
  KhPrintBillHasLogo(
      {@required this.receiptInfoModel, @required this.fetchOrderModel});
  Future<void> startPrintBill(
      String payBy, DisplayPayOtherCurrency currency) async {
    var prefs = await SharedPreferences.getInstance();
    String img = prefs.getString('img');
    bool logoPrint = prefs.getBool('logoPrint') ?? false;
    bool _isPrintAdress = prefs.getBool("isPrintAddress") ?? true;
    bool _isPrintBranch = prefs.getBool("isPrintBranch") ?? false;
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
    if (_isPrintAdress) {
      SunmiPrinter.text(
        '${receiptInfoModel.printInvoice.address}',
        styles: SunmiStyles(
            size: SunmiSize.md, bold: true, align: SunmiAlign.center),
      );
    }
    SunmiPrinter.text(
      '${receiptInfoModel.printInvoice.tel} | ${receiptInfoModel.printInvoice.tel2}',
      styles:
          SunmiStyles(size: SunmiSize.md, bold: true, align: SunmiAlign.center),
    );
    SunmiPrinter.row(cols: [
      SunmiCol(text: "បុគ្គលិក", width: 4, align: SunmiAlign.left),
      SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
      SunmiCol(text: '${receiptInfoModel.printInvoice.userOrder}', width: 7),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: "តុ", width: 4, align: SunmiAlign.left),
      SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
      SunmiCol(text: '${receiptInfoModel.printInvoice.tableName}', width: 7),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: "ម៉ោងចេញ", width: 4, align: SunmiAlign.left),
      SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
      SunmiCol(
          text: "${DateFormat('dd-MM-yyy hh:mm').format(DateTime.now())}",
          width: 7)
    ]);
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
            '    ${temp.qty} x ${temp.unitPrice} = ${temp.total}  ${currency.baseCurrency}');
      } else {
        SunmiPrinter.text(
            '${temp.qty} x ${temp.unitPrice} = ${temp.total}  ${currency.baseCurrency}');
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
          text: '${currency.baseCurrency}', align: SunmiAlign.right, width: 2),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'បញ្ចុះតម្លៃ', align: SunmiAlign.left, width: 3),
      SunmiCol(text: ':', align: SunmiAlign.center, width: 1),
      SunmiCol(
          text: '${receiptInfoModel.printInvoice.discountValue} ',
          align: SunmiAlign.center,
          width: 6),
      SunmiCol(
          text: '${currency.baseCurrency}', align: SunmiAlign.right, width: 2),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'តម្លៃសរុប', align: SunmiAlign.left, width: 3),
      SunmiCol(text: ':', align: SunmiAlign.center, width: 1),
      SunmiCol(
          text: '${receiptInfoModel.printInvoice.grandTotal} ',
          align: SunmiAlign.center,
          width: 6),
      SunmiCol(
          text: '${currency.baseCurrency}', align: SunmiAlign.right, width: 2),
    ]);
    SunmiPrinter.hr();
    // SunmiPrinter.text('Wifi Password: ${fetchOrderModel.setting.wifi}',
    //     styles: SunmiStyles(align: SunmiAlign.center));
    SunmiPrinter.text('${receiptInfoModel.printInvoice.description}',
        styles: SunmiStyles(align: SunmiAlign.center));
    SunmiPrinter.emptyLines(3);
  }
}

//Khmer no logo
class KhPrintBillNoLogo {
  final ReceiptInfoModel receiptInfoModel;
  final FetchOrderModel fetchOrderModel;
  KhPrintBillNoLogo(
      {@required this.receiptInfoModel, @required this.fetchOrderModel});
  Future<void> startPrintBill(
      String payBy, DisplayPayOtherCurrency currency) async {
    var prefs = await SharedPreferences.getInstance();
    bool _isPrintAdress = prefs.getBool("isPrintAddress") ?? false;
    bool _isPrintBranch = prefs.getBool("isPrintBranch") ?? false;
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
    if (_isPrintAdress) {
      SunmiPrinter.text(
        '${receiptInfoModel.printInvoice.address}',
        styles: SunmiStyles(
            size: SunmiSize.md, bold: true, align: SunmiAlign.center),
      );
    }
    SunmiPrinter.text(
      '${receiptInfoModel.printInvoice.tel} | ${receiptInfoModel.printInvoice.tel2}',
      styles:
          SunmiStyles(size: SunmiSize.md, bold: true, align: SunmiAlign.center),
    );
    SunmiPrinter.row(cols: [
      SunmiCol(text: "បុគ្គលិក", width: 4, align: SunmiAlign.left),
      SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
      SunmiCol(text: '${receiptInfoModel.printInvoice.userOrder}', width: 7),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: "តុ", width: 4, align: SunmiAlign.left),
      SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
      SunmiCol(text: '${receiptInfoModel.printInvoice.tableName}', width: 7),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: "ម៉ោងចេញ", width: 4, align: SunmiAlign.left),
      SunmiCol(text: ":", width: 1, align: SunmiAlign.center),
      SunmiCol(
          text: "${DateFormat('dd-MM-yyy hh:mm').format(DateTime.now())}",
          width: 7)
    ]);
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
            '    ${temp.qty} x ${temp.unitPrice} = ${temp.total}  ${currency.baseCurrency}');
      } else {
        SunmiPrinter.text(
            '${temp.qty} x ${temp.unitPrice} = ${temp.total}  ${currency.baseCurrency}');
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
          text: '${currency.baseCurrency}', align: SunmiAlign.right, width: 2),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'បញ្ចុះតម្លៃ', align: SunmiAlign.left, width: 3),
      SunmiCol(text: ':', align: SunmiAlign.center, width: 1),
      SunmiCol(
          text: '${receiptInfoModel.printInvoice.discountValue} ',
          align: SunmiAlign.center,
          width: 6),
      SunmiCol(
          text: '${currency.baseCurrency}', align: SunmiAlign.right, width: 2),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'តម្លៃសរុប', align: SunmiAlign.left, width: 3),
      SunmiCol(text: ':', align: SunmiAlign.center, width: 1),
      SunmiCol(
          text: '${receiptInfoModel.printInvoice.grandTotal} ',
          align: SunmiAlign.center,
          width: 6),
      SunmiCol(
          text: '${currency.baseCurrency}', align: SunmiAlign.right, width: 2),
    ]);
    SunmiPrinter.hr();
    // SunmiPrinter.text('Wifi Password: ${fetchOrderModel.setting.wifi}',
    //     styles: SunmiStyles(align: SunmiAlign.center));
    SunmiPrinter.text('${receiptInfoModel.printInvoice.description}',
        styles: SunmiStyles(align: SunmiAlign.center));
    SunmiPrinter.emptyLines(3);
  }
}
