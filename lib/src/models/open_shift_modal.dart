import 'dart:convert';
// class OpenShiftModel {
//   int id;
//   String dateIn;
//   String timeIn;
//   int branchID;
//   int userID;
//   double cashAmountSys;
//   String currency;
//   double transFrom;
//   bool open;

//   OpenShiftModel({
//     this.id,
//     this.dateIn,
//     this.timeIn,
//     this.branchID,
//     this.userID,
//     this.cashAmountSys,
//     this.currency,
//     this.transFrom,
//     this.open,
//   });

//   OpenShiftModel.fromJson(Map<String, dynamic> json) {
//     id = json['ID'];
//     dateIn = json['DateIn'];
//     timeIn = json['TimeIn'];
//     branchID = json['BranchID'];
//     userID = json['UserID'];
//     cashAmountSys = json['CashAmount_Sys'];
//     currency = json['Currency'];
//     transFrom = json['Trans_From'];
//     open = json['Open'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['ID'] = this.id;
//     data['DateIn'] = this.dateIn;
//     data['TimeIn'] = this.timeIn;
//     data['BranchID'] = this.branchID;
//     data['UserID'] = this.userID;
//     data['CashAmount_Sys'] = this.cashAmountSys;
//     data['Currency'] = this.currency;
//     data['Trans_From'] = this.transFrom;
//     data['Open'] = this.open;
//     return data;
//   }
// }

class PostOpenShift {
  int userId;
  double cash;
  PostOpenShift({this.userId, this.cash});

  PostOpenShift.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    cash = json['cash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['cash'] = this.cash;
    return data;
  }
}

List<OpenShiftModel> openShiftModelFromJson(String str) =>
    List<OpenShiftModel>.from(
        json.decode(str).map((x) => OpenShiftModel.fromJson(x)));

String openShiftModelToJson(List<OpenShiftModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OpenShiftModel {
  OpenShiftModel({
    this.id,
    this.dateIn,
    this.timeIn,
    this.branchId,
    this.userId,
    this.cashAmountSys,
    this.transFrom,
    this.open,
    this.localCurrencyId,
    this.sysCurrencyId,
    this.localSetRate,
  });

  int id;
  String dateIn;
  String timeIn;
  int branchId;
  int userId;
  double cashAmountSys;
  double transFrom;
  dynamic open;
  int localCurrencyId;
  int sysCurrencyId;
  double localSetRate;

  factory OpenShiftModel.fromJson(Map<String, dynamic> json) => OpenShiftModel(
        id: json["ID"],
        dateIn: json["DateIn"],
        timeIn: json["TimeIn"],
        branchId: json["BranchID"],
        userId: json["UserID"],
        cashAmountSys: json["CashAmount_Sys"],
        transFrom: json["Trans_From"],
        open: json["Open"],
        localCurrencyId: json["LocalCurrencyID"],
        sysCurrencyId: json["SysCurrencyID"],
        localSetRate: json["LocalSetRate"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "DateIn": dateIn,
        "TimeIn": timeIn,
        "BranchID": branchId,
        "UserID": userId,
        "CashAmount_Sys": cashAmountSys,
        "Trans_From": transFrom,
        "Open": open,
        "LocalCurrencyID": localCurrencyId,
        "SysCurrencyID": sysCurrencyId,
        "LocalSetRate": localSetRate,
      };
}
// To parse this JSON data, do
//
//     final proccesOpenShift = proccesOpenShiftFromJson(jsonString);

//

ProcessOpenShift proccesOpenShiftFromJson(String str) =>
    ProcessOpenShift.fromJson(json.decode(str));

String proccesOpenShiftToJson(ProcessOpenShift data) =>
    json.encode(data.toJson());

class ProcessOpenShift {
  ProcessOpenShift({
    this.data,
    this.items,
    this.action,
    this.isRejected,
    this.isAlerted,
    this.isApproved,
    this.count,
    this.redirect,
  });

  Data data;
  Data items;
  int action;
  bool isRejected;
  bool isAlerted;
  bool isApproved;
  int count;
  dynamic redirect;

  factory ProcessOpenShift.fromJson(Map<String, dynamic> json) =>
      ProcessOpenShift(
        data: Data.fromJson(json["Data"]),
        items: Data.fromJson(json["Items"]),
        action: json["Action"],
        isRejected: json["IsRejected"],
        isAlerted: json["IsAlerted"],
        isApproved: json["IsApproved"],
        count: json["Count"],
        redirect: json["Redirect"],
      );

  Map<String, dynamic> toJson() => {
        "Data": data.toJson(),
        "Items": items.toJson(),
        "Action": action,
        "IsRejected": isRejected,
        "IsAlerted": isAlerted,
        "IsApproved": isApproved,
        "Count": count,
        "Redirect": redirect,
      };
}

class Data {
  Data();

  factory Data.fromJson(Map<String, dynamic> json) => Data();

  Map<String, dynamic> toJson() => {};
}
