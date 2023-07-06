import 'dart:convert';

List<GroupItemModel> groupItemModelFromJson(String str) =>
    List<GroupItemModel>.from(
        json.decode(str).map((x) => GroupItemModel.fromJson(x)));

String groupItemModelToJson(List<GroupItemModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GroupItemModel {
  GroupItemModel({
    this.g1Id,
    this.g2Id,
    this.g3Id,
    this.name,
    this.image,
  });

  int g1Id;
  int g2Id;
  int g3Id;
  String name;
  String image;

  factory GroupItemModel.fromJson(Map<String, dynamic> json) => GroupItemModel(
        g1Id: json["g1Id"],
        g2Id: json["g2Id"],
        g3Id: json["g3Id"],
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "g1Id": g1Id,
        "g2Id": g2Id,
        "g3Id": g3Id,
        "name": name,
        "image": image,
      };
}
