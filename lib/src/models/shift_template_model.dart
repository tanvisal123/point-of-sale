// To parse this JSON data, do
//
//     final openShiftModel = openShiftModelFromJson(jsonString);

import 'dart:convert';

ShiftTemplateModel openShiftModelFromJson(String str) =>
    ShiftTemplateModel.fromJson(json.decode(str));

String openShiftModelToJson(ShiftTemplateModel data) =>
    json.encode(data.toJson());

class ShiftTemplateModel {
  ShiftTemplateModel({
    this.grandTotalSys,
    this.currencySys,
    this.shiftForms,
  });

  double grandTotalSys;
  String currencySys;
  List<ShiftForm> shiftForms;

  factory ShiftTemplateModel.fromJson(Map<String, dynamic> json) =>
      ShiftTemplateModel(
        grandTotalSys: json["GrandTotalSys"].toDouble(),
        currencySys: json["CurrencySys"],
        shiftForms: List<ShiftForm>.from(
            json["ShiftForms"].map((x) => ShiftForm.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "GrandTotalSys": grandTotalSys,
        "CurrencySys": currencySys,
        "ShiftForms": List<dynamic>.from(shiftForms.map((x) => x.toJson())),
      };
}

class ShiftForm {
  ShiftForm({
    this.id,
    this.decription,
    this.inputCash,
    this.currency,
    this.rateIn,
    this.amount,
  });

  int id;
  String decription;
  double inputCash;
  String currency;
  double rateIn;
  double amount;

  factory ShiftForm.fromJson(Map<String, dynamic> json) => ShiftForm(
        id: json["ID"],
        decription: json["Decription"],
        inputCash: json["InputCash"],
        currency: json["Currency"],
        rateIn: json["RateIn"].toDouble(),
        amount: json["Amount"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Decription": decription,
        "InputCash": inputCash,
        "Currency": currency,
        "RateIn": rateIn,
        "Amount": amount,
      };
}
