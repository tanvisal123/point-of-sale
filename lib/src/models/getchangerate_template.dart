// To parse this JSON data, do
//
//     final getChangeRateTemplate = getChangeRateTemplateFromJson(jsonString);

import 'dart:convert';

List<GetChangeRateTemplate> getChangeRateTemplateFromJson(String str) =>
    List<GetChangeRateTemplate>.from(
        json.decode(str).map((x) => GetChangeRateTemplate.fromJson(x)));

String getChangeRateTemplateToJson(List<GetChangeRateTemplate> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetChangeRateTemplate {
  GetChangeRateTemplate({
    this.id,
    this.lineId,
    this.priceListId,
    this.altCurrencyId,
    this.plCurrencyName,
    this.alCurrencyName,
    this.plDisplayRate,
    this.altCurrencies,
    this.displayRate,
    this.decimalPlaces,
    this.curPlid,
    this.isActive,
    this.isShowCurrency,
    this.isShowOtherCurrency,
  });

  int id;
  String lineId;
  int priceListId;
  int altCurrencyId;
  String plCurrencyName;
  String alCurrencyName;
  double plDisplayRate;
  dynamic altCurrencies;
  double displayRate;
  double decimalPlaces;
  int curPlid;
  bool isActive;
  bool isShowCurrency;
  bool isShowOtherCurrency;

  factory GetChangeRateTemplate.fromJson(Map<String, dynamic> json) =>
      GetChangeRateTemplate(
        id: json["ID"],
        lineId: json["LineID"],
        priceListId: json["PriceListID"],
        altCurrencyId: json["AltCurrencyID"],
        plCurrencyName: json["PLCurrencyName"],
        alCurrencyName: json["ALCurrencyName"],
        plDisplayRate: json["PLDisplayRate"].toDouble(),
        altCurrencies: json["AltCurrencies"],
        displayRate: json["DisplayRate"],
        decimalPlaces: json["DecimalPlaces"],
        curPlid: json["CurPLID"],
        isActive: json["IsActive"],
        isShowCurrency: json["IsShowCurrency"],
        isShowOtherCurrency: json["IsShowOtherCurrency"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "LineID": lineId,
        "PriceListID": priceListId,
        "AltCurrencyID": altCurrencyId,
        "PLCurrencyName": plCurrencyName,
        "ALCurrencyName": alCurrencyName,
        "PLDisplayRate": plDisplayRate,
        "AltCurrencies": altCurrencies,
        "DisplayRate": displayRate,
        "DecimalPlaces": decimalPlaces,
        "CurPLID": curPlid,
        "IsActive": isActive,
        "IsShowCurrency": isShowCurrency,
        "IsShowOtherCurrency": isShowOtherCurrency,
      };
}
