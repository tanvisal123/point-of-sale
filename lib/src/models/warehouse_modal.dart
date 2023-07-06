class Warehouse {
  int wareId;
  String wareName;
  int branchId;
  Warehouse({this.wareId, this.wareName, this.branchId});

  factory Warehouse.fromJson(Map<String, dynamic> json) => Warehouse(
      wareId: json["Id"] as int,
      wareName: json["name"] as String,
      branchId: json["branchId"] as int);
}
