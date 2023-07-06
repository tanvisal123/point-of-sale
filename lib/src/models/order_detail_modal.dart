class OrderDetail {
  int id;
  int masterId;
  int orderDetailId;
  int orderId;
  int lineId;
  int itemId;
  String code;
  String khmerName;
  String englishName;
  double qty;
  double printQty;
  double unitPrice;
  double cost;
  double discountRate;
  double discountValue;
  String typeDis;
  double total;
  double totalSys;
  int uomId;
  String uomName;
  String itemStatus;
  String itemPrintTo;
  String currency;
  String comment;
  String itemType;
  String description;
  String parentLevel;
  String image;
  int show;

  @override
  String toString() {
    return 'No = $id, Name = $khmerName, Qty = $qty, UnitPrice = $unitPrice';
  }

  OrderDetail({
    this.id,
    this.masterId,
    this.orderDetailId,
    this.orderId,
    this.lineId,
    this.itemId,
    this.code,
    this.khmerName,
    this.englishName,
    this.qty,
    this.printQty,
    this.unitPrice,
    this.cost,
    this.discountRate,
    this.discountValue,
    this.typeDis,
    this.total,
    this.totalSys,
    this.uomId,
    this.uomName,
    this.itemStatus,
    this.itemPrintTo,
    this.currency,
    this.comment,
    this.itemType,
    this.description,
    this.parentLevel,
    this.image,
    this.show,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
        id: json["id"] as int,
        masterId: json["masterId"] as int,
        orderDetailId: json["orderDetailId"] as int,
        orderId: json["orderId"] as int,
        lineId: json["lineId"] as int,
        itemId: json["itemId"] as int,
        code: json["code"] as String,
        khmerName: json["khmerName"] as String,
        englishName: json["englishName"] as String,
        qty: json["qty"] as double,
        printQty: json["printQty"] as double,
        unitPrice: json["unitPrice"] as double,
        cost: json["cost"] as double,
        discountRate: json["discountRate"] as double,
        discountValue: json["discountValue"] as double,
        typeDis: json["typeDis"] as String,
        total: json["total"] as double,
        totalSys: json["totalSys"] as double,
        uomId: json["uomId"] as int,
        uomName: json["uomName"] as String,
        itemStatus: json["itemStatus"] as String,
        itemPrintTo: json["itemPrintTo"] as String,
        currency: json["currency"] as String,
        comment: json["comment"] as String,
        itemType: json["itemType"] as String,
        description: json["description"] as String,
        parentLevel: json["parentLevel"] as String,
        image: json["image"] as String,
        show: json["show"] as int,
      );
  Map<String, dynamic> toMap() => {
        "id": id,
        "masterId": masterId,
        "orderDetailId": orderDetailId,
        "orderId": orderId,
        "lineId": lineId,
        "itemId": itemId,
        "code": code,
        "khmerName": khmerName,
        "englishName": englishName,
        "qty": qty,
        "printQty": printQty,
        "unitPrice": unitPrice,
        "cost": cost,
        "discountRate": discountRate,
        "discountValue": discountValue,
        "typeDis": typeDis,
        "total": total,
        "totalSys": totalSys,
        "uomId": uomId,
        "uomName": uomName,
        "itemStatus": itemStatus,
        "itemPrintTo": itemPrintTo,
        "currency": currency,
        "comment": comment,
        "itemType": itemType,
        "description": description,
        "parentLevel": parentLevel,
        "image": image,
        "show": show
      };
}
