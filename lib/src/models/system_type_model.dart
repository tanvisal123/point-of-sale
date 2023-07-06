import 'dart:convert';

class SystemTypeModel {
  final bool krms;
  final bool kbms;
  final bool ktms;

  SystemTypeModel({
    this.krms,
    this.kbms,
    this.ktms,
  });

  factory SystemTypeModel.fromJson(Map<String, dynamic> json) =>
      SystemTypeModel(
        krms: json["krms"] as bool,
        kbms: json["kbms"] as bool,
        ktms: json["ktms"] as bool,
      );
  Map<String, dynamic> toMap() => {
        "krms": krms,
        "kbms": kbms,
        "ktms": ktms,
      };
}

List<String> systemTypesFromJson(String str) =>
    List<String>.from(json.decode(str).map((x) => x));

String systemTypesToJson(List<String> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x)));
