import 'dart:convert';
import 'order_detail_modal.dart';

PostModel welcomeFromJson(String str) => PostModel.fromJson(json.decode(str));
String welcomeToJson(PostModel data) => json.encode(data.toJson());

List<PostModel> postFromJson(String str) =>
    List<PostModel>.from(json.decode(str).map((x) => PostModel.fromJson(x)));

class PostModel {
  PostModel({
    this.orderId,
    this.orderNo,
    this.tableId,
    this.receiptNo,
    this.queueNo,
    this.dateIn,
    this.dateOut,
    this.timeIn,
    this.timeOut,
    this.waiterId,
    this.userOrderId,
    this.userDiscountId,
    this.customerId,
    this.customerCount,
    this.priceListId,
    this.localCurrencyId,
    this.sysCurrencyId,
    this.exchangeRate,
    this.warehouseId,
    this.branchId,
    this.companyId,
    this.subTotal,
    this.discountRate,
    this.discountValue,
    this.typeDis,
    this.taxRate,
    this.taxValue,
    this.grandTotal,
    this.grandTotalSys,
    this.tip,
    this.received,
    this.change,
    this.currencyDisplay,
    this.displayRate,
    this.grandTotalDisplay,
    this.changeDisplay,
    this.paymentMeansId,
    this.checkBill,
    this.cancel,
    this.delete,
    this.paymentType,
    this.receivedType,
    this.credit,
    this.plCurrencyId,
    this.localSetRate,
    this.plRate,
    this.typePrinter,
    this.detail,
  });

  int orderId;
  String orderNo;
  int tableId;
  String receiptNo;
  String queueNo;
  DateTime dateIn;
  DateTime dateOut;
  String timeIn;
  String timeOut;
  int waiterId;
  dynamic userOrderId;
  int userDiscountId;
  int customerId;
  int customerCount;
  int priceListId;
  int localCurrencyId;
  int sysCurrencyId;
  double exchangeRate;
  int warehouseId;
  int branchId;
  int companyId;
  double subTotal;
  double discountRate;
  double discountValue;
  String typeDis;
  double taxRate;
  double taxValue;
  double grandTotal;
  double grandTotalSys;
  double tip;
  double received;
  double change;
  String currencyDisplay;
  double displayRate;
  double grandTotalDisplay;
  double changeDisplay;
  int paymentMeansId;
  String checkBill;
  int cancel;
  int delete;
  String paymentType;
  String receivedType;
  double credit;
  int plCurrencyId;
  double plRate;
  double localSetRate;
  String typePrinter;
  List<OrderDetail> detail;

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        orderId: json["orderId"] as int,
        orderNo: json["orderNo"] as String,
        tableId: json["tableId"] as int,
        receiptNo: json["receiptNo"] as String,
        queueNo: json["queueNo"] as String,
        dateIn: DateTime.parse(json["dateIn"]),
        dateOut: DateTime.parse(json["dateOut"]),
        timeIn: json["timeIn"] as String,
        timeOut: json["timeOut"] as String,
        waiterId: json["waiterId"] as int,
        userOrderId: json["userOrderId"] as int,
        userDiscountId: json["userDiscountId"] as int,
        customerId: json["customerId"] as int,
        customerCount: json["customerCount"] as int,
        priceListId: json["priceListId"] as int,
        localCurrencyId: json["localCurrencyId"] as int,
        sysCurrencyId: json["sysCurrencyId"] as int,
        exchangeRate: json["exchangeRate"] as double,
        warehouseId: json["warehouseId"] as int,
        branchId: json["branchId"] as int,
        companyId: json["companyId"] as int,
        subTotal: json["subTotal"] as double,
        discountRate: json["discountRate"] as double,
        discountValue: json["discountValue"] as double,
        typeDis: json["typeDis"] as String,
        taxRate: json["taxRate"] as double,
        taxValue: json["taxValue"] as double,
        grandTotal: json["grandTotal"] as double,
        grandTotalSys: json["grandTotalSys"] as double,
        tip: json["tip"] as double,
        received: json["received"] as double,
        change: json["change"] as double,
        currencyDisplay: json["currencyDisplay"] as String,
        displayRate: json["displayRate"] as double,
        grandTotalDisplay: json["grandTotalDisplay"] as double,
        changeDisplay: json["changeDisplay"] as double,
        paymentMeansId: json["paymentMeansId"] as int,
        checkBill: json["checkBill"] as String,
        cancel: json["cancel"] as int,
        delete: json["delete"] as int,
        paymentType: json["paymentType"] as String,
        receivedType: json["receivedType"] as String,
        credit: json["credit"] as double,
        plCurrencyId: json["plCurrencyId"] as int,
        localSetRate: json["localSetRate"] as double,
        plRate: json["plRate"] as double,
        typePrinter: json["typePrinter"] as String,
        detail: List<OrderDetail>.from(
          json["detail"].map((x) => OrderDetail.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "orderNo": orderNo,
        "tableId": tableId,
        "receiptNo": receiptNo,
        "queueNo": queueNo,
        "dateIn": dateIn.toIso8601String(),
        "dateOut": dateOut.toIso8601String(),
        "timeIn": timeIn,
        "timeOut": timeOut,
        "waiterId": waiterId,
        "userOrderId": userOrderId,
        "userDiscountId": userDiscountId,
        "customerId": customerId,
        "customerCount": customerCount,
        "priceListId": priceListId,
        "localCurrencyId": localCurrencyId,
        "sysCurrencyId": sysCurrencyId,
        "exchangeRate": exchangeRate,
        "warehouseId": warehouseId,
        "branchId": branchId,
        "companyId": companyId,
        "subTotal": subTotal,
        "discountRate": discountRate,
        "discountValue": discountValue,
        "typeDis": typeDis,
        "taxRate": taxRate,
        "taxValue": taxValue,
        "grandTotal": grandTotal,
        "grandTotalSys": grandTotalSys,
        "tip": tip,
        "received": received,
        "change": change,
        "currencyDisplay": currencyDisplay,
        "displayRate": displayRate,
        "grandTotalDisplay": grandTotalDisplay,
        "changeDisplay": changeDisplay,
        "paymentMeansId": paymentMeansId,
        "checkBill": checkBill,
        "cancel": cancel,
        "delete": delete,
        "paymentType": paymentType,
        "receivedType": receivedType,
        "credit": credit,
        "plCurrencyId": plCurrencyId,
        "localSetRate": localSetRate,
        "plRate": plRate,
        "typePrinter": typePrinter,
        "detail": List<dynamic>.from(detail.map((x) => x.toMap())),
      };
}
