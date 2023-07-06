// To parse this JSON data, do
//
//     final saveDisplayCurrencies = saveDisplayCurrenciesFromJson(jsonString);

import 'dart:convert';

SaveDisplayCurrencies saveDisplayCurrenciesFromJson(String str) =>
    SaveDisplayCurrencies.fromJson(json.decode(str));

String saveDisplayCurrenciesToJson(SaveDisplayCurrencies data) =>
    json.encode(data.toJson());

class SaveDisplayCurrencies {
  SaveDisplayCurrencies({
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
  Items items;
  int action;
  bool isRejected;
  bool isAlerted;
  bool isApproved;
  int count;
  dynamic redirect;

  factory SaveDisplayCurrencies.fromJson(Map<String, dynamic> json) =>
      SaveDisplayCurrencies(
        data: Data.fromJson(json["Data"]),
        items: Items.fromJson(json["Items"]),
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
  Data({
    this.displayCurrency,
  });

  String displayCurrency;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        displayCurrency: json["DisplayCurrency"],
      );

  Map<String, dynamic> toJson() => {
        "DisplayCurrency": displayCurrency,
      };
}

class Items {
  Items();

  factory Items.fromJson(Map<String, dynamic> json) => Items();

  Map<String, dynamic> toJson() => {};
}
