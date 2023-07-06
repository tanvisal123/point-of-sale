// To parse this JSON data, do
//
//     final combineOrder = combineOrderFromJson(jsonString);

import 'dart:convert';
import 'package:point_of_sale/src/models/order_to_combine.dart';

CombineOrder combineOrderFromJson(String str) =>
    CombineOrder.fromJson(json.decode(str));

String combineOrderToJson(CombineOrder data) => json.encode(data.toJson());

class CombineOrder {
  CombineOrder({
    this.tableId,
    this.orderId,
    this.orders,
  });

  int tableId;
  int orderId;
  List<OrderToCombine> orders;

  factory CombineOrder.fromJson(Map<String, dynamic> json) => CombineOrder(
        tableId: json["TableId"],
        orderId: json["OrderID"],
        orders: List<OrderToCombine>.from(
            json["Orders"].map((x) => OrderToCombine.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "TableID": tableId,
        "OrderID": orderId,
        "Orders": List<dynamic>.from(orders.map((x) => x.toJson())),
      };
}
