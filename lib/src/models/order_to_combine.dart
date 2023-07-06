// To parse this JSON data, do
//
//     final orderToCombine = orderToCombineFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<OrderToCombine> orderToCombineFromJson(String str) =>
    List<OrderToCombine>.from(
        json.decode(str).map((x) => OrderToCombine.fromJson(x)));

String orderToCombineToJson(List<OrderToCombine> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderToCombine {
  OrderToCombine({
    this.orderId,
    this.postingDate,
    this.orderNo,
    this.customerCode,
    this.customerName,
    this.tableId,
    this.receiptNo,
    this.queueNo,
    this.dateIn,
    this.timeIn,
    this.dateOut,
    this.timeOut,
    this.multiPaymentMeans,
    this.waiterId,
    this.userOrderId,
    this.userDiscountId,
    this.customerId,
    this.customer,
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
    this.otherPaymentGrandTotal,
    this.grandTotal,
    this.grandTotalSys,
    this.appliedAmount,
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
    this.plCurrencyId,
    this.plRate,
    this.localSetRate,
    this.seriesId,
    this.seriesDid,
    this.orderDetail,
    this.serialNumbers,
    this.batchNos,
    this.currency,
    this.remark,
    this.reason,
    this.male,
    this.female,
    this.children,
    this.status,
    this.freights,
    this.freightAmount,
    this.titleNote,
    this.vehicleId,
    this.taxOption,
    this.promoCodeId,
    this.promoCodeDiscRate,
    this.promoCodeDiscValue,
    this.remarkDiscountId,
    this.buyXAmountGetXDisId,
    this.buyXAmGetXDisRate,
    this.buyXAmGetXDisValue,
    this.cardMemberDiscountRate,
    this.cardMemberDiscountValue,
    this.buyXAmGetXDisType,
    this.taxGroupId,
    this.grandTotalCurrencies,
    this.changeCurrencies,
    this.grandTotalCurrenciesDisplay,
    this.grandTotalOtherCurrenciesDisplay,
    this.grandTotalOtherCurrencies,
    this.changeCurrenciesDisplay,
    this.displayPayOtherCurrency,
    this.paymentType,
    this.selected,
  });

  int orderId;
  DateTime postingDate;
  String orderNo;
  dynamic customerCode;
  dynamic customerName;
  int tableId;
  String receiptNo;
  String queueNo;
  DateTime dateIn;
  String timeIn;
  DateTime dateOut;
  String timeOut;
  dynamic multiPaymentMeans;
  int waiterId;
  int userOrderId;
  int userDiscountId;
  int customerId;
  dynamic customer;
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
  double otherPaymentGrandTotal;
  double grandTotal;
  double grandTotalSys;
  double appliedAmount;
  double tip;
  double received;
  double change;
  String currencyDisplay;
  double displayRate;
  double grandTotalDisplay;
  double changeDisplay;
  int paymentMeansId;
  String checkBill;
  bool cancel;
  bool delete;
  int plCurrencyId;
  double plRate;
  double localSetRate;
  int seriesId;
  int seriesDid;
  dynamic orderDetail;
  dynamic serialNumbers;
  dynamic batchNos;
  dynamic currency;
  dynamic remark;
  dynamic reason;
  int male;
  int female;
  int children;
  int status;
  dynamic freights;
  double freightAmount;
  String titleNote;
  int vehicleId;
  int taxOption;
  int promoCodeId;
  double promoCodeDiscRate;
  double promoCodeDiscValue;
  int remarkDiscountId;
  int buyXAmountGetXDisId;
  double buyXAmGetXDisRate;
  double buyXAmGetXDisValue;
  double cardMemberDiscountRate;
  double cardMemberDiscountValue;
  int buyXAmGetXDisType;
  int taxGroupId;
  dynamic grandTotalCurrencies;
  dynamic changeCurrencies;
  String grandTotalCurrenciesDisplay;
  String grandTotalOtherCurrenciesDisplay;
  dynamic grandTotalOtherCurrencies;
  String changeCurrenciesDisplay;
  dynamic displayPayOtherCurrency;
  int paymentType;
  bool selected;

  factory OrderToCombine.fromJson(Map<String, dynamic> json) => OrderToCombine(
        orderId: json["OrderID"],
        postingDate: DateTime.parse(json["PostingDate"]),
        orderNo: json["OrderNo"],
        customerCode: json["CustomerCode"],
        customerName: json["CustomerName"],
        tableId: json["TableID"],
        receiptNo: json["ReceiptNo"],
        queueNo: json["QueueNo"],
        dateIn: DateTime.parse(json["DateIn"]),
        timeIn: json["TimeIn"],
        dateOut: DateTime.parse(json["DateOut"]),
        timeOut: json["TimeOut"],
        multiPaymentMeans: json["MultiPaymentMeans"],
        waiterId: json["WaiterID"],
        userOrderId: json["UserOrderID"],
        userDiscountId: json["UserDiscountID"],
        customerId: json["CustomerID"],
        customer: json["Customer"],
        customerCount: json["CustomerCount"],
        priceListId: json["PriceListID"],
        localCurrencyId: json["LocalCurrencyID"],
        sysCurrencyId: json["SysCurrencyID"],
        exchangeRate: json["ExchangeRate"],
        warehouseId: json["WarehouseID"],
        branchId: json["BranchID"],
        companyId: json["CompanyID"],
        subTotal: json["Sub_Total"],
        discountRate: json["DiscountRate"],
        discountValue: json["DiscountValue"],
        typeDis: json["TypeDis"],
        taxRate: json["TaxRate"],
        taxValue: json["TaxValue"],
        otherPaymentGrandTotal: json["OtherPaymentGrandTotal"],
        grandTotal: json["GrandTotal"],
        grandTotalSys: json["GrandTotal_Sys"],
        appliedAmount: json["AppliedAmount"],
        tip: json["Tip"],
        received: json["Received"],
        change: json["Change"],
        currencyDisplay: json["CurrencyDisplay"],
        displayRate: json["DisplayRate"],
        grandTotalDisplay: json["GrandTotal_Display"],
        changeDisplay: json["Change_Display"],
        paymentMeansId: json["PaymentMeansID"],
        checkBill: json["CheckBill"],
        cancel: json["Cancel"],
        delete: json["Delete"],
        plCurrencyId: json["PLCurrencyID"],
        plRate: json["PLRate"],
        localSetRate: json["LocalSetRate"],
        seriesId: json["SeriesID"],
        seriesDid: json["SeriesDID"],
        orderDetail: json["OrderDetail"],
        serialNumbers: json["SerialNumbers"],
        batchNos: json["BatchNos"],
        currency: json["Currency"],
        remark: json["Remark"],
        reason: json["Reason"],
        male: json["Male"],
        female: json["Female"],
        children: json["Children"],
        status: json["Status"],
        freights: json["Freights"],
        freightAmount: json["FreightAmount"],
        titleNote: json["TitleNote"],
        vehicleId: json["VehicleID"],
        taxOption: json["TaxOption"],
        promoCodeId: json["PromoCodeID"],
        promoCodeDiscRate: json["PromoCodeDiscRate"],
        promoCodeDiscValue: json["PromoCodeDiscValue"],
        remarkDiscountId: json["RemarkDiscountID"],
        buyXAmountGetXDisId: json["BuyXAmountGetXDisID"],
        buyXAmGetXDisRate: json["BuyXAmGetXDisRate"],
        buyXAmGetXDisValue: json["BuyXAmGetXDisValue"],
        cardMemberDiscountRate: json["CardMemberDiscountRate"],
        cardMemberDiscountValue: json["CardMemberDiscountValue"],
        buyXAmGetXDisType: json["BuyXAmGetXDisType"],
        taxGroupId: json["TaxGroupID"],
        grandTotalCurrencies: json["GrandTotalCurrencies"],
        changeCurrencies: json["ChangeCurrencies"],
        grandTotalCurrenciesDisplay: json["GrandTotalCurrenciesDisplay"],
        grandTotalOtherCurrenciesDisplay:
            json["GrandTotalOtherCurrenciesDisplay"],
        grandTotalOtherCurrencies: json["GrandTotalOtherCurrencies"],
        changeCurrenciesDisplay: json["ChangeCurrenciesDisplay"],
        displayPayOtherCurrency: json["DisplayPayOtherCurrency"],
        paymentType: json["PaymentType"],
        selected: json["Selected"],
      );

  Map<String, dynamic> toJson() => {
        "OrderID": orderId,
        "PostingDate": postingDate.toIso8601String(),
        "OrderNo": orderNo,
        "CustomerCode": customerCode,
        "CustomerName": customerName,
        "TableID": tableId,
        "ReceiptNo": receiptNo,
        "QueueNo": queueNo,
        "DateIn": dateIn.toIso8601String(),
        "TimeIn": timeIn,
        "DateOut": dateOut.toIso8601String(),
        "TimeOut": timeOut,
        "MultiPaymentMeans": multiPaymentMeans,
        "WaiterID": waiterId,
        "UserOrderID": userOrderId,
        "UserDiscountID": userDiscountId,
        "CustomerID": customerId,
        "Customer": customer,
        "CustomerCount": customerCount,
        "PriceListID": priceListId,
        "LocalCurrencyID": localCurrencyId,
        "SysCurrencyID": sysCurrencyId,
        "ExchangeRate": exchangeRate,
        "WarehouseID": warehouseId,
        "BranchID": branchId,
        "CompanyID": companyId,
        "Sub_Total": subTotal,
        "DiscountRate": discountRate,
        "DiscountValue": discountValue,
        "TypeDis": typeDis,
        "TaxRate": taxRate,
        "TaxValue": taxValue,
        "OtherPaymentGrandTotal": otherPaymentGrandTotal,
        "GrandTotal": grandTotal,
        "GrandTotal_Sys": grandTotalSys,
        "AppliedAmount": appliedAmount,
        "Tip": tip,
        "Received": received,
        "Change": change,
        "CurrencyDisplay": currencyDisplay,
        "DisplayRate": displayRate,
        "GrandTotal_Display": grandTotalDisplay,
        "Change_Display": changeDisplay,
        "PaymentMeansID": paymentMeansId,
        "CheckBill": checkBill,
        "Cancel": cancel,
        "Delete": delete,
        "PLCurrencyID": plCurrencyId,
        "PLRate": plRate,
        "LocalSetRate": localSetRate,
        "SeriesID": seriesId,
        "SeriesDID": seriesDid,
        "OrderDetail": orderDetail,
        "SerialNumbers": serialNumbers,
        "BatchNos": batchNos,
        "Currency": currency,
        "Remark": remark,
        "Reason": reason,
        "Male": male,
        "Female": female,
        "Children": children,
        "Status": status,
        "Freights": freights,
        "FreightAmount": freightAmount,
        "TitleNote": titleNote,
        "VehicleID": vehicleId,
        "TaxOption": taxOption,
        "PromoCodeID": promoCodeId,
        "PromoCodeDiscRate": promoCodeDiscRate,
        "PromoCodeDiscValue": promoCodeDiscValue,
        "RemarkDiscountID": remarkDiscountId,
        "BuyXAmountGetXDisID": buyXAmountGetXDisId,
        "BuyXAmGetXDisRate": buyXAmGetXDisRate,
        "BuyXAmGetXDisValue": buyXAmGetXDisValue,
        "CardMemberDiscountRate": cardMemberDiscountRate,
        "CardMemberDiscountValue": cardMemberDiscountValue,
        "BuyXAmGetXDisType": buyXAmGetXDisType,
        "TaxGroupID": taxGroupId,
        "GrandTotalCurrencies": grandTotalCurrencies,
        "ChangeCurrencies": changeCurrencies,
        "GrandTotalCurrenciesDisplay": grandTotalCurrenciesDisplay,
        "GrandTotalOtherCurrenciesDisplay": grandTotalOtherCurrenciesDisplay,
        "GrandTotalOtherCurrencies": grandTotalOtherCurrencies,
        "ChangeCurrenciesDisplay": changeCurrenciesDisplay,
        "DisplayPayOtherCurrency": displayPayOtherCurrency,
        "PaymentType": paymentType,
        "Selected": selected,
      };
}
