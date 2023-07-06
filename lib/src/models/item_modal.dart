import 'dart:convert';

List<ItemMaster> itemMasterFromJson(String str) =>
    List<ItemMaster>.from(json.decode(str).map((x) => ItemMaster.fromJson(x)));

String itemMasterToJson(List<ItemMaster> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class ItemMaster {
  int key;
  int itemId;
  String itemCode;
  String itemName;
  double qty;
  double printQty;
  double cost;
  double unitPrice;
  double disRate;
  double disValue;
  String typeDis;
  double vat;
  int currencyId;
  String currency;
  int uomId;
  String uom;
  String barcode;
  String process;
  String image;
  int priceListId;
  int inStock;
  int commited;
  int ordered;
  int available;
  String printTo;
  String itemType;
  String typeDisItem;
  double disValueItem;
  int status;
  int g1Id;
  int g2Id;
  int g3Id;

  @override
  String toString() {
    return 'Item Name = $itemName';
  }

  ItemMaster({
    this.key,
    this.itemId,
    this.itemCode,
    this.itemName,
    this.qty,
    this.printQty,
    this.cost,
    this.unitPrice,
    this.disRate,
    this.disValue,
    this.typeDis,
    this.vat,
    this.currencyId,
    this.currency,
    this.uom,
    this.uomId,
    this.barcode,
    this.process,
    this.image,
    this.priceListId,
    this.inStock,
    this.commited,
    this.ordered,
    this.available,
    this.printTo,
    this.itemType,
    this.typeDisItem,
    this.disValueItem,
    this.status,
    this.g1Id,
    this.g2Id,
    this.g3Id,
  });

  factory ItemMaster.fromJson(Map<String, dynamic> json) => ItemMaster(
        key: json["key"] as int,
        itemId: json["itemId"] as int,
        itemCode: json["itemCode"] as String,
        itemName: json["itemName"] as String,
        qty: json["qty"] as double,
        printQty: json["printQty"] as double,
        cost: json["cost"] as double,
        unitPrice: json["unitPrice"] as double,
        disRate: json["disRate"] as double,
        disValue: json["disValue"] as double,
        typeDis: json["typeDis"] as String,
        vat: json["vat"] as double,
        currencyId: json["currencyId"] as int,
        currency: json["currency"] as String,
        uomId: json["uomId"] as int,
        uom: json["uom"] as String,
        barcode: json["barcode"] as String,
        process: json["process"] as String,
        image: json["image"] as String,
        priceListId: json["priceListId"] as int,
        inStock: json["inStock"] as int,
        commited: json["commited"] as int,
        ordered: json["ordered"] as int,
        available: json["available"] as int,
        printTo: json["printTo"] as String,
        itemType: json["itemType"] as String,
        typeDisItem: json["typeDisItem"] as String,
        disValueItem: json["disValueItem"] as double,
        status: json["status"] as int,
        g1Id: json["g1Id"] as int,
        g2Id: json["g2Id"] as int,
        g3Id: json["g3Id"] as int,
      );

  Map<String, dynamic> toMap() => {
        "key": key,
        "itemId": itemId,
        "itemCode": itemCode,
        "itemName": itemName,
        "qty": qty,
        "printQty": printQty,
        "cost": cost,
        "unitPrice": unitPrice,
        "disRate": disRate,
        "disValue": disValue,
        "typeDis": typeDis,
        "vat": vat,
        "currencyId": currencyId,
        "currency": currency,
        "uomId": uomId,
        "uom": uom,
        "barcode": barcode,
        "process": process,
        "image": image,
        "priceListId": priceListId,
        "inStock": inStock,
        "commited": commited,
        "ordered": ordered,
        "printTo": printTo,
        "itemType": itemType,
        "available": available,
        "typeDisItem": typeDisItem,
        "disValueItem": disValueItem,
        "status": status,
        "g1Id": g1Id,
        "g2Id": g2Id,
        "g3Id": g3Id
      };
}
// To parse this JSON data, do
//
//     final itemModel = itemModelFromJson(jsonString);

List<ItemModel> itemModelFromJson(String str) =>
    List<ItemModel>.from(json.decode(str).map((x) => ItemModel.fromJson(x)));

String itemModelToJson(List<ItemModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ItemModel {
  ItemModel({
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
    this.addictionProps,
  });

  int id;
  int itemId;
  String code;
  int group1;
  int group2;
  int group3;
  String khmerName;
  String englishName;
  double qty;
  double printQty;
  double cost;
  double unitPrice;
  double discountRate;
  double discountValue;
  String typeDis;
  double vat;
  int currencyId;
  String currency;
  int uomId;
  String uoM;
  String barcode;
  String process;
  String image;
  int pricListId;
  int groupUomId;
  String printTo;
  String itemType;
  dynamic description;
  bool isAddon;
  double inStock;
  bool isScale;
  int taxGroupSaleId;
  AddictionProps addictionProps;

  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
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
        cost: json["Cost"].toDouble(),
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
        addictionProps: AddictionProps.fromJson(json["AddictionProps"]),
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
        "AddictionProps": addictionProps.toJson(),
      };
}

class AddictionProps {
  AddictionProps();

  factory AddictionProps.fromJson(Map<String, dynamic> json) =>
      AddictionProps();

  Map<String, dynamic> toJson() => {};
}
