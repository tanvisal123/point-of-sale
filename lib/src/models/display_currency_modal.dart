import 'dart:convert';

List<DisplayCurrModel> displayCurrModelFromJson(String str) =>
    List<DisplayCurrModel>.from(
        json.decode(str).map((x) => DisplayCurrModel.fromJson(x)));

String displayCurrModelToJson(List<DisplayCurrModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DisplayCurrModel {
  DisplayCurrModel({
    this.id,
    this.altCurr,
    this.baseCurr,
    this.rate,
  });

  int id;
  String altCurr;
  String baseCurr;
  double rate;

  factory DisplayCurrModel.fromJson(Map<String, dynamic> json) =>
      DisplayCurrModel(
        id: json["id"],
        altCurr: json["altCurr"],
        baseCurr: json["baseCurr"],
        rate: json["rate"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "altCurr": altCurr,
        "baseCurr": baseCurr,
        "rate": rate,
      };
}
