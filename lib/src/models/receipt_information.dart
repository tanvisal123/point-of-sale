class ReceiptInformation {
  int id;
  int branchId;
  String branchName;
  String address;
  String deskhmer;
  String desEnglish;
  String logo;
  String phone1;
  String phone2;
  String title;

  ReceiptInformation({
    this.id,
    this.branchId,
    this.branchName,
    this.address,
    this.deskhmer,
    this.desEnglish,
    this.logo,
    this.phone1,
    this.phone2,
    this.title,
  });
  factory ReceiptInformation.fromJson(Map<String, dynamic> json) =>
      ReceiptInformation(
        id: json["id"] as int,
        branchId: json["branchId"] as int,
        branchName: json["branchName"] as String,
        address: json["address"] as String,
        deskhmer: json["deskhmer"] as String,
        desEnglish: json["desEnglish"] as String,
        logo: json["logo"] as String,
        phone1: json["phone1"] as String,
        phone2: json["phone2"] as String,
        title: json["title"] as String,
      );
  Map<String, dynamic> toMap() => {
        'id': id,
        'branchId': branchId,
        'branchName': branchName,
        "address": address,
        "deskhmer": deskhmer,
        "desEnglish": desEnglish,
        "logo": logo,
        "phone1": phone1,
        "phone2": phone2,
        "title": title,
      };
}
