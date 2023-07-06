class CombineReceipt {
  int orderId;
  int tableId;
  String orderNo;
  String tableName;
  bool isCheck;
  List<Receipt> receipts;

  CombineReceipt(
      {this.orderId,
      this.tableId,
      this.orderNo,
      this.tableName,
      this.isCheck,
      this.receipts});

  CombineReceipt.fromJson(Map<String, dynamic> json) {
    orderId = json['OrderID'];
    tableId = json['TableID'];
    orderNo = json['OrderNo'];
    tableName = json['TableName'];
    isCheck = json['IsCheck'];
    if (json['Receipts'] != null) {
      receipts = new List<Receipt>();
      json['Receipts'].forEach((v) {
        receipts.add(new Receipt.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OrderID'] = this.orderId;
    data['TableID'] = this.tableId;
    data['OrderNo'] = this.orderNo;
    data['TableName'] = this.tableName;
    data['IsCheck'] = this.isCheck;
    if (this.receipts != null) {
      data['Receipts'] = this.receipts.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Receipt {
  int orderID;

  Receipt({this.orderID});

  Receipt.fromJson(Map<String, dynamic> json) {
    orderID = json['OrderID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OrderID'] = this.orderID;
    return data;
  }
}
