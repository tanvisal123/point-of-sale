import 'dart:convert';

List<SettingModel> settingModelFromJson(String str) => List<SettingModel>.from(
    json.decode(str).map((x) => SettingModel.fromJson(x)));

String settingModelToJson(List<SettingModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SettingModel {
  SettingModel({
    this.id,
    this.branchId,
    this.receiptSize,
    this.receiptTemplate,
    this.printReceiptOrder,
    this.printReceiptTender,
    this.printCountReceipt,
    this.queueCount,
    this.sysCurrencyId,
    this.localCurrencyId,
    this.rateIn,
    this.rateOut,
    this.printer,
    this.paymentMeansId,
    this.companyId,
    this.warehouseId,
    this.customerId,
    this.priceListId,
    this.vatAble,
    this.vatNum,
    this.wifi,
    this.macAddress,
    this.autoQueue,
    this.printLabel,
    this.closeShift,
  });

  int id;
  int branchId;
  String receiptSize;
  String receiptTemplate;
  dynamic printReceiptOrder;
  dynamic printReceiptTender;
  dynamic printCountReceipt;
  dynamic queueCount;
  int sysCurrencyId;
  int localCurrencyId;
  double rateIn;
  double rateOut;
  dynamic printer;
  int paymentMeansId;
  int companyId;
  int warehouseId;
  int customerId;
  int priceListId;
  dynamic vatAble;
  dynamic vatNum;
  String wifi;
  dynamic macAddress;
  dynamic autoQueue;
  dynamic printLabel;
  dynamic closeShift;

  factory SettingModel.fromJson(Map<String, dynamic> json) => SettingModel(
        id: json["id"],
        branchId: json["branchId"],
        receiptSize: json["receiptSize"],
        receiptTemplate: json["receiptTemplate"],
        printReceiptOrder: json["printReceiptOrder"],
        printReceiptTender: json["printReceiptTender"],
        printCountReceipt: json["printCountReceipt"],
        queueCount: json["queueCount"],
        sysCurrencyId: json["sysCurrencyId"],
        localCurrencyId: json["localCurrencyId"],
        rateIn: json["rateIn"],
        rateOut: json["rateOut"],
        printer: json["printer"],
        paymentMeansId: json["paymentMeansId"],
        companyId: json["companyId"],
        warehouseId: json["warehouseId"],
        customerId: json["customerId"],
        priceListId: json["priceListId"],
        vatAble: json["vatAble"],
        vatNum: json["vatNum"],
        wifi: json["wifi"],
        macAddress: json["macAddress"],
        autoQueue: json["autoQueue"],
        printLabel: json["printLabel"],
        closeShift: json["closeShift"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "branchId": branchId,
        "receiptSize": receiptSize,
        "receiptTemplate": receiptTemplate,
        "printReceiptOrder": printReceiptOrder,
        "printReceiptTender": printReceiptTender,
        "printCountReceipt": printCountReceipt,
        "queueCount": queueCount,
        "sysCurrencyId": sysCurrencyId,
        "localCurrencyId": localCurrencyId,
        "rateIn": rateIn,
        "rateOut": rateOut,
        "printer": printer,
        "paymentMeansId": paymentMeansId,
        "companyId": companyId,
        "warehouseId": warehouseId,
        "customerId": customerId,
        "priceListId": priceListId,
        "vatAble": vatAble,
        "vatNum": vatNum,
        "wifi": wifi,
        "macAddress": macAddress,
        "autoQueue": autoQueue,
        "printLabel": printLabel,
        "closeShift": closeShift,
      };
}
