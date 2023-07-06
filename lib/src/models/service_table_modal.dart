import 'dart:convert';

ServiceTableModel groupTableModelFromJson(String str) =>
    ServiceTableModel.fromJson(json.decode(str));

String groupTableModelToJson(ServiceTableModel data) =>
    json.encode(data.toJson());

class ServiceTableModel {
  ServiceTableModel({
    this.groupTables,
    this.tables,
  });

  List<GroupTable> groupTables;
  List<Table> tables;

  factory ServiceTableModel.fromJson(Map<String, dynamic> json) =>
      ServiceTableModel(
        groupTables: List<GroupTable>.from(
            json["GroupTables"].map((x) => GroupTable.fromJson(x))),
        tables: List<Table>.from(json["Tables"].map((x) => Table.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "GroupTables": List<dynamic>.from(groupTables.map((x) => x.toJson())),
        "Tables": List<dynamic>.from(tables.map((x) => x.toJson())),
      };
}

class GroupTable {
  GroupTable({
    this.id,
    this.name,
    this.branchId,
    this.types,
    this.image,
    this.delete,
    this.branch,
  });

  int id;
  String name;
  int branchId;
  String types;
  dynamic image;
  bool delete;
  Branch branch;

  factory GroupTable.fromJson(Map<String, dynamic> json) => GroupTable(
        id: json["ID"],
        name: json["Name"],
        branchId: json["BranchID"],
        types: json["Types"],
        image: json["Image"],
        delete: json["Delete"],
        branch: Branch.fromJson(json["Branch"]),
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Name": name,
        "BranchID": branchId,
        "Types": types,
        "Image": image,
        "Delete": delete,
        "Branch": branch.toJson(),
      };
}

class Branch {
  Branch({
    this.id,
    this.name,
    this.companyId,
    this.company,
    this.location,
    this.address,
    this.delete,
  });

  int id;
  String name;
  int companyId;
  Company company;
  String location;
  String address;
  bool delete;

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
        id: json["ID"],
        name: json["Name"],
        companyId: json["CompanyID"],
        company: Company.fromJson(json["Company"]),
        location: json["Location"],
        address: json["Address"],
        delete: json["Delete"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Name": name,
        "CompanyID": companyId,
        "Company": company.toJson(),
        "Location": location,
        "Address": address,
        "Delete": delete,
      };
}

class Company {
  Company({
    this.id,
    this.name,
    this.priceListId,
    this.location,
    this.address,
    this.process,
    this.delete,
    this.systemCurrencyId,
    this.localCurrencyId,
    this.logo,
    this.priceList,
    this.systemCurrency,
    this.localCurrency,
    this.tenantId,
  });

  int id;
  String name;
  int priceListId;
  String location;
  String address;
  String process;
  bool delete;
  int systemCurrencyId;
  int localCurrencyId;
  String logo;
  dynamic priceList;
  dynamic systemCurrency;
  dynamic localCurrency;
  String tenantId;

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json["ID"],
        name: json["Name"],
        priceListId: json["PriceListID"],
        location: json["Location"],
        address: json["Address"],
        process: json["Process"],
        delete: json["Delete"],
        systemCurrencyId: json["SystemCurrencyID"],
        localCurrencyId: json["LocalCurrencyID"],
        logo: json["Logo"],
        priceList: json["PriceList"],
        systemCurrency: json["SystemCurrency"],
        localCurrency: json["LocalCurrency"],
        tenantId: json["TenantID"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Name": name,
        "PriceListID": priceListId,
        "Location": location,
        "Address": address,
        "Process": process,
        "Delete": delete,
        "SystemCurrencyID": systemCurrencyId,
        "LocalCurrencyID": localCurrencyId,
        "Logo": logo,
        "PriceList": priceList,
        "SystemCurrency": systemCurrency,
        "LocalCurrency": localCurrency,
        "TenantID": tenantId,
      };
}

class Table {
  Table({
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
  GroupTable groupTable;

  factory Table.fromJson(Map<String, dynamic> json) => Table(
        id: json["ID"],
        name: json["Name"],
        groupTableId: json["GroupTableID"],
        image: json["Image"],
        status: json["Status"],
        time: json["Time"],
        delete: json["Delete"],
        groupTable: GroupTable.fromJson(json["GroupTable"]),
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Name": name,
        "GroupTableID": groupTableId,
        "Image": image,
        "Status": status,
        "Time": time,
        "Delete": delete,
        "GroupTable": groupTable.toJson(),
      };
}
