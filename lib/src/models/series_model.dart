import 'dart:convert';

SeriesModel seriesModelFromJson(String str) =>
    SeriesModel.fromJson(json.decode(str));

String seriesModelToJson(SeriesModel data) => json.encode(data.toJson());

class SeriesModel {
  SeriesModel({
    this.id,
    this.name,
    this.firstNo,
    this.nextNo,
    this.lastNo,
    this.preFix,
    this.docuTypeId,
    this.periodIndId,
    this.seriesModelDefault,
    this.lock,
    this.companyId,
  });

  int id;
  String name;
  String firstNo;
  String nextNo;
  String lastNo;
  String preFix;
  int docuTypeId;
  int periodIndId;
  bool seriesModelDefault;
  bool lock;
  int companyId;
  @override
  String toString() {
    return 'Name = $name, FirstNo = $firstNo, NextNo = $nextNo, LastNo = $lastNo';
  }

  factory SeriesModel.fromJson(Map<String, dynamic> json) => SeriesModel(
        id: json["ID"],
        name: json["Name"],
        firstNo: json["FirstNo"],
        nextNo: json["NextNo"],
        lastNo: json["LastNo"],
        preFix: json["PreFix"],
        docuTypeId: json["DocuTypeID"],
        periodIndId: json["PeriodIndID"],
        seriesModelDefault: json["Default"],
        lock: json["Lock"],
        companyId: json["CompanyID"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Name": name,
        "FirstNo": firstNo,
        "NextNo": nextNo,
        "LastNo": lastNo,
        "PreFix": preFix,
        "DocuTypeID": docuTypeId,
        "PeriodIndID": periodIndId,
        "Default": seriesModelDefault,
        "Lock": lock,
        "CompanyID": companyId,
      };
}
