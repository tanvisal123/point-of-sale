import 'dart:convert';

TableOrdered tableOrderedFromJson(String str) =>
    TableOrdered.fromJson(json.decode(str));

String tableOrderedToJson(TableOrdered data) => json.encode(data.toJson());

class TableOrdered {
  TableOrdered({
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
  @override
  String toString() {
    return 'Id = $id, Name = $name';
  }

  factory TableOrdered.fromJson(Map<String, dynamic> json) => TableOrdered(
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
