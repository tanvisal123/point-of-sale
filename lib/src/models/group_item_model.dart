// To parse this JSON data, do
//
//     final groupItemModel = groupItemModelFromJson(jsonString);

import 'dart:convert';

List<GroupItemModels> groupItemModelFromJsons(String str) =>
    List<GroupItemModels>.from(
        json.decode(str).map((x) => GroupItemModels.fromJson(x)));

String groupItemModelToJson(List<GroupItemModels> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GroupItemModels {
  GroupItemModels({
    this.id,
    this.itemId,
    this.code,
    this.group1,
    this.group2,
    this.group3,
    this.khmerName,
    this.englishName,
    this.qty,
    this.printQty,
    this.cost,
    this.unitPrice,
    this.discountRate,
    this.discountValue,
    this.typeDis,
    this.vat,
    this.currencyId,
    this.currency,
    this.uomId,
    this.uoM,
    this.barcode,
    this.process,
    this.image,
    this.pricListId,
    this.groupUomId,
    this.printTo,
    this.itemType,
    this.description,
    this.isAddon,
    this.inStock,
    this.isScale,
    this.taxGroupSaleId,
    this.props,
    this.propWithName,
  });

  int id;
  int itemId;
  dynamic code;
  int group1;
  int group2;
  int group3;
  String khmerName;
  dynamic englishName;
  double qty;
  double printQty;
  double cost;
  double unitPrice;
  double discountRate;
  double discountValue;
  dynamic typeDis;
  double vat;
  int currencyId;
  dynamic currency;
  int uomId;
  dynamic uoM;
  dynamic barcode;
  dynamic process;
  dynamic image;
  int pricListId;
  int groupUomId;
  dynamic printTo;
  dynamic itemType;
  dynamic description;
  bool isAddon;
  double inStock;
  bool isScale;
  int taxGroupSaleId;
  dynamic props;
  dynamic propWithName;

  factory GroupItemModels.fromJson(Map<String, dynamic> json) =>
      GroupItemModels(
        id: json["ID"],
        itemId: json["ItemID"],
        code: json["Code"],
        group1: json["Group1"],
        group2: json["Group2"],
        group3: json["Group3"],
        khmerName: json["KhmerName"],
        englishName: json["EnglishName"],
        qty: json["Qty"],
        printQty: json["PrintQty"],
        cost: json["Cost"],
        unitPrice: json["UnitPrice"],
        discountRate: json["DiscountRate"],
        discountValue: json["DiscountValue"],
        typeDis: json["TypeDis"],
        vat: json["VAT"],
        currencyId: json["CurrencyID"],
        currency: json["Currency"],
        uomId: json["UomID"],
        uoM: json["UoM"],
        barcode: json["Barcode"],
        process: json["Process"],
        image: json["Image"],
        pricListId: json["PricListID"],
        groupUomId: json["GroupUomID"],
        printTo: json["PrintTo"],
        itemType: json["ItemType"],
        description: json["Description"],
        isAddon: json["IsAddon"],
        inStock: json["InStock"],
        isScale: json["IsScale"],
        taxGroupSaleId: json["TaxGroupSaleID"],
        props: json["Props"],
        propWithName: json["PropWithName"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "ItemID": itemId,
        "Code": code,
        "Group1": group1,
        "Group2": group2,
        "Group3": group3,
        "KhmerName": khmerName,
        "EnglishName": englishName,
        "Qty": qty,
        "PrintQty": printQty,
        "Cost": cost,
        "UnitPrice": unitPrice,
        "DiscountRate": discountRate,
        "DiscountValue": discountValue,
        "TypeDis": typeDis,
        "VAT": vat,
        "CurrencyID": currencyId,
        "Currency": currency,
        "UomID": uomId,
        "UoM": uoM,
        "Barcode": barcode,
        "Process": process,
        "Image": image,
        "PricListID": pricListId,
        "GroupUomID": groupUomId,
        "PrintTo": printTo,
        "ItemType": itemType,
        "Description": description,
        "IsAddon": isAddon,
        "InStock": inStock,
        "IsScale": isScale,
        "TaxGroupSaleID": taxGroupSaleId,
        "Props": props,
        "PropWithName": propWithName,
      };
}
