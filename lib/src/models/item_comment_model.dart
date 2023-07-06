import 'dart:convert';

List<ItemCommentModel> itemCommentModelFromJson(String str) =>
    List<ItemCommentModel>.from(
        json.decode(str).map((x) => ItemCommentModel.fromJson(x)));

String itemCommentModelToJson(List<ItemCommentModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ItemCommentModel {
  ItemCommentModel({
    this.id,
    this.description,
    this.deleted,
  });

  final int id;
  final String description;
  final bool deleted;

  factory ItemCommentModel.fromJson(Map<String, dynamic> json) =>
      ItemCommentModel(
        id: json["ID"],
        description: json["Description"],
        deleted: json["Deleted"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Description": description,
        "Deleted": deleted,
      };
}
