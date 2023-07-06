// To parse this JSON data, do
//
//     final cencelReceipt = cencelReceiptFromJson(jsonString);

import 'dart:convert';

List<ReceiptToCancelModel> receiptToCancelFromJson(String str) =>
    List<ReceiptToCancelModel>.from(
        json.decode(str).map((x) => ReceiptToCancelModel.fromJson(x)));

String cencelReceiptToJson(List<ReceiptToCancelModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReceiptToCancelModel {
  ReceiptToCancelModel({
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

  factory ReceiptToCancelModel.fromJson(Map<String, dynamic> json) =>
      ReceiptToCancelModel(
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

CancelReceiptModel cencelReceiptSuccessFromJson(String str) =>
    CancelReceiptModel.fromJson(json.decode(str));

String cencelReceiptSuccessToJson(CancelReceiptModel data) =>
    json.encode(data.toJson());

class CancelReceiptModel {
  CancelReceiptModel({
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

  factory CancelReceiptModel.fromJson(Map<String, dynamic> json) =>
      CancelReceiptModel(
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
  Data({
    this.receipt,
  });

  String receipt;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        receipt: json["Receipt"],
      );

  Map<String, dynamic> toJson() => {
        "Receipt": receipt,
      };
}

class Items {
  Items();

  factory Items.fromJson(Map<String, dynamic> json) => Items();

  Map<String, dynamic> toJson() => {};
}
