// To parse this JSON data, do
//
//     final currency = currencyFromJson(jsonString);
import 'dart:convert';

CurrencyModel currencyFromJson(String str) =>
    CurrencyModel.fromJson(json.decode(str));

String currencyToJson(CurrencyModel data) => json.encode(data.toJson());

class CurrencyModel {
  CurrencyModel({
    this.id,
    this.symbol,
    this.description,
    this.delete,
    this.spk,
    this.cpk,
    this.synced,
    this.syncDate,
  });

  int id;
  String symbol;
  String description;
  bool delete;
  int spk;
  int cpk;
  bool synced;
  DateTime syncDate;

  factory CurrencyModel.fromJson(Map<String, dynamic> json) => CurrencyModel(
        id: json["ID"],
        symbol: json["Symbol"],
        description: json["Description"],
        delete: json["Delete"],
        spk: json["Spk"],
        cpk: json["Cpk"],
        synced: json["Synced"],
        syncDate: DateTime.parse(json["SyncDate"]),
      );
  Map<String, dynamic> toJson() => {
        "ID": id,
        "Symbol": symbol,
        "Description": description,
        "Delete": delete,
        "Spk": spk,
        "Cpk": cpk,
        "Synced": synced,
        "SyncDate": syncDate.toIso8601String(),
      };
}
