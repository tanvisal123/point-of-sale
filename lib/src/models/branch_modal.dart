class Branch {
  int branId;
  String branName;
  int companyId;

  Branch({this.branId, this.branName, this.companyId});
  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
        branId: json["Id"] as int,
        branName: json["name"] as String,
        companyId: json["companyId"] as int,
      );
}
