import 'dart:convert';

List<PendingVoidItemModel> pendingVoidItemModelFromJson(String str) =>
    List<PendingVoidItemModel>.from(
        json.decode(str).map((x) => PendingVoidItemModel.fromJson(x)));

String pendingVoidItemModelToJson(List<PendingVoidItemModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PendingVoidItemModel {
  PendingVoidItemModel({
    this.id,
    this.orderId,
    this.orderNo,
    this.queueNo,
    this.cashier,
    this.date,
    this.time,
    this.table,
    this.amount,
    this.isVoided,
  });

  int id;
  int orderId;
  String orderNo;
  String queueNo;
  String cashier;
  String date;
  String time;
  String table;
  String amount;
  bool isVoided;

  factory PendingVoidItemModel.fromJson(Map<String, dynamic> json) =>
      PendingVoidItemModel(
        id: json["ID"],
        orderId: json["OrderID"],
        orderNo: json["OrderNo"],
        queueNo: json["QueueNo"],
        cashier: json["Cashier"],
        date: json["Date"],
        time: json["Time"],
        table: json["Table"],
        amount: json["Amount"],
        isVoided: json["IsVoided"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "OrderID": orderId,
        "OrderNo": orderNo,
        "QueueNo": queueNo,
        "Cashier": cashier,
        "Date": date,
        "Time": time,
        "Table": table,
        "Amount": amount,
        "IsVoided": isVoided,
      };
}
