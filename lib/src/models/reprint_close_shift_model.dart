import 'dart:convert';

List<ReprintCloseShiftModel> reprintCloseShiftFromJson(String str) =>
    List<ReprintCloseShiftModel>.from(
        json.decode(str).map((x) => ReprintCloseShiftModel.fromJson(x)));

String reprintCloseShiftToJson(List<ReprintCloseShiftModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReprintCloseShiftModel {
  ReprintCloseShiftModel({
    this.id,
    this.empName,
    this.trans,
    this.dateIn,
    this.timeIn,
    this.dateOut,
    this.timeOut,
    this.cashInAmountSys,
    this.totalCashOutSys,
    this.cashOutAmountSys,
    this.saleAmountSys,
    this.branch,
    this.empCode,
    this.ssc,
    this.userId,
  });

  int id;
  String empName;
  String trans;
  String dateIn;
  String timeIn;
  String dateOut;
  String timeOut;
  String cashInAmountSys;
  String totalCashOutSys;
  String cashOutAmountSys;
  String saleAmountSys;
  String branch;
  String empCode;
  String ssc;
  int userId;

  factory ReprintCloseShiftModel.fromJson(Map<String, dynamic> json) =>
      ReprintCloseShiftModel(
        id: json["ID"],
        empName: json["EmpName"],
        trans: json["Trans"],
        dateIn: json["DateIn"],
        timeIn: json["TimeIn"],
        dateOut: json["DateOut"],
        timeOut: json["TimeOut"],
        cashInAmountSys: json["CashInAmountSys"],
        totalCashOutSys: json["TotalCashOutSys"],
        cashOutAmountSys: json["CashOutAmountSys"],
        saleAmountSys: json["SaleAmountSys"],
        branch: json["Branch"],
        empCode: json["EmpCode"],
        ssc: json["SSC"],
        userId: json["UserID"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "EmpName": empName,
        "Trans": trans,
        "DateIn": dateIn,
        "TimeIn": timeIn,
        "DateOut": dateOut,
        "TimeOut": timeOut,
        "CashInAmountSys": cashInAmountSys,
        "TotalCashOutSys": totalCashOutSys,
        "CashOutAmountSys": cashOutAmountSys,
        "SaleAmountSys": saleAmountSys,
        "Branch": branch,
        "EmpCode": empCode,
        "SSC": ssc,
        "UserID": userId,
      };
}
