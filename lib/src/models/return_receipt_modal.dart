class ReturnReceipts {
  int receiptID;
  String receiptNo;
  String employee;

  ReturnReceipts({this.receiptID, this.receiptNo, this.employee});

  ReturnReceipts.fromJson(Map<String, dynamic> json) {
    receiptID = json['ReceiptID'];
    receiptNo = json['ReceiptNo'];
    employee = json['Employee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ReceiptID'] = this.receiptID;
    data['ReceiptNo'] = this.receiptNo;
    data['Employee'] = this.employee;
    return data;
  }
}
