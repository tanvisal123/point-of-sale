import 'dart:convert';

ReceiptInfoModel receiptInfoFromJson(String str) =>
    ReceiptInfoModel.fromJson(json.decode(str));

String receiptInfoToJson(ReceiptInfoModel data) => json.encode(data.toJson());

class ReceiptInfoModel {
  ReceiptInfoModel({
    this.itemsReturns,
    this.receiptId,
    this.printInvoice,
  });

  List<ItemsReturn> itemsReturns;
  int receiptId;
  PrintInvoice printInvoice;

  factory ReceiptInfoModel.fromJson(Map<String, dynamic> json) =>
      ReceiptInfoModel(
        itemsReturns: json["ItemsReturns"] == []
            ? []
            : List<ItemsReturn>.from(
                json["ItemsReturns"].map((x) => ItemsReturn.fromJson(x))),
        receiptId: json["ReceiptID"],
        printInvoice: json["PrintInvoice"] == null
            ? null
            : PrintInvoice.fromJson(json["PrintInvoice"]),
      );

  Map<String, dynamic> toJson() => {
        "ItemsReturns": List<dynamic>.from(itemsReturns.map((x) => x.toJson())),
        "ReceiptID": receiptId,
        "PrintInvoice": printInvoice.toJson(),
      };
}

class ItemsReturn {
  ItemsReturn({
    this.lineId,
    this.itemId,
    this.code,
    this.khmerName,
    this.uom,
    this.inStock,
    this.totalStock,
    this.orderQty,
    this.committed,
    this.isSerailBatch,
    this.isBom,
  });

  String lineId;
  int itemId;
  String code;
  String khmerName;
  String uom;
  double inStock;
  double totalStock;
  double orderQty;
  double committed;
  bool isSerailBatch;
  bool isBom;

  factory ItemsReturn.fromJson(Map<String, dynamic> json) => ItemsReturn(
        lineId: json["LineID"],
        itemId: json["ItemID"],
        code: json["Code"],
        khmerName: json["KhmerName"],
        uom: json["Uom"],
        inStock: json["InStock"],
        totalStock: json["TotalStock"],
        orderQty: json["OrderQty"],
        committed: json["Committed"],
        isSerailBatch: json["IsSerailBatch"],
        isBom: json["IsBOM"],
      );
  Map<String, dynamic> toJson() => {
        "LineID": lineId,
        "ItemID": itemId,
        "Code": code,
        "KhmerName": khmerName,
        "Uom": uom,
        "InStock": inStock,
        "TotalStock": totalStock,
        "OrderQty": orderQty,
        "Committed": committed,
        "IsSerailBatch": isSerailBatch,
        "IsBOM": isBom,
      };
}

class PrintInvoice {
  String orderNo;
  String queueNo;
  String receiptNo;
  String tableName;
  String companyName;
  String branchName;
  String address;
  String dateIn;
  String dateOut;
  String tel;
  String tel2;
  String description;
  String description2;
  String discountRate;
  String discountValue;
  String subtotal;
  String vatRate;
  String vatValue;
  String grandTotal;
  String grandTotalSys;
  String appliedAmount;
  String receivedAmount;
  String changedAmount;
  String changedAmountSys;
  String customerInfo;
  String paymentMeans;
  String remark;
  String totalItemQty;
  String freights;
  String printType;
  dynamic logo;
  String userOrder;
  int countReceipt;
  List<LineItem> lineItems;
  PrintInvoice({
    this.orderNo,
    this.queueNo,
    this.receiptNo,
    this.tableName,
    this.companyName,
    this.branchName,
    this.address,
    this.dateIn,
    this.dateOut,
    this.tel,
    this.tel2,
    this.description,
    this.description2,
    this.discountRate,
    this.discountValue,
    this.subtotal,
    this.vatRate,
    this.vatValue,
    this.grandTotal,
    this.grandTotalSys,
    this.appliedAmount,
    this.receivedAmount,
    this.changedAmount,
    this.changedAmountSys,
    this.customerInfo,
    this.paymentMeans,
    this.remark,
    this.totalItemQty,
    this.freights,
    this.printType,
    this.logo,
    this.userOrder,
    this.countReceipt,
    this.lineItems,
  });

  factory PrintInvoice.fromJson(Map<String, dynamic> json) => PrintInvoice(
        orderNo: json["OrderNo"],
        queueNo: json["QueueNo"],
        receiptNo: json["ReceiptNo"],
        tableName: json["TableName"],
        companyName: json["CompanyName"],
        branchName: json["BranchName"],
        dateIn: json["DateIn"],
        dateOut: json["DateOut"],
        tel: json["Tel"],
        tel2: json["Tel2"],
        description: json["Description"],
        description2: json["Description2"],
        address: json["Address"],
        discountRate: json["DiscountRate"],
        discountValue: json["DiscountValue"],
        subtotal: json["Subtotal"],
        vatRate: json["VatRate"],
        vatValue: json["VatValue"],
        grandTotal: json["GrandTotal"],
        grandTotalSys: json["GrandTotalSys"],
        appliedAmount: json["AppliedAmount"],
        receivedAmount: json["ReceivedAmount"],
        changedAmount: json["ChangedAmount"],
        changedAmountSys: json["ChangedAmountSys"],
        customerInfo: json["CustomerInfo"],
        paymentMeans: json["PaymentMeans"],
        remark: json["Remark"],
        totalItemQty: json["TotalItemQty"],
        freights: json["Freights"],
        printType: json["PrintType"],
        logo: json["Logo"],
        userOrder: json["UserOrder"],
        countReceipt: json["ReceiptCount"],
        lineItems: List<LineItem>.from(
            json["LineItems"].map((x) => LineItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "OrderNo": orderNo,
        "QueueNo": queueNo,
        "ReceiptNo": receiptNo,
        "TableName": tableName,
        "BranchName": branchName,
        "CompanyName": companyName,
        "DateIn": dateIn,
        "DateOut": dateOut,
        "Tel": tel,
        "Tel2": tel2,
        "Description": description,
        "Description2": description2,
        "Address": address,
        "DiscountRate": discountRate,
        "DiscountValue": discountValue,
        "Subtotal": subtotal,
        "VatRate": vatRate,
        "VatValue": vatValue,
        "GrandTotal": grandTotal,
        "GrandTotalSys": grandTotalSys,
        "AppliedAmount": appliedAmount,
        "ReceivedAmount": receivedAmount,
        "ChangedAmount": changedAmount,
        "ChangedAmountSys": changedAmountSys,
        "CustomerInfo": customerInfo,
        "PaymentMeans": paymentMeans,
        "Remark": remark,
        "TotalItemQty": totalItemQty,
        "Freights": freights,
        "PrintType": printType,
        "Logo": logo,
        "UserOrder": userOrder,
        "ReceiptCount": countReceipt,
        "LineItems": List<dynamic>.from(lineItems.map((x) => x.toJson())),
      };
}

class LineItem {
  LineItem({
    this.lineId,
    this.parentLineId,
    this.itemId,
    this.itemName,
    this.itemName2,
    this.printQty,
    this.qty,
    this.unitPrice,
    this.discountRate,
    this.discountValue,
    this.taxRate,
    this.taxValue,
    this.total,
    this.printerName,
    this.comment,
    this.itemType,
  });

  String lineId;
  dynamic parentLineId;
  int itemId;
  String itemName;
  String itemName2;
  String printQty;
  String qty;
  String unitPrice;
  String discountRate;
  String discountValue;
  String taxRate;
  String taxValue;
  String total;
  String printerName;
  String comment;
  String itemType;
  factory LineItem.fromJson(Map<String, dynamic> json) => LineItem(
      lineId: json["LineID"],
      parentLineId: json["ParentLineID"],
      itemId: json["ItemID"],
      itemName: json["ItemName"],
      itemName2: json["ItemName2"],
      printQty: json["PrintQty"],
      qty: json["Qty"],
      unitPrice: json["UnitPrice"],
      discountRate: json["DiscountRate"],
      discountValue: json["DiscountValue"],
      taxRate: json["TaxRate"],
      taxValue: json["TaxValue"],
      total: json["Total"],
      printerName: json["PrinterName"],
      comment: json["Comment"],
      itemType: json["ItemType"]);

  Map<String, dynamic> toJson() => {
        "LineID": lineId,
        "ParentLineID": parentLineId,
        "ItemID": itemId,
        "ItemName": itemName,
        "ItemName2": itemName2,
        "PrintQty": printQty,
        "Qty": qty,
        "UnitPrice": unitPrice,
        "DiscountRate": discountRate,
        "DiscountValue": discountValue,
        "TaxRate": taxRate,
        "TaxValue": taxValue,
        "Total": total,
        "PrinterName": printerName,
        "Comment": comment,
        "ItemType": itemType,
      };
}
