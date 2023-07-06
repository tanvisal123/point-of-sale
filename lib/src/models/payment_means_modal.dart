import 'dart:convert';

List<PaymentMeanModel> paymentMeanModelFromJson(String str) =>
    List<PaymentMeanModel>.from(
        json.decode(str).map((x) => PaymentMeanModel.fromJson(x)));

class PaymentMeanModel {
  int id;
  String type;
  PaymentMeanModel({this.id, this.type});

  @override
  String toString() {
    return 'PayMeanId = $id\nType = $type\n';
  }

  factory PaymentMeanModel.fromJson(Map<String, dynamic> json) =>
      PaymentMeanModel(id: json['id'] as int, type: json['type'] as String);

  Map<String, dynamic> toMap() => {'id': id, 'type': type};
}
