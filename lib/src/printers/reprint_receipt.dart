import 'package:intl/intl.dart';
import 'package:flutter_sunmi_printer/flutter_sunmi_printer.dart';
import 'package:point_of_sale/src/models/reprint_receipt_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

//reprint english receipt with logo
class ReprintReceipt {
  List<ReprintReceiptModel> reprintReceipt;
  ReprintReceipt({this.reprintReceipt});
  Future<void> startReprint(String systemType) async {
    var _f = NumberFormat('#,##0.00');
    var prefs = await SharedPreferences.getInstance();
    String img = prefs.getString('img');
    bool logoPrint = prefs.getBool('logoPrint') ?? false;
    bool _isPrintBranch = prefs.getBool("isPrintBranch") ?? false;
    bool _isPrintAddress = prefs.getBool("isPrintAddress") ?? false;
    bool _isShowCount = prefs.getBool("isShowCount") ?? false;
    img != null && logoPrint
        ? SunmiPrinter.image(img)
        : SunmiPrinter.text(
            '${reprintReceipt.first.company}',
            styles: SunmiStyles(
                size: SunmiSize.xl, bold: true, align: SunmiAlign.center),
          );

    if (_isPrintBranch) {
      if (reprintReceipt.first.branchName == null ||
          reprintReceipt.first.branchName == "") {
      } else {
        SunmiPrinter.text("${reprintReceipt.first.branchName}",
            styles: SunmiStyles(
                size: SunmiSize.md, bold: true, align: SunmiAlign.center));
      }
    }
    if (_isPrintAddress) {
      SunmiPrinter.text("${reprintReceipt.first.address}",
          styles: SunmiStyles(
              size: SunmiSize.md, bold: true, align: SunmiAlign.center));
    }
    SunmiPrinter.text(
      '${reprintReceipt.first.tel1} | ${reprintReceipt.first.tel2}',
      styles:
          SunmiStyles(size: SunmiSize.md, bold: true, align: SunmiAlign.center),
    );
    if (systemType == "KRMS") {
      SunmiPrinter.row(cols: [
        SunmiCol(
            text: 'Cashier :${reprintReceipt.first.cashier}',
            width: 6,
            align: SunmiAlign.left),
        SunmiCol(
            text: 'Pay By:${reprintReceipt.first.paymentMeans}',
            width: 6,
            align: SunmiAlign.right)
      ]);
    }
    if (systemType == "KBMS") {
      SunmiPrinter.text('Cashier   : ${reprintReceipt.first.cashier}');
    }

    SunmiPrinter.text(
        'Customer  : ${reprintReceipt.first.customerInfo.split("/")[1]}');
    if (_isShowCount) {
      SunmiPrinter.text("Count : ${reprintReceipt.first.receiptCount}");
    }
    SunmiPrinter.text('Receipt№ : #${reprintReceipt.first.receiptNo}');
    if (systemType == "KRMS") {
      SunmiPrinter.text('Table     : ${reprintReceipt.first.table}');
      // SunmiPrinter.text('Queue     : ${receiptInfoModel.receipt.queueNo}');
    }
    //
    if (systemType == "KBMS") {
      SunmiPrinter.text('Pay-by    : ${reprintReceipt.first.paymentMeans}');
      SunmiPrinter.text('Time-In   : ${reprintReceipt.first.dateTimeIn}');
    }
    SunmiPrinter.text('Time-Out  : ${reprintReceipt.first.dateTimeOut}');
    SunmiPrinter.hr();
    for (var temp in reprintReceipt) {
      // if (double.parse(temp.qty) != 0) {
      SunmiPrinter.text('${temp.item}', styles: SunmiStyles(bold: true));
      if (temp.disRate != '0%') {
        SunmiPrinter.text(
          'Discount  : ${temp.disItem} ',
        );
      }
      SunmiPrinter.text('${temp.qty} x ${temp.price} = ${temp.amount}');
      //}
    }
    SunmiPrinter.hr();

    SunmiPrinter.row(cols: [
      SunmiCol(text: 'Sub-Total   :', align: SunmiAlign.left, width: 5),
      SunmiCol(
          text: '${reprintReceipt.first.subTotal} ',
          align: SunmiAlign.center,
          width: 7),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'Discount    :', align: SunmiAlign.left, width: 5),
      SunmiCol(
          text: '${reprintReceipt.first.disValue} ',
          align: SunmiAlign.center,
          width: 7),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'Grand-Total :', align: SunmiAlign.left, width: 5),
      SunmiCol(
          text: '${reprintReceipt.first.grandTotal} ',
          align: SunmiAlign.center,
          width: 7),
    ]);
    SunmiPrinter.hr();
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'Received   :', align: SunmiAlign.left, width: 5),
      SunmiCol(
          text: '${reprintReceipt.first.received}',
          align: SunmiAlign.center,
          width: 7),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'Changed    :', align: SunmiAlign.left, width: 5),
      SunmiCol(
          text: '${reprintReceipt.first.change}',
          align: SunmiAlign.center,
          width: 7),
    ]);
    SunmiPrinter.hr();
    SunmiPrinter.text('${reprintReceipt.first.descEn}',
        styles: SunmiStyles(align: SunmiAlign.center));
    SunmiPrinter.text('${reprintReceipt.first.descKh}',
        styles: SunmiStyles(align: SunmiAlign.center));

    SunmiPrinter.emptyLines(3);
  }
}

//reprint english receipt no logo
class ReprintEnNoLogoReceipt {
  List<ReprintReceiptModel> reprintReceipt;
  ReprintEnNoLogoReceipt({this.reprintReceipt});
  Future<void> startReprint(String systemType) async {
    var _f = NumberFormat('#,##0.00');
    var prefs = await SharedPreferences.getInstance();
    bool _isPrintBranch = prefs.getBool("isPrintBranch") ?? false;
    bool _isPrintAddress = prefs.getBool("isPrintAddress") ?? false;
    bool _isShowCount = prefs.getBool("isShowCount") ?? false;
    SunmiPrinter.text(
      '${reprintReceipt.first.company}',
      styles:
          SunmiStyles(size: SunmiSize.xl, bold: true, align: SunmiAlign.center),
    );
    if (_isPrintBranch) {
      if (reprintReceipt.first.branchName == null ||
          reprintReceipt.first.branchName == "") {
      } else {
        SunmiPrinter.text("${reprintReceipt.first.branchName}",
            styles: SunmiStyles(
                size: SunmiSize.md, bold: true, align: SunmiAlign.center));
      }
    }
    if (_isPrintAddress) {
      SunmiPrinter.text("${reprintReceipt.first.address}",
          styles: SunmiStyles(
              size: SunmiSize.md, bold: true, align: SunmiAlign.center));
    }
    // SunmiPrinter.text("${reprintReceipt.first.branchName}",
    //     styles: SunmiStyles(
    //         size: SunmiSize.md, bold: true, align: SunmiAlign.center));
    SunmiPrinter.text(
      '${reprintReceipt.first.tel1} | ${reprintReceipt.first.tel2}',
      styles:
          SunmiStyles(size: SunmiSize.md, bold: true, align: SunmiAlign.center),
    );
    if (systemType == "KRMS") {
      SunmiPrinter.row(cols: [
        SunmiCol(
            text: 'Cashier :${reprintReceipt.first.cashier}',
            width: 6,
            align: SunmiAlign.left),
        SunmiCol(
            text: 'Pay By:${reprintReceipt.first.paymentMeans}',
            width: 6,
            align: SunmiAlign.right)
      ]);
    }
    if (systemType == "KBMS") {
      SunmiPrinter.text('Cashier   : ${reprintReceipt.first.cashier}');
    }

    SunmiPrinter.text(
        'Customer  : ${reprintReceipt.first.customerInfo.split("/")[1]}');
    if (_isShowCount) {
      SunmiPrinter.text("Count : ${reprintReceipt.first.receiptCount}");
    }
    SunmiPrinter.text('Receipt№ : #${reprintReceipt.first.receiptNo}');
    if (systemType == "KRMS") {
      SunmiPrinter.text('Table     : ${reprintReceipt.first.table}');
      // SunmiPrinter.text('Queue     : ${receiptInfoModel.receipt.queueNo}');
    }
    //
    if (systemType == "KBMS") {
      SunmiPrinter.text('Pay-by    : ${reprintReceipt.first.paymentMeans}');
      SunmiPrinter.text('Time-In   : ${reprintReceipt.first.dateTimeIn}');
    }
    SunmiPrinter.text('Time-Out  : ${reprintReceipt.first.dateTimeOut}');
    SunmiPrinter.hr();
    for (var temp in reprintReceipt) {
      // if (double.parse(temp.qty) != 0) {
      SunmiPrinter.text('${temp.item}', styles: SunmiStyles(bold: true));
      if (temp.disRate != '0%') {
        SunmiPrinter.text(
          'Discount  : ${temp.disItem} ',
        );
      }
      SunmiPrinter.text('${temp.qty} x ${temp.price} = ${temp.amount}');
      //}
    }
    SunmiPrinter.hr();

    SunmiPrinter.row(cols: [
      SunmiCol(text: 'Sub-Total   :', align: SunmiAlign.left, width: 5),
      SunmiCol(
          text: '${reprintReceipt.first.subTotal} ',
          align: SunmiAlign.center,
          width: 7),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'Discount    :', align: SunmiAlign.left, width: 5),
      SunmiCol(
          text: '${reprintReceipt.first.disValue} ',
          align: SunmiAlign.center,
          width: 7),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'Grand-Total :', align: SunmiAlign.left, width: 5),
      SunmiCol(
          text: '${reprintReceipt.first.grandTotal} ',
          align: SunmiAlign.center,
          width: 7),
    ]);
    SunmiPrinter.hr();
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'Received   :', align: SunmiAlign.left, width: 5),
      SunmiCol(
          text: '${reprintReceipt.first.received}',
          align: SunmiAlign.center,
          width: 7),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'Changed    :', align: SunmiAlign.left, width: 5),
      SunmiCol(
          text: '${reprintReceipt.first.change}',
          align: SunmiAlign.center,
          width: 7),
    ]);
    SunmiPrinter.hr();
    SunmiPrinter.text('${reprintReceipt.first.descEn}',
        styles: SunmiStyles(align: SunmiAlign.center));
    SunmiPrinter.text('${reprintReceipt.first.descKh}',
        styles: SunmiStyles(align: SunmiAlign.center));

    SunmiPrinter.emptyLines(3);
  }
}

//reprint khmer receipt with loga
class ReprintKHLogoReceipt {
  List<ReprintReceiptModel> reprintReceipt;
  ReprintKHLogoReceipt({this.reprintReceipt});
  Future<void> startReprint(String systemType) async {
    var _f = NumberFormat('#,##0.00');
    var prefs = await SharedPreferences.getInstance();
    bool _isPrintBranch = prefs.getBool("isPrintBranch") ?? false;
    bool _isPrintAddress = prefs.getBool("isPrintAddress") ?? false;
    String img = prefs.getString('img');
    bool logoPrint = prefs.getBool('logoPrint') ?? false;
    bool _isShowCount = prefs.getBool("isShowCount") ?? false;
    img != null && logoPrint
        ? SunmiPrinter.image(img)
        : SunmiPrinter.text(
            '${reprintReceipt.first.company}',
            styles: SunmiStyles(
                size: SunmiSize.xl, bold: true, align: SunmiAlign.center),
          );
    if (_isPrintBranch) {
      if (reprintReceipt.first.branchName == null ||
          reprintReceipt.first.branchName == "") {
      } else {
        SunmiPrinter.text("${reprintReceipt.first.branchName}",
            styles: SunmiStyles(
                size: SunmiSize.md, bold: true, align: SunmiAlign.center));
      }
    }
    if (_isPrintAddress) {
      SunmiPrinter.text("${reprintReceipt.first.address}",
          styles: SunmiStyles(
              size: SunmiSize.md, bold: true, align: SunmiAlign.center));
    }
    // SunmiPrinter.text("${reprintReceipt.first.branchName}",
    //     styles: SunmiStyles(
    //         size: SunmiSize.md, bold: true, align: SunmiAlign.center));
    SunmiPrinter.text(
      '${reprintReceipt.first.tel1} | ${reprintReceipt.first.tel2}',
      styles:
          SunmiStyles(size: SunmiSize.md, bold: true, align: SunmiAlign.center),
    );
    if (systemType == "KRMS") {
      SunmiPrinter.row(cols: [
        SunmiCol(
            text: 'បុគ្កលិក :${reprintReceipt.first.cashier}',
            width: 6,
            align: SunmiAlign.left),
        SunmiCol(
            text: 'ប៉ង​ដោយ: ${reprintReceipt.first.paymentMeans}',
            width: 6,
            align: SunmiAlign.right)
      ]);
    }
    if (systemType == "KBMS") {
      SunmiPrinter.text('បុគ្កលិក   : ${reprintReceipt.first.cashier}');
    }
    SunmiPrinter.text(
        'អតិថិជន  : ${reprintReceipt.first.customerInfo.split("/")[1]}');
    if (_isShowCount) {
      SunmiPrinter.text("ចំនួនដង :​ ${reprintReceipt.first.receiptCount}");
    }
    SunmiPrinter.text('លេខវិក័យប័ត្រ : #${reprintReceipt.first.receiptNo}');
    if (systemType == "KRMS") {
      SunmiPrinter.text('តុ     : ${reprintReceipt.first.table}');
      // SunmiPrinter.text('Queue     : ${receiptInfoModel.receipt.queueNo}');
    }
    //
    if (systemType == "KBMS") {
      SunmiPrinter.text('ប៉ង​ដោយ    : ${reprintReceipt.first.paymentMeans}');
      SunmiPrinter.text('ម៉ោងចូល   : ${reprintReceipt.first.dateTimeIn}');
    }
    SunmiPrinter.text('ម៉ោងចេញ  : ${reprintReceipt.first.dateTimeOut}');
    SunmiPrinter.hr();
    for (var temp in reprintReceipt) {
      // if (double.parse(temp.qty) != 0) {
      SunmiPrinter.text('${temp.item}', styles: SunmiStyles(bold: true));
      if (temp.disRate != '0%') {
        SunmiPrinter.text(
          'បញ្ចុះតម្លៃ  : ${temp.disItem} ',
        );
      }
      SunmiPrinter.text('${temp.qty} x ${temp.price} = ${temp.amount}');
      //}
    }
    SunmiPrinter.hr();

    SunmiPrinter.row(cols: [
      SunmiCol(text: 'ថ្លៃដើម   :', align: SunmiAlign.left, width: 5),
      SunmiCol(
          text: '${reprintReceipt.first.subTotal} ',
          align: SunmiAlign.center,
          width: 7),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'បញ្ចុះតម្លៃ    :', align: SunmiAlign.left, width: 5),
      SunmiCol(
          text: '${reprintReceipt.first.disValue} ',
          align: SunmiAlign.center,
          width: 7),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'តម្លែសរុប :', align: SunmiAlign.left, width: 5),
      SunmiCol(
          text: '${reprintReceipt.first.grandTotal} ',
          align: SunmiAlign.center,
          width: 7),
    ]);
    SunmiPrinter.hr();
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'លុយទទួល   :', align: SunmiAlign.left, width: 5),
      SunmiCol(
          text: '${reprintReceipt.first.received}',
          align: SunmiAlign.center,
          width: 7),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'លុយអាប់    :', align: SunmiAlign.left, width: 5),
      SunmiCol(
          text: '${reprintReceipt.first.change}',
          align: SunmiAlign.center,
          width: 7),
    ]);
    SunmiPrinter.hr();
    SunmiPrinter.text('${reprintReceipt.first.descEn}',
        styles: SunmiStyles(align: SunmiAlign.center));
    SunmiPrinter.text('${reprintReceipt.first.descKh}',
        styles: SunmiStyles(align: SunmiAlign.center));

    SunmiPrinter.emptyLines(3);
  }
}

//reprint khmer receipt no logo
class ReprintKhNoLogoReceipt {
  List<ReprintReceiptModel> reprintReceipt;
  ReprintKhNoLogoReceipt({this.reprintReceipt});
  Future<void> startReprint(String systemType) async {
    var _f = NumberFormat('#,##0.00');
    var prefs = await SharedPreferences.getInstance();
    bool _isPrintBranch = prefs.getBool("isPrintBranch") ?? false;
    bool _isPrintAddress = prefs.getBool("isPrintAddress") ?? false;
    bool _isShowCount = prefs.getBool("isShowCount") ?? false;
    SunmiPrinter.text(
      '${reprintReceipt.first.company}',
      styles:
          SunmiStyles(size: SunmiSize.xl, bold: true, align: SunmiAlign.center),
    );
    if (_isPrintBranch) {
      if (reprintReceipt.first.branchName == null ||
          reprintReceipt.first.branchName == "") {
      } else {
        SunmiPrinter.text("${reprintReceipt.first.branchName}",
            styles: SunmiStyles(
                size: SunmiSize.md, bold: true, align: SunmiAlign.center));
      }
    }
    if (_isPrintAddress) {
      SunmiPrinter.text("${reprintReceipt.first.address}",
          styles: SunmiStyles(
              size: SunmiSize.md, bold: true, align: SunmiAlign.center));
    }
    // SunmiPrinter.text("${reprintReceipt.first.branchName}",
    //     styles: SunmiStyles(
    //         size: SunmiSize.md, bold: true, align: SunmiAlign.center));
    SunmiPrinter.text(
      '${reprintReceipt.first.tel1} | ${reprintReceipt.first.tel2}',
      styles:
          SunmiStyles(size: SunmiSize.md, bold: true, align: SunmiAlign.center),
    );
    if (systemType == "KRMS") {
      SunmiPrinter.row(cols: [
        SunmiCol(
            text: 'បុគ្កលិក :${reprintReceipt.first.cashier}',
            width: 6,
            align: SunmiAlign.left),
        SunmiCol(
            text: 'ប៉ង​ដោយ: ${reprintReceipt.first.paymentMeans}',
            width: 6,
            align: SunmiAlign.right)
      ]);
    }
    if (systemType == "KBMS") {
      SunmiPrinter.text('បុគ្កលិក   : ${reprintReceipt.first.cashier}');
    }

    SunmiPrinter.text(
        'អតិថិជន  : ${reprintReceipt.first.customerInfo.split("/")[1]} (${reprintReceipt.first.receiptCount})');
    if (_isShowCount) {
      SunmiPrinter.text("ចំនួនដង :​ ${reprintReceipt.first.receiptCount}");
    }
    SunmiPrinter.text('លេខវិក័យប័ត្រ : #${reprintReceipt.first.receiptNo}');
    if (systemType == "KRMS") {
      SunmiPrinter.text('តុ     : ${reprintReceipt.first.table}');
      // SunmiPrinter.text('Queue     : ${receiptInfoModel.receipt.queueNo}');
    }
    //
    if (systemType == "KBMS") {
      SunmiPrinter.text('ប៉ង​ដោយ    : ${reprintReceipt.first.paymentMeans}');
      SunmiPrinter.text('ម៉ោងចូល   : ${reprintReceipt.first.dateTimeIn}');
    }
    SunmiPrinter.text('ម៉ោងចេញ  : ${reprintReceipt.first.dateTimeOut}');
    SunmiPrinter.hr();
    for (var temp in reprintReceipt) {
      // if (double.parse(temp.qty) != 0) {
      SunmiPrinter.text('${temp.item}', styles: SunmiStyles(bold: true));
      if (temp.disRate != '0%') {
        SunmiPrinter.text(
          'បញ្ចុះតម្លៃ  : ${temp.disItem} ',
        );
      }
      SunmiPrinter.text('${temp.qty} x ${temp.price} = ${temp.amount}');
      //}
    }
    SunmiPrinter.hr();

    SunmiPrinter.row(cols: [
      SunmiCol(text: 'ថ្លៃដើម   :', align: SunmiAlign.left, width: 5),
      SunmiCol(
          text: '${reprintReceipt.first.subTotal} ',
          align: SunmiAlign.center,
          width: 7),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'បញ្ចុះតម្លៃ    :', align: SunmiAlign.left, width: 5),
      SunmiCol(
          text: '${reprintReceipt.first.disValue} ',
          align: SunmiAlign.center,
          width: 7),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'តម្លែសរុប :', align: SunmiAlign.left, width: 5),
      SunmiCol(
          text: '${reprintReceipt.first.grandTotal} ',
          align: SunmiAlign.center,
          width: 7),
    ]);
    SunmiPrinter.hr();
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'លុយទទួល   :', align: SunmiAlign.left, width: 5),
      SunmiCol(
          text: '${reprintReceipt.first.received}',
          align: SunmiAlign.center,
          width: 7),
    ]);
    SunmiPrinter.row(cols: [
      SunmiCol(text: 'លុយអាប់    :', align: SunmiAlign.left, width: 5),
      SunmiCol(
          text: '${reprintReceipt.first.change}',
          align: SunmiAlign.center,
          width: 7),
    ]);
    SunmiPrinter.hr();
    SunmiPrinter.text('${reprintReceipt.first.descEn}',
        styles: SunmiStyles(align: SunmiAlign.center));
    SunmiPrinter.text('${reprintReceipt.first.descKh}',
        styles: SunmiStyles(align: SunmiAlign.center));

    SunmiPrinter.emptyLines(3);
  }
}
