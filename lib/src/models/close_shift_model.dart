// To parse this JSON data, do
//
//     final processCloseShift = processCloseShiftFromJson(jsonString);

import 'dart:convert';

ProccesCloseShift processCloseShiftFromJson(String str) =>
    ProccesCloseShift.fromJson(json.decode(str));

String processCloseShiftToJson(ProccesCloseShift data) =>
    json.encode(data.toJson());

class ProccesCloseShift {
  ProccesCloseShift({
    this.data,
    this.items,
    this.action,
    this.isRejected,
    this.isAlerted,
    this.isApproved,
    this.count,
    this.redirect,
  });

  Data data;
  Items items;
  int action;
  bool isRejected;
  bool isAlerted;
  bool isApproved;
  int count;
  dynamic redirect;

  factory ProccesCloseShift.fromJson(Map<String, dynamic> json) =>
      ProccesCloseShift(
        data: Data.fromJson(json["Data"]),
        items: Items.fromJson(json["Items"]),
        action: json["Action"],
        isRejected: json["IsRejected"],
        isAlerted: json["IsAlerted"],
        isApproved: json["IsApproved"],
        count: json["Count"],
        redirect: json["Redirect"],
      );

  Map<String, dynamic> toJson() => {
        "Data": data.toJson(),
        "Items": items.toJson(),
        "Action": action,
        "IsRejected": isRejected,
        "IsAlerted": isAlerted,
        "IsApproved": isApproved,
        "Count": count,
        "Redirect": redirect,
      };
}

class Data {
  Data();

  factory Data.fromJson(Map<String, dynamic> json) => Data();

  Map<String, dynamic> toJson() => {};
}

class Items {
  Items({
    this.closeShift,
  });

  List<CloseShift> closeShift;

  factory Items.fromJson(Map<String, dynamic> json) => Items(
        closeShift: List<CloseShift>.from(
            json["CloseShift"].map((x) => CloseShift.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "CloseShift": List<dynamic>.from(closeShift.map((x) => x.toJson())),
      };
}

class CloseShift {
  CloseShift({
    this.id,
    this.code,
    this.barcode,
    this.khmerName,
    this.englishName,
    this.qty,
    this.price,
    this.disItemValue,
    this.total,
    this.currency,
    this.currencySys,
    this.totalSoldAmount,
    this.totalDiscountItem,
    this.totalDiscountTotal,
    this.totalVat,
    this.grandTotal,
    this.grandTotalSys,
    this.totalCashInSys,
    this.totalCashOutSys,
    this.exchangeRate,
    this.grandTotalDisplay,
    this.exchangeRateDisplay,
    this.currencyDisplay,
    this.receiptNo,
    this.amount,
    this.itemGroup1,
    this.itemGroup2,
    this.itemGroup3,
    this.dateIn,
    this.dateOut,
    this.timeIn,
    this.timeOut,
    this.empName,
    this.uom,
    this.totalCal,
    this.isNone,
  });

  int id;
  String code;
  String barcode;
  String khmerName;
  String englishName;
  String qty;
  String price;
  String disItemValue;
  String total;
  String currency;
  String currencySys;
  String totalSoldAmount;
  String totalDiscountItem;
  String totalDiscountTotal;
  String totalVat;
  String grandTotal;
  String grandTotalSys;
  String totalCashInSys;
  String totalCashOutSys;
  String exchangeRate;
  dynamic grandTotalDisplay;
  dynamic exchangeRateDisplay;
  dynamic currencyDisplay;
  String receiptNo;
  dynamic amount;
  String itemGroup1;
  String itemGroup2;
  String itemGroup3;
  String dateIn;
  String dateOut;
  String timeIn;
  String timeOut;
  String empName;
  String uom;
  double totalCal;
  bool isNone;

  factory CloseShift.fromJson(Map<String, dynamic> json) => CloseShift(
        id: json["ID"],
        code: json["Code"],
        barcode: json["Barcode"],
        khmerName: json["KhmerName"],
        englishName: json["EnglishName"],
        qty: json["Qty"],
        price: json["Price"],
        disItemValue: json["DisItemValue"],
        total: json["Total"],
        currency: json["Currency"],
        currencySys: json["Currency_Sys"],
        totalSoldAmount: json["TotalSoldAmount"],
        totalDiscountItem: json["TotalDiscountItem"],
        totalDiscountTotal: json["TotalDiscountTotal"],
        totalVat: json["TotalVat"],
        grandTotal: json["GrandTotal"],
        grandTotalSys: json["GrandTotal_Sys"],
        totalCashInSys: json["TotalCashIn_Sys"],
        totalCashOutSys: json["TotalCashOut_Sys"],
        exchangeRate: json["ExchangeRate"],
        grandTotalDisplay: json["GrandTotal_Display"],
        exchangeRateDisplay: json["ExchangeRate_Display"],
        currencyDisplay: json["CurrencyDisplay"],
        receiptNo: json["ReceiptNo"],
        amount: json["Amount"],
        itemGroup1: json["ItemGroup1"],
        itemGroup2: json["ItemGroup2"],
        itemGroup3: json["ItemGroup3"],
        dateIn: json["DateIn"],
        dateOut: json["DateOut"],
        timeIn: json["TimeIn"],
        timeOut: json["TimeOut"],
        empName: json["EmpName"],
        uom: json["Uom"],
        totalCal: json["TotalCal"].toDouble(),
        isNone: json["IsNone"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Code": code,
        "Barcode": barcode,
        "KhmerName": khmerName,
        "EnglishName": englishName,
        "Qty": qty,
        "Price": price,
        "DisItemValue": disItemValue,
        "Total": total,
        "Currency": currency,
        "Currency_Sys": currencySys,
        "TotalSoldAmount": totalSoldAmount,
        "TotalDiscountItem": totalDiscountItem,
        "TotalDiscountTotal": totalDiscountTotal,
        "TotalVat": totalVat,
        "GrandTotal": grandTotal,
        "GrandTotal_Sys": grandTotalSys,
        "TotalCashIn_Sys": totalCashInSys,
        "TotalCashOut_Sys": totalCashOutSys,
        "ExchangeRate": exchangeRate,
        "GrandTotal_Display": grandTotalDisplay,
        "ExchangeRate_Display": exchangeRateDisplay,
        "CurrencyDisplay": currencyDisplay,
        "ReceiptNo": receiptNo,
        "Amount": amount,
        "ItemGroup1": itemGroup1,
        "ItemGroup2": itemGroup2,
        "ItemGroup3": itemGroup3,
        "DateIn": dateIn,
        "DateOut": dateOut,
        "TimeIn": timeIn,
        "TimeOut": timeOut,
        "EmpName": empName,
        "Uom": uom,
        "TotalCal": totalCal,
        "IsNone": isNone,
      };
}
