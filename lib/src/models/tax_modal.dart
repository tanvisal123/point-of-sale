import 'dart:convert';

List<TaxModel> taxModelFromJson(String str) =>
    List<TaxModel>.from(json.decode(str).map((x) => TaxModel.fromJson(x)));

String taxModelToJson(List<TaxModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TaxModel {
  TaxModel({
    this.id,
    this.name,
    this.rate,
  });

  int id;
  String name;
  double rate;

  factory TaxModel.fromJson(Map<String, dynamic> json) => TaxModel(
        id: json["id"],
        name: json["name"],
        rate: json["rate"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "rate": rate,
      };
}
