// To parse this JSON data, do
//
//     final itemByBarcodeModel = itemByBarcodeModelFromJson(jsonString);

import 'dart:convert';

ItemByBarcodeModel itemByBarcodeModelFromJson(String str) =>
    ItemByBarcodeModel.fromJson(json.decode(str));

String itemByBarcodeModelToJson(ItemByBarcodeModel data) =>
    json.encode(data.toJson());

class ItemByBarcodeModel {
  ItemByBarcodeModel({
    this.orderDetailId,
    this.orderId,
    this.lineId,
    this.itemId,
    this.code,
    this.khmerName,
    this.englishName,
    this.cost,
    this.unitPrice,
    this.qty,
    this.printQty,
    this.uomId,
    this.uom,
    this.discountRate,
    this.discountValue,
    this.typeDis,
    this.total,
    this.totalSys,
    this.itemStatus,
    this.itemPrintTo,
    this.currency,
    this.comment,
    this.itemType,
    this.description,
    this.parentLevel,
    this.unitofMeansure,
  });

  int orderDetailId;
  int orderId;
  int lineId;
  int itemId;
  String code;
  String khmerName;
  String englishName;
  double cost;
  double unitPrice;
  int qty;
  int printQty;
  int uomId;
  String uom;
  double discountRate;
  double discountValue;
  String typeDis;
  double total;
  double totalSys;
  String itemStatus;
  String itemPrintTo;
  String currency;
  String comment;
  String itemType;
  String description;
  dynamic parentLevel;
  dynamic unitofMeansure;

  factory ItemByBarcodeModel.fromJson(Map<String, dynamic> json) =>
      ItemByBarcodeModel(
        orderDetailId: json["OrderDetailID"],
        orderId: json["OrderID"],
        lineId: json["Line_ID"],
        itemId: json["ItemID"],
        code: json["Code"],
        khmerName: json["KhmerName"],
        englishName: json["EnglishName"],
        cost: json["Cost"],
        unitPrice: json["UnitPrice"],
        qty: json["Qty"],
        printQty: json["PrintQty"],
        uomId: json["UomID"],
        uom: json["Uom"],
        discountRate: json["DiscountRate"],
        discountValue: json["DiscountValue"],
        typeDis: json["TypeDis"],
        total: json["Total"],
        totalSys: json["Total_Sys"],
        itemStatus: json["ItemStatus"],
        itemPrintTo: json["ItemPrintTo"],
        currency: json["Currency"],
        comment: json["Comment"],
        itemType: json["ItemType"],
        description: json["Description"],
        parentLevel: json["ParentLevel"],
        unitofMeansure: json["UnitofMeansure"],
      );

  Map<String, dynamic> toJson() => {
        "OrderDetailID": orderDetailId,
        "OrderID": orderId,
        "Line_ID": lineId,
        "ItemID": itemId,
        "Code": code,
        "KhmerName": khmerName,
        "EnglishName": englishName,
        "Cost": cost,
        "UnitPrice": unitPrice,
        "Qty": qty,
        "PrintQty": printQty,
        "UomID": uomId,
        "Uom": uom,
        "DiscountRate": discountRate,
        "DiscountValue": discountValue,
        "TypeDis": typeDis,
        "Total": total,
        "Total_Sys": totalSys,
        "ItemStatus": itemStatus,
        "ItemPrintTo": itemPrintTo,
        "Currency": currency,
        "Comment": comment,
        "ItemType": itemType,
        "Description": description,
        "ParentLevel": parentLevel,
        "UnitofMeansure": unitofMeansure,
      };
}
