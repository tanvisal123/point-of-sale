import 'dart:convert';

List<SummarySaleModel> summarySaleModelFromJson(String str) =>
    List<SummarySaleModel>.from(
        json.decode(str).map((x) => SummarySaleModel.fromJson(x)));

String summarySaleModelToJson(List<SummarySaleModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SummarySaleModel {
  SummarySaleModel({
    this.grandTotalBrand,
    this.douType,
    this.empCode,
    this.empName,
    this.branchName,
    this.branchId,
    this.receiptNo,
    this.receiptId,
    this.dateOut,
    this.timeOut,
    this.discountItem,
    this.currency,
    this.grandTotal,
    this.dateFrom,
    this.dateTo,
    this.sCount,
    this.sDiscountItem,
    this.sDiscountTotal,
    this.sVat,
    this.sGrandTotalSys,
    this.sGrandTotal,
    this.totalDiscountItem,
    this.discountTotal,
    this.vat,
    this.grandTotalSys,
    this.mGrandTotal,
    this.refNo,
  });

  String grandTotalBrand;
  String douType;
  String empCode;
  String empName;
  String branchName;
  int branchId;
  String receiptNo;
  int receiptId;
  String dateOut;
  String timeOut;
  String discountItem;
  String currency;
  String grandTotal;
  String dateFrom;
  String dateTo;
  dynamic sCount;
  String sDiscountItem;
  String sDiscountTotal;
  String sVat;
  String sGrandTotalSys;
  String sGrandTotal;
  double totalDiscountItem;
  double discountTotal;
  double vat;
  double grandTotalSys;
  double mGrandTotal;
  dynamic refNo;

  @override
  String toString() {
    return 'SGrandTotal = $sGrandTotal, SGrandTotalSys = $sGrandTotalSys, SVat = $sVat, DiscuntTotal = $sDiscountTotal, DiscountItem = $sDiscountItem, ';
  }

  factory SummarySaleModel.fromJson(Map<String, dynamic> json) =>
      SummarySaleModel(
        grandTotalBrand: json["GrandTotalBrand"],
        douType: json["DouType"],
        empCode: json["EmpCode"],
        empName: json["EmpName"],
        branchName: json["BranchName"],
        branchId: json["BranchID"],
        receiptNo: json["ReceiptNo"],
        receiptId: json["ReceiptID"],
        dateOut: json["DateOut"],
        timeOut: json["TimeOut"],
        discountItem: json["DiscountItem"],
        currency: json["Currency"],
        grandTotal: json["GrandTotal"],
        dateFrom: json["DateFrom"],
        dateTo: json["DateTo"],
        sCount: json["SCount"],
        sDiscountItem: json["SDiscountItem"],
        sDiscountTotal: json["SDiscountTotal"],
        sVat: json["SVat"],
        sGrandTotalSys: json["SGrandTotalSys"],
        sGrandTotal: json["SGrandTotal"],
        totalDiscountItem: json["TotalDiscountItem"],
        discountTotal: json["DiscountTotal"],
        vat: json["Vat"],
        grandTotalSys: json["GrandTotalSys"].toDouble(),
        mGrandTotal: json["MGrandTotal"].toDouble(),
        refNo: json["RefNo"],
      );

  Map<String, dynamic> toJson() => {
        "GrandTotalBrand": grandTotalBrand,
        "DouType": douType,
        "EmpCode": empCode,
        "EmpName": empName,
        "BranchName": branchName,
        "BranchID": branchId,
        "ReceiptNo": receiptNo,
        "ReceiptID": receiptId,
        "DateOut": dateOut,
        "TimeOut": timeOut,
        "DiscountItem": discountItem,
        "Currency": currency,
        "GrandTotal": grandTotal,
        "DateFrom": dateFrom,
        "DateTo": dateTo,
        "SCount": sCount,
        "SDiscountItem": sDiscountItem,
        "SDiscountTotal": sDiscountTotal,
        "SVat": sVat,
        "SGrandTotalSys": sGrandTotalSys,
        "SGrandTotal": sGrandTotal,
        "TotalDiscountItem": totalDiscountItem,
        "DiscountTotal": discountTotal,
        "Vat": vat,
        "GrandTotalSys": grandTotalSys,
        "MGrandTotal": mGrandTotal,
        "RefNo": refNo,
      };
}
