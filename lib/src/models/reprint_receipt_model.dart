// To parse this JSON data, do
//
//     final reprintReceiptModel = reprintReceiptModelFromJson(jsonString);

import 'dart:convert';

List<ReprintReceiptModel> reprintReceiptModelFromJson(String str) =>
    List<ReprintReceiptModel>.from(
        json.decode(str).map((x) => ReprintReceiptModel.fromJson(x)));

String reprintReceiptModelToJson(List<ReprintReceiptModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReprintReceiptModel {
  int orderId;
  dynamic logo;
  String company;
  String branchName;
  String address;
  String tel1;
  String tel2;
  String table;
  String orderNo;
  String receiptNo;
  String cashier;
  String dateTimeIn;
  String dateTimeOut;
  String item;
  dynamic itemEn;
  String qty;
  String uom;
  String price;
  String disItem;
  String amount;
  String subTotal;
  String disRate;
  String disValue;
  String typeDis;
  String grandTotal;
  String grandTotalSys;
  String vatRate;
  String vatValue;
  String received;
  String change;
  String changeSys;
  String descKh;
  String descEn;
  String exchangeRate;
  String printer;
  String print;
  dynamic itemDesc;
  String customerInfo;
  dynamic team;
  String itemType;
  String paymentMeans;
  dynamic remark;
  String totalQty;
  dynamic vatNumber;
  String barCode;
  String taxValue;
  String taxRate;
  String taxTotal;
  String freights;
  String linePosition;
  String grandTotalCurrenciesDisplay;
  String changeCurrenciesDisplay;
  int receiptCount;
  ReprintReceiptModel({
    this.orderId,
    this.logo,
    this.company,
    this.branchName,
    this.address,
    this.tel1,
    this.tel2,
    this.table,
    this.orderNo,
    this.receiptNo,
    this.cashier,
    this.dateTimeIn,
    this.dateTimeOut,
    this.item,
    this.itemEn,
    this.qty,
    this.uom,
    this.price,
    this.disItem,
    this.amount,
    this.subTotal,
    this.disRate,
    this.disValue,
    this.typeDis,
    this.grandTotal,
    this.grandTotalSys,
    this.vatRate,
    this.vatValue,
    this.received,
    this.change,
    this.changeSys,
    this.descKh,
    this.descEn,
    this.exchangeRate,
    this.printer,
    this.print,
    this.itemDesc,
    this.customerInfo,
    this.team,
    this.itemType,
    this.paymentMeans,
    this.remark,
    this.totalQty,
    this.vatNumber,
    this.barCode,
    this.taxValue,
    this.taxRate,
    this.taxTotal,
    this.freights,
    this.linePosition,
    this.grandTotalCurrenciesDisplay,
    this.changeCurrenciesDisplay,
    this.receiptCount,
  });

  factory ReprintReceiptModel.fromJson(Map<String, dynamic> json) =>
      ReprintReceiptModel(
        orderId: json["OrderID"],
        logo: json["Logo"],
        company: json["CompanyName"],
        branchName: json["BranchName"],
        address: json["Address"],
        tel1: json["Tel1"],
        tel2: json["Tel2"],
        table: json["Table"],
        orderNo: json["OrderNo"],
        receiptNo: json["ReceiptNo"],
        cashier: json["Cashier"],
        dateTimeIn: json["DateTimeIn"],
        dateTimeOut: json["DateTimeOut"],
        item: json["Item"],
        itemEn: json["ItemEn"],
        qty: json["Qty"],
        uom: json["Uom"],
        price: json["Price"],
        disItem: json["DisItem"],
        amount: json["Amount"],
        subTotal: json["SubTotal"],
        disRate: json["DisRate"],
        disValue: json["DisValue"],
        typeDis: json["TypeDis"],
        grandTotal: json["GrandTotal"],
        grandTotalSys: json["GrandTotalSys"],
        vatRate: json["VatRate"],
        vatValue: json["VatValue"],
        received: json["Received"],
        change: json["Change"],
        changeSys: json["ChangeSys"],
        descKh: json["DescKh"],
        descEn: json["DescEn"],
        exchangeRate: json["ExchangeRate"],
        printer: json["Printer"],
        print: json["Print"],
        itemDesc: json["ItemDesc"],
        customerInfo: json["CustomerInfo"],
        team: json["Team"],
        itemType: json["ItemType"],
        paymentMeans: json["PaymentMeans"],
        remark: json["Remark"],
        totalQty: json["TotalQty"],
        vatNumber: json["VatNumber"],
        barCode: json["BarCode"] == null ? null : json["BarCode"],
        taxValue: json["TaxValue"],
        taxRate: json["TaxRate"],
        taxTotal: json["TaxTotal"],
        freights: json["Freights"],
        linePosition: json["LinePosition"],
        grandTotalCurrenciesDisplay: json["GrandTotalCurrenciesDisplay"],
        changeCurrenciesDisplay: json["ChangeCurrenciesDisplay"],
        receiptCount: json['ReceiptCount'],
      );

  Map<String, dynamic> toJson() => {
        "OrderID": orderId,
        "Logo": logo,
        "CompanyName": company,
        "BranchName": branchName,
        "Address": address,
        "Tel1": tel1,
        "Tel2": tel2,
        "Table": table,
        "OrderNo": orderNo,
        "ReceiptNo": receiptNo,
        "Cashier": cashier,
        "DateTimeIn": dateTimeIn,
        "DateTimeOut": dateTimeOut,
        "Item": item,
        "ItemEn": itemEn,
        "Qty": qty,
        "Uom": uom,
        "Price": price,
        "DisItem": disItem,
        "Amount": amount,
        "SubTotal": subTotal,
        "DisRate": disRate,
        "DisValue": disValue,
        "TypeDis": typeDis,
        "GrandTotal": grandTotal,
        "GrandTotalSys": grandTotalSys,
        "VatRate": vatRate,
        "VatValue": vatValue,
        "Received": received,
        "Change": change,
        "ChangeSys": changeSys,
        "DescKh": descKh,
        "DescEn": descEn,
        "ExchangeRate": exchangeRate,
        "Printer": printer,
        "Print": print,
        "ItemDesc": itemDesc,
        "CustomerInfo": customerInfo,
        "Team": team,
        "ItemType": itemType,
        "PaymentMeans": paymentMeans,
        "Remark": remark,
        "TotalQty": totalQty,
        "VatNumber": vatNumber,
        "BarCode": barCode == null ? null : barCode,
        "TaxValue": taxValue,
        "TaxRate": taxRate,
        "TaxTotal": taxTotal,
        "Freights": freights,
        "LinePosition": linePosition,
        "GrandTotalCurrenciesDisplay": grandTotalCurrenciesDisplay,
        "ChangeCurrenciesDisplay": changeCurrenciesDisplay,
        "ReceiptCount": receiptCount,
      };
}
