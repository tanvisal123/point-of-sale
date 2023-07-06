import 'dart:convert';

List<CompanyModel> companyModelFromJson(String str) => List<CompanyModel>.from(
    json.decode(str).map((x) => CompanyModel.fromJson(x)));

String companyModelToJson(List<CompanyModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CompanyModel {
  CompanyModel({
    this.id,
    this.name,
    this.image,
    this.priceListId,
  });

  int id;
  String name;
  String image;
  int priceListId;

  factory CompanyModel.fromJson(Map<String, dynamic> json) => CompanyModel(
        id: json["Id"],
        name: json["name"],
        image: json["image"],
        priceListId: json["priceListId"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "name": name,
        "image": image,
        "priceListId": priceListId,
      };
}
