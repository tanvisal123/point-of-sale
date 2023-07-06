import 'dart:convert';

List<TableModel> tableModelFromJson(String str) =>
    List<TableModel>.from(json.decode(str).map((x) => TableModel.fromJson(x)));

String tableModelToJson(List<TableModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TableModel {
  TableModel({
    this.id,
    this.name,
    this.groupTableId,
    this.image,
    this.status,
    this.time,
    this.delete,
    this.groupTable,
  });

  int id;
  String name;
  int groupTableId;
  String image;
  String status;
  String time;
  bool delete;
  dynamic groupTable;

  factory TableModel.fromJson(Map<String, dynamic> json) => TableModel(
        id: json["ID"],
        name: json["Name"],
        groupTableId: json["GroupTableID"],
        image: json["Image"],
        status: json["Status"],
        time: json["Time"],
        delete: json["Delete"],
        groupTable: json["GroupTable"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Name": name,
        "GroupTableID": groupTableId,
        "Image": image,
        "Status": status,
        "Time": time,
        "Delete": delete,
        "GroupTable": groupTable,
      };
}
