// // To parse this JSON data, do
// //
// //     final orderDetailModel = orderDetailModelFromJson(jsonString);

// import 'dart:convert';

// OrderDetailModel orderDetailModelFromJson(String str) =>
//     OrderDetailModel.fromJson(json.decode(str));

// String orderDetailModelToJson(OrderDetailModel data) =>
//     json.encode(data.toJson());

// class OrderDetailModel {
//   OrderDetailModel({
//     this.orderDetailId,
//     this.orderId,
//     this.orderDetailModelLineId,
//     this.lineId,
//     this.itemId,
//     this.prefix,
//     this.code,
//     this.khmerName,
//     this.englishName,
//     this.cost,
//     this.baseQty,
//     this.qty,
//     this.printQty,
//     this.uomId,
//     this.uom,
//     this.itemUoMs,
//     this.groupUomId,
//     this.unitPrice,
//     this.discountRate,
//     this.discountValue,
//     this.remarkDiscounts,
//     this.typeDis,
//     this.taxGroups,
//     this.taxGroupId,
//     this.taxRate,
//     this.taxValue,
//     this.total,
//     this.totalSys,
//     this.totalNet,
//     this.itemStatus,
//     this.itemPrintTo,
//     this.currency,
//     this.comment,
//     this.itemType,
//     this.description,
//     this.parentLineId,
//     this.parentLevel,
//     this.isReadonly,
//     this.printers,
//     this.promoTypeDisplay,
//     this.promoType,
//     this.linePosition,
//     this.unitofMeansure,
//     this.isVoided,
//     this.ksServiceSetupId,
//     this.vehicleId,
//     this.isKsms,
//     this.isKsmsMaster,
//     this.isScale,
//     this.comboSaleType,
//     this.remarkDiscountId,
//   });

//   int orderDetailId;
//   int orderId;
//   int orderDetailModelLineId;
//   String lineId;
//   int itemId;
//   dynamic prefix;
//   String code;
//   String khmerName;
//   String englishName;
//   double cost;
//   double baseQty;
//   double qty;
//   double printQty;
//   int uomId;
//   String uom;
//   List<ItemUoM> itemUoMs;
//   int groupUomId;
//   double unitPrice;
//   double discountRate;
//   double discountValue;
//   dynamic remarkDiscounts;
//   String typeDis;
//   List<ItemUoM> taxGroups;
//   int taxGroupId;
//   double taxRate;
//   double taxValue;
//   double total;
//   double totalSys;
//   double totalNet;
//   String itemStatus;
//   String itemPrintTo;
//   String currency;
//   dynamic comment;
//   String itemType;
//   String description;
//   String parentLineId;
//   dynamic parentLevel;
//   bool isReadonly;
//   List<ItemUoM> printers;
//   dynamic promoTypeDisplay;
//   int promoType;
//   int linePosition;
//   dynamic unitofMeansure;
//   bool isVoided;
//   int ksServiceSetupId;
//   int vehicleId;
//   bool isKsms;
//   bool isKsmsMaster;
//   bool isScale;
//   int comboSaleType;
//   int remarkDiscountId;

//   factory OrderDetailModel.fromJson(Map<String, dynamic> json) =>
//       OrderDetailModel(
//         orderDetailId: json["OrderDetailID"],
//         orderId: json["OrderID"],
//         orderDetailModelLineId: json["Line_ID"],
//         lineId: json["LineID"],
//         itemId: json["ItemID"],
//         prefix: json["Prefix"],
//         code: json["Code"],
//         khmerName: json["KhmerName"],
//         englishName: json["EnglishName"],
//         cost: json["Cost"].toDouble(),
//         baseQty: json["BaseQty"],
//         qty: json["Qty"],
//         printQty: json["PrintQty"],
//         uomId: json["UomID"],
//         uom: json["Uom"],
//         itemUoMs: List<ItemUoM>.from(
//             json["ItemUoMs"].map((x) => ItemUoM.fromJson(x))),
//         groupUomId: json["GroupUomID"],
//         unitPrice: json["UnitPrice"].toDouble(),
//         discountRate: json["DiscountRate"],
//         discountValue: json["DiscountValue"],
//         remarkDiscounts: json["RemarkDiscounts"],
//         typeDis: json["TypeDis"],
//         taxGroups: List<ItemUoM>.from(
//             json["TaxGroups"].map((x) => ItemUoM.fromJson(x))),
//         taxGroupId: json["TaxGroupID"],
//         taxRate: json["TaxRate"],
//         taxValue: json["TaxValue"],
//         total: json["Total"].toDouble(),
//         totalSys: json["Total_Sys"],
//         totalNet: json["TotalNet"],
//         itemStatus: json["ItemStatus"],
//         itemPrintTo: json["ItemPrintTo"],
//         currency: json["Currency"],
//         comment: json["Comment"],
//         itemType: json["ItemType"],
//         description: json["Description"],
//         parentLineId: json["ParentLineID"],
//         parentLevel: json["ParentLevel"],
//         isReadonly: json["IsReadonly"],
//         printers: List<ItemUoM>.from(
//             json["Printers"].map((x) => ItemUoM.fromJson(x))),
//         promoTypeDisplay: json["PromoTypeDisplay"],
//         promoType: json["PromoType"],
//         linePosition: json["LinePosition"],
//         unitofMeansure: json["UnitofMeansure"],
//         isVoided: json["IsVoided"],
//         ksServiceSetupId: json["KSServiceSetupId"],
//         vehicleId: json["VehicleId"],
//         isKsms: json["IsKsms"],
//         isKsmsMaster: json["IsKsmsMaster"],
//         isScale: json["IsScale"],
//         comboSaleType: json["ComboSaleType"],
//         remarkDiscountId: json["RemarkDiscountID"],
//       );

//   Map<String, dynamic> toJson() => {
//         "OrderDetailID": orderDetailId,
//         "OrderID": orderId,
//         "Line_ID": orderDetailModelLineId,
//         "LineID": lineId,
//         "ItemID": itemId,
//         "Prefix": prefix,
//         "Code": code,
//         "KhmerName": khmerName,
//         "EnglishName": englishName,
//         "Cost": cost,
//         "BaseQty": baseQty,
//         "Qty": qty,
//         "PrintQty": printQty,
//         "UomID": uomId,
//         "Uom": uom,
//         "ItemUoMs": List<dynamic>.from(itemUoMs.map((x) => x.toJson())),
//         "GroupUomID": groupUomId,
//         "UnitPrice": unitPrice,
//         "DiscountRate": discountRate,
//         "DiscountValue": discountValue,
//         "RemarkDiscounts": remarkDiscounts,
//         "TypeDis": typeDis,
//         "TaxGroups": List<dynamic>.from(taxGroups.map((x) => x.toJson())),
//         "TaxGroupID": taxGroupId,
//         "TaxRate": taxRate,
//         "TaxValue": taxValue,
//         "Total": total,
//         "Total_Sys": totalSys,
//         "TotalNet": totalNet,
//         "ItemStatus": itemStatus,
//         "ItemPrintTo": itemPrintTo,
//         "Currency": currency,
//         "Comment": comment,
//         "ItemType": itemType,
//         "Description": description,
//         "ParentLineID": parentLineId,
//         "ParentLevel": parentLevel,
//         "IsReadonly": isReadonly,
//         "Printers": List<dynamic>.from(printers.map((x) => x.toJson())),
//         "PromoTypeDisplay": promoTypeDisplay,
//         "PromoType": promoType,
//         "LinePosition": linePosition,
//         "UnitofMeansure": unitofMeansure,
//         "IsVoided": isVoided,
//         "KSServiceSetupId": ksServiceSetupId,
//         "VehicleId": vehicleId,
//         "IsKsms": isKsms,
//         "IsKsmsMaster": isKsmsMaster,
//         "IsScale": isScale,
//         "ComboSaleType": comboSaleType,
//         "RemarkDiscountID": remarkDiscountId,
//       };
// }

// class ItemUoM {
//   ItemUoM({
//     this.disabled,
//     this.group,
//     this.selected,
//     this.text,
//     this.value,
//   });

//   bool disabled;
//   dynamic group;
//   bool selected;
//   String text;
//   String value;

//   factory ItemUoM.fromJson(Map<String, dynamic> json) => ItemUoM(
//         disabled: json["Disabled"],
//         group: json["Group"],
//         selected: json["Selected"],
//         text: json["Text"],
//         value: json["Value"],
//       );

//   Map<String, dynamic> toJson() => {
//         "Disabled": disabled,
//         "Group": group,
//         "Selected": selected,
//         "Text": text,
//         "Value": value,
//       };
// }
