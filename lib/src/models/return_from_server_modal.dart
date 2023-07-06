import 'dart:convert';

class ReturnFromServer {
  String status;
  List<ItemReturn> data;
  ReturnFromServer({this.status, this.data});

  ReturnFromServer.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(ItemReturn.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> datas = Map<String, dynamic>();
    datas['status'] = this.status;
    if (this.data != null) {
      datas['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return datas;
  }
}

class ItemReturn {
  int lineId;
  int itemId;
  String code;
  String uom;
  String khmerName;
  double inStock;
  double orderQty;
  double committed;

  ItemReturn({
    this.lineId,
    this.itemId,
    this.code,
    this.uom,
    this.khmerName,
    this.inStock,
    this.orderQty,
    this.committed,
  });

  ItemReturn.fromJson(Map<String, dynamic> json) {
    lineId = json['Line_ID'];
    itemId = json['ItemID'];
    code = json['Code'];
    uom = json['Uom'];
    khmerName = json['KhmerName'];
    inStock = json['InStock'];
    orderQty = json['OrderQty'];
    committed = json['Committed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Line_ID'] = this.lineId;
    data['ItemID'] = this.itemId;
    data['Code'] = this.code;
    data['Uom'] = this.uom;
    data['KhmerName'] = this.khmerName;
    data['InStock'] = this.inStock;
    data['OrderQty'] = this.orderQty;
    data['Committed'] = this.committed;
    return data;
  }
}

ReturnFromServers returnFromServersFromJson(String str) =>
    ReturnFromServers.fromJson(json.decode(str));

String returnFromServersToJson(ReturnFromServers data) =>
    json.encode(data.toJson());

class ReturnFromServers {
  ReturnFromServers({
    this.itemsReturns,
    this.receiptId,
    this.receiptNo,
  });

  List<dynamic> itemsReturns;
  int receiptId;
  String receiptNo;

  factory ReturnFromServers.fromJson(Map<String, dynamic> json) =>
      ReturnFromServers(
        itemsReturns: List<dynamic>.from(json["ItemsReturns"].map((x) => x)),
        receiptId: json["ReceiptID"],
        receiptNo: json["ReceiptNo"],
      );

  Map<String, dynamic> toJson() => {
        "ItemsReturns": List<dynamic>.from(itemsReturns.map((x) => x)),
        "ReceiptID": receiptId,
        "ReceiptNo": receiptNo,
      };
}
