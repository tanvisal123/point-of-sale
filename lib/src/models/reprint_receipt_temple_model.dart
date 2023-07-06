// To parse this JSON data, do
//
//     final reprintReceiptModel = reprintReceiptModelFromJson(jsonString);

import 'dart:convert';

List<ReprintReceiptTample> reprintReceiptTampleFromJson(String str) =>
    List<ReprintReceiptTample>.from(
        json.decode(str).map((x) => ReprintReceiptTample.fromJson(x)));

String reprintReceiptModelToJson(List<ReprintReceiptTample> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReprintReceiptTample {
  ReprintReceiptTample({
    this.receiptId,
    this.receiptNo,
    this.cashier,
    this.dateOut,
    this.timeOut,
    this.tableName,
    this.grandTotal,
    this.currency,
    this.returnItems,
  });

  int receiptId;
  String receiptNo;
  String cashier;
  String dateOut;
  String timeOut;
  String tableName;
  String grandTotal;
  dynamic currency;
  dynamic returnItems;

  factory ReprintReceiptTample.fromJson(Map<String, dynamic> json) =>
      ReprintReceiptTample(
        receiptId: json["ReceiptID"],
        receiptNo: json["ReceiptNo"],
        cashier: json["Cashier"],
        dateOut: json["DateOut"],
        timeOut: json["TimeOut"],
        tableName: json["TableName"],
        grandTotal: json["GrandTotal"],
        currency: json["Currency"],
        returnItems: json["ReturnItems"],
      );

  Map<String, dynamic> toJson() => {
        "ReceiptID": receiptId,
        "ReceiptNo": receiptNo,
        "Cashier": cashier,
        "DateOut": dateOut,
        "TimeOut": timeOut,
        "TableName": tableName,
        "GrandTotal": grandTotal,
        "Currency": currency,
        "ReturnItems": returnItems,
      };
}
