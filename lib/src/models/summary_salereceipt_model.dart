// To parse this JSON data, do
//
//     final summarySalesModel = summarySalesModelFromJson(jsonString);

import 'dart:convert';

List<SummarySalesModel> summarySalesModelFromJson(String str) =>
    List<SummarySalesModel>.from(
        json.decode(str).map((x) => SummarySalesModel.fromJson(x)));

String summarySalesModelToJson(List<SummarySalesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SummarySalesModel {
  SummarySalesModel({
    this.lineId,
    this.grandTotalBrand,
    this.empCode,
    this.empName,
    this.branchName,
    this.branchId,
    this.receiptNo,
    this.receiptNmber,
    this.expires,
    this.status,
    this.confrimRenew,
    this.payment,
    this.newContractStartDate,
    this.newContractEndDate,
    this.nextOpenRenewalDate,
    this.renewalstartdate,
    this.renewalenddate,
    this.terminateDate,
    this.contractType,
    this.contractName,
    this.setupContractName,
    this.activities,
    this.estimateSupportCost,
    this.remark,
    this.attachement,
    this.douType,
    this.dateOut,
    this.disRemark,
    this.currency,
    this.grandTotal,
    this.receiptId,
    this.timeOut,
    this.discountItem,
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

  String lineId;
  String grandTotalBrand;
  String empCode;
  String empName;
  String branchName;
  int branchId;
  String receiptNo;
  int receiptNmber;
  int expires;
  dynamic status;
  dynamic confrimRenew;
  dynamic payment;
  DateTime newContractStartDate;
  DateTime newContractEndDate;
  DateTime nextOpenRenewalDate;
  DateTime renewalstartdate;
  DateTime renewalenddate;
  DateTime terminateDate;
  dynamic contractType;
  dynamic contractName;
  dynamic setupContractName;
  int activities;
  double estimateSupportCost;
  dynamic remark;
  dynamic attachement;
  String douType;
  String dateOut;
  dynamic disRemark;
  String currency;
  String grandTotal;
  int receiptId;
  String timeOut;
  String discountItem;
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

  factory SummarySalesModel.fromJson(Map<String, dynamic> json) =>
      SummarySalesModel(
        lineId: json["LineID"],
        grandTotalBrand: json["GrandTotalBrand"],
        empCode: json["EmpCode"],
        empName: json["EmpName"],
        branchName: json["BranchName"],
        branchId: json["BranchID"],
        receiptNo: json["ReceiptNo"],
        receiptNmber: json["ReceiptNmber"],
        expires: json["Expires"],
        status: json["Status"],
        confrimRenew: json["ConfrimRenew"],
        payment: json["Payment"],
        newContractStartDate: DateTime.parse(json["NewContractStartDate"]),
        newContractEndDate: DateTime.parse(json["NewContractEndDate"]),
        nextOpenRenewalDate: DateTime.parse(json["NextOpenRenewalDate"]),
        renewalstartdate: DateTime.parse(json["Renewalstartdate"]),
        renewalenddate: DateTime.parse(json["Renewalenddate"]),
        terminateDate: DateTime.parse(json["TerminateDate"]),
        contractType: json["ContractType"],
        contractName: json["ContractName"],
        setupContractName: json["SetupContractName"],
        activities: json["Activities"],
        estimateSupportCost: json["EstimateSupportCost"],
        remark: json["Remark"],
        attachement: json["Attachement"],
        douType: json["DouType"],
        dateOut: json["DateOut"],
        disRemark: json["DisRemark"],
        currency: json["Currency"],
        grandTotal: json["GrandTotal"],
        receiptId: json["ReceiptID"],
        timeOut: json["TimeOut"],
        discountItem: json["DiscountItem"],
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
        grandTotalSys: json["GrandTotalSys"],
        mGrandTotal: json["MGrandTotal"],
        refNo: json["RefNo"],
      );

  Map<String, dynamic> toJson() => {
        "LineID": lineId,
        "GrandTotalBrand": grandTotalBrand,
        "EmpCode": empCode,
        "EmpName": empName,
        "BranchName": branchName,
        "BranchID": branchId,
        "ReceiptNo": receiptNo,
        "ReceiptNmber": receiptNmber,
        "Expires": expires,
        "Status": status,
        "ConfrimRenew": confrimRenew,
        "Payment": payment,
        "NewContractStartDate": newContractStartDate.toIso8601String(),
        "NewContractEndDate": newContractEndDate.toIso8601String(),
        "NextOpenRenewalDate": nextOpenRenewalDate.toIso8601String(),
        "Renewalstartdate": renewalstartdate.toIso8601String(),
        "Renewalenddate": renewalenddate.toIso8601String(),
        "TerminateDate": terminateDate.toIso8601String(),
        "ContractType": contractType,
        "ContractName": contractName,
        "SetupContractName": setupContractName,
        "Activities": activities,
        "EstimateSupportCost": estimateSupportCost,
        "Remark": remark,
        "Attachement": attachement,
        "DouType": douType,
        "DateOut": dateOut,
        "DisRemark": disRemark,
        "Currency": currency,
        "GrandTotal": grandTotal,
        "ReceiptID": receiptId,
        "TimeOut": timeOut,
        "DiscountItem": discountItem,
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
