// To parse this JSON data, do
//
//     final returnReceiptModel = returnReceiptModelFromJson(jsonString);

import 'dart:convert';

List<ReturnReceiptModel> returnReceiptModelFromJson(String str) =>
    List<ReturnReceiptModel>.from(
        json.decode(str).map((x) => ReturnReceiptModel.fromJson(x)));

String returnReceiptModelToJson(List<ReturnReceiptModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReturnReceiptModel {
  ReturnReceiptModel({
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
  dynamic cashier;
  String dateOut;
  String timeOut;
  dynamic tableName;
  dynamic grandTotal;
  dynamic currency;
  List<ReturnItem> returnItems;

  factory ReturnReceiptModel.fromJson(Map<String, dynamic> json) =>
      ReturnReceiptModel(
        receiptId: json["ReceiptID"],
        receiptNo: json["ReceiptNo"],
        cashier: json["Cashier"],
        dateOut: json["DateOut"],
        timeOut: json["TimeOut"],
        tableName: json["TableName"],
        grandTotal: json["GrandTotal"],
        currency: json["Currency"],
        returnItems: List<ReturnItem>.from(
            json["ReturnItems"].map((x) => ReturnItem.fromJson(x))),
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
        "ReturnItems": List<dynamic>.from(returnItems.map((x) => x.toJson())),
      };
}

class ReturnItem {
  ReturnItem({
    this.id,
    this.itemId,
    this.receiptId,
    this.code,
    this.khName,
    this.uoM,
    this.uomId,
    this.openQty,
    this.returnQty,
    this.userId,
  });

  int id;
  int itemId;
  int receiptId;
  String code;
  String khName;
  String uoM;
  int uomId;
  double openQty;
  double returnQty;
  int userId;

  factory ReturnItem.fromJson(Map<String, dynamic> json) => ReturnItem(
        id: json["ID"],
        itemId: json["ItemID"],
        receiptId: json["ReceiptID"],
        code: json["Code"],
        khName: json["KhName"],
        uoM: json["UoM"],
        uomId: json["UomID"],
        openQty: json["OpenQty"],
        returnQty: json["ReturnQty"],
        userId: json["UserID"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "ItemID": itemId,
        "ReceiptID": receiptId,
        "Code": code,
        "KhName": khName,
        "UoM": uoM,
        "UomID": uomId,
        "OpenQty": openQty,
        "ReturnQty": returnQty,
        "UserID": userId,
      };
}

ReturnItemComplate returnComplateFromJson(String str) =>
    ReturnItemComplate.fromJson(json.decode(str));

String cencelReceiptSuccessToJson(ReturnItemComplate data) =>
    json.encode(data.toJson());

class ReturnItemComplate {
  ReturnItemComplate({
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

  factory ReturnItemComplate.fromJson(Map<String, dynamic> json) =>
      ReturnItemComplate(
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
        receipt: json["ItemReturns"],
      );

  Map<String, dynamic> toJson() => {
        "ItemReturns": receipt,
      };
}

class Items {
  Items();

  factory Items.fromJson(Map<String, dynamic> json) => Items();

  Map<String, dynamic> toJson() => {};
}
