class ReceiptDetail {
  int iD;
  int receiptID;
  int orderDetailID;
  int orderID;
  int lineID;
  int itemID;
  String code;
  String khmerName;
  String englishName;
  double qty;
  double printQty;
  double unitPrice;
  double cost;
  double discountRate;
  double discountValue;
  String typeDis;
  double total;
  double totalSys;
  int uomID;
  String itemStatus;
  String itemPrintTo;
  String currency;
  String comment;
  String itemType;
  String description;
  String parentLevel;
  UnitofMeansure unitofMeansure;
  String receipt;

  ReceiptDetail(
      {this.iD,
      this.receiptID,
      this.orderDetailID,
      this.orderID,
      this.lineID,
      this.itemID,
      this.code,
      this.khmerName,
      this.englishName,
      this.qty,
      this.printQty,
      this.unitPrice,
      this.cost,
      this.discountRate,
      this.discountValue,
      this.typeDis,
      this.total,
      this.totalSys,
      this.uomID,
      this.itemStatus,
      this.itemPrintTo,
      this.currency,
      this.comment,
      this.itemType,
      this.description,
      this.parentLevel,
      this.unitofMeansure,
      this.receipt});

  ReceiptDetail.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    receiptID = json['ReceiptID'];
    orderDetailID = json['OrderDetailID'];
    orderID = json['OrderID'];
    lineID = json['Line_ID'];
    itemID = json['ItemID'];
    code = json['Code'];
    khmerName = json['KhmerName'];
    englishName = json['EnglishName'];
    qty = json['Qty'];
    printQty = json['PrintQty'];
    unitPrice = json['UnitPrice'];
    cost = json['Cost'];
    discountRate = json['DiscountRate'];
    discountValue = json['DiscountValue'];
    typeDis = json['TypeDis'];
    total = json['Total'];
    totalSys = json['Total_Sys'];
    uomID = json['UomID'];
    itemStatus = json['ItemStatus'];
    itemPrintTo = json['ItemPrintTo'];
    currency = json['Currency'];
    comment = json['Comment'];
    itemType = json['ItemType'];
    description = json['Description'];
    parentLevel = json['ParentLevel'];
    unitofMeansure = json['UnitofMeansure'] != null
        ? new UnitofMeansure.fromJson(json['UnitofMeansure'])
        : null;
    receipt = json['Receipt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['ReceiptID'] = this.receiptID;
    data['OrderDetailID'] = this.orderDetailID;
    data['OrderID'] = this.orderID;
    data['Line_ID'] = this.lineID;
    data['ItemID'] = this.itemID;
    data['Code'] = this.code;
    data['KhmerName'] = this.khmerName;
    data['EnglishName'] = this.englishName;
    data['Qty'] = this.qty;
    data['PrintQty'] = this.printQty;
    data['UnitPrice'] = this.unitPrice;
    data['Cost'] = this.cost;
    data['DiscountRate'] = this.discountRate;
    data['DiscountValue'] = this.discountValue;
    data['TypeDis'] = this.typeDis;
    data['Total'] = this.total;
    data['Total_Sys'] = this.totalSys;
    data['UomID'] = this.uomID;
    data['ItemStatus'] = this.itemStatus;
    data['ItemPrintTo'] = this.itemPrintTo;
    data['Currency'] = this.currency;
    data['Comment'] = this.comment;
    data['ItemType'] = this.itemType;
    data['Description'] = this.description;
    data['ParentLevel'] = this.parentLevel;
    if (this.unitofMeansure != null) {
      data['UnitofMeansure'] = this.unitofMeansure.toJson();
    }
    data['Receipt'] = this.receipt;
    return data;
  }
}

class UnitofMeansure {
  int iD;
  String code;
  String name;
  String altUomName;
  bool delete;

  UnitofMeansure({this.iD, this.code, this.name, this.altUomName, this.delete});

  UnitofMeansure.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    code = json['Code'];
    name = json['Name'];
    altUomName = json['AltUomName'];
    delete = json['Delete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Code'] = this.code;
    data['Name'] = this.name;
    data['AltUomName'] = this.altUomName;
    data['Delete'] = this.delete;
    return data;
  }
}
