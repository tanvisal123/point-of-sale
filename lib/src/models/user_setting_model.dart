// To parse this JSON data, do
//
//     final userSettingModel = userSettingModelFromJson(jsonString);

import 'dart:convert';

UserSettingModel userSettingModelFromJson(String str) =>
    UserSettingModel.fromJson(json.decode(str));

String userSettingModelToJson(UserSettingModel data) =>
    json.encode(data.toJson());

class UserSettingModel {
  UserSettingModel({
    this.setting,
    this.customers,
    this.priceLists,
    this.warehouses,
    this.paymentMeans,
    this.systemTypes,
    this.redirectUrl,
    this.printerNames,
    this.series,
    this.seriesPs,
    this.taxGroups,
    this.taxes,
    this.queueGroups,
    this.receiptTemplateGroups,
  });

  Setting setting;
  List<PaymentMeant> customers;
  List<PaymentMeant> priceLists;
  List<PaymentMeant> warehouses;
  List<PaymentMeant> paymentMeans;
  dynamic systemTypes;
  String redirectUrl;
  List<PaymentMeant> printerNames;
  List<PaymentMeant> series;
  List<SeriesP> seriesPs;
  List<PaymentMeant> taxGroups;
  List<PaymentMeant> taxes;
  List<PaymentMeant> queueGroups;
  List<PaymentMeant> receiptTemplateGroups;

  factory UserSettingModel.fromJson(Map<String, dynamic> json) =>
      UserSettingModel(
        setting: Setting.fromJson(json["Setting"]),
        customers: List<PaymentMeant>.from(
            json["Customers"].map((x) => PaymentMeant.fromJson(x))),
        priceLists: List<PaymentMeant>.from(
            json["PriceLists"].map((x) => PaymentMeant.fromJson(x))),
        warehouses: List<PaymentMeant>.from(
            json["Warehouses"].map((x) => PaymentMeant.fromJson(x))),
        paymentMeans: List<PaymentMeant>.from(
            json["PaymentMeans"].map((x) => PaymentMeant.fromJson(x))),
        systemTypes: json["SystemTypes"],
        redirectUrl: json["RedirectUrl"],
        printerNames: List<PaymentMeant>.from(
            json["PrinterNames"].map((x) => PaymentMeant.fromJson(x))),
        series: List<PaymentMeant>.from(
            json["Series"].map((x) => PaymentMeant.fromJson(x))),
        seriesPs: List<SeriesP>.from(
            json["SeriesPS"].map((x) => SeriesP.fromJson(x))),
        taxGroups: List<PaymentMeant>.from(
            json["TaxGroups"].map((x) => PaymentMeant.fromJson(x))),
        taxes: List<PaymentMeant>.from(
            json["Taxes"].map((x) => PaymentMeant.fromJson(x))),
        queueGroups: List<PaymentMeant>.from(
            json["QueueGroups"].map((x) => PaymentMeant.fromJson(x))),
        receiptTemplateGroups: List<PaymentMeant>.from(
            json["ReceiptTemplateGroups"].map((x) => PaymentMeant.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Setting": setting.toJson(),
        "Customers": List<dynamic>.from(customers.map((x) => x.toJson())),
        "PriceLists": List<dynamic>.from(priceLists.map((x) => x.toJson())),
        "Warehouses": List<dynamic>.from(warehouses.map((x) => x.toJson())),
        "PaymentMeans": List<dynamic>.from(paymentMeans.map((x) => x.toJson())),
        "SystemTypes": systemTypes,
        "RedirectUrl": redirectUrl,
        "PrinterNames": List<dynamic>.from(printerNames.map((x) => x.toJson())),
        "Series": List<dynamic>.from(series.map((x) => x.toJson())),
        "SeriesPS": List<dynamic>.from(seriesPs.map((x) => x.toJson())),
        "TaxGroups": List<dynamic>.from(taxGroups.map((x) => x.toJson())),
        "Taxes": List<dynamic>.from(taxes.map((x) => x.toJson())),
        "QueueGroups": List<dynamic>.from(queueGroups.map((x) => x.toJson())),
        "ReceiptTemplateGroups":
            List<dynamic>.from(receiptTemplateGroups.map((x) => x.toJson())),
      };
}

class PaymentMeant {
  PaymentMeant({
    this.disabled,
    this.group,
    this.selected,
    this.text,
    this.value,
  });

  bool disabled;
  dynamic group;
  bool selected;
  String text;
  String value;

  factory PaymentMeant.fromJson(Map<String, dynamic> json) => PaymentMeant(
        disabled: json["Disabled"],
        group: json["Group"],
        selected: json["Selected"],
        text: json["Text"],
        value: json["Value"],
      );

  Map<String, dynamic> toJson() => {
        "Disabled": disabled,
        "Group": group,
        "Selected": selected,
        "Text": text,
        "Value": value,
      };
}

class SeriesP {
  SeriesP({
    this.id,
    this.name,
    this.seriesPDefault,
    this.nextNo,
    this.documentTypeId,
    this.seriesDetailId,
  });

  int id;
  String name;
  bool seriesPDefault;
  String nextNo;
  int documentTypeId;
  int seriesDetailId;

  factory SeriesP.fromJson(Map<String, dynamic> json) => SeriesP(
        id: json["ID"],
        name: json["Name"],
        seriesPDefault: json["Default"],
        nextNo: json["NextNo"],
        documentTypeId: json["DocumentTypeID"],
        seriesDetailId: json["SeriesDetailID"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Name": name,
        "Default": seriesPDefault,
        "NextNo": nextNo,
        "DocumentTypeID": documentTypeId,
        "SeriesDetailID": seriesDetailId,
      };
}

class Setting {
  Setting({
    this.id,
    this.branchId,
    this.receiptsize,
    this.receiptTemplate,
    this.daulScreen,
    this.printReceiptOrder,
    this.printReceiptTender,
    this.printCountReceipt,
    this.printCountBill,
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
    this.userId,
    this.itemViewType,
    this.itemPageSize,
    this.seriesId,
    this.isOrderByQr,
    this.panelViewMode,
    this.printReceiptOption,
    this.printerOrder,
    this.printOrderCount,
    this.printLabelName,
    this.printBillName,
    this.queueOption,
    this.taxOption,
    this.tax,
    this.enablePromoCode,
    this.isCusPriceList,
    this.sortBy,
  });

  int id;
  int branchId;
  String receiptsize;
  String receiptTemplate;
  bool daulScreen;
  bool printReceiptOrder;
  bool printReceiptTender;
  int printCountReceipt;
  int printCountBill;
  int queueCount;
  int sysCurrencyId;
  int localCurrencyId;
  double rateIn;
  double rateOut;
  String printer;
  int paymentMeansId;
  int companyId;
  int warehouseId;
  int customerId;
  int priceListId;
  bool vatAble;
  String vatNum;
  dynamic wifi;
  dynamic macAddress;
  bool autoQueue;
  bool printLabel;
  int closeShift;
  int userId;
  int itemViewType;
  int itemPageSize;
  int seriesId;
  bool isOrderByQr;
  int panelViewMode;
  int printReceiptOption;
  String printerOrder;
  int printOrderCount;
  String printLabelName;
  String printBillName;
  int queueOption;
  int taxOption;
  int tax;
  bool enablePromoCode;
  bool isCusPriceList;
  SortBy sortBy;

  factory Setting.fromJson(Map<String, dynamic> json) => Setting(
        id: json["ID"],
        branchId: json["BranchID"],
        receiptsize: json["Receiptsize"],
        receiptTemplate: json["ReceiptTemplate"],
        daulScreen: json["DaulScreen"],
        printReceiptOrder: json["PrintReceiptOrder"],
        printReceiptTender: json["PrintReceiptTender"],
        printCountReceipt: json["PrintCountReceipt"],
        printCountBill: json["PrintCountBill"],
        queueCount: json["QueueCount"],
        sysCurrencyId: json["SysCurrencyID"],
        localCurrencyId: json["LocalCurrencyID"],
        rateIn: json["RateIn"],
        rateOut: json["RateOut"],
        printer: json["Printer"],
        paymentMeansId: json["PaymentMeansID"],
        companyId: json["CompanyID"],
        warehouseId: json["WarehouseID"],
        customerId: json["CustomerID"],
        priceListId: json["PriceListID"],
        vatAble: json["VatAble"],
        vatNum: json["VatNum"],
        wifi: json["Wifi"],
        macAddress: json["MacAddress"],
        autoQueue: json["AutoQueue"],
        printLabel: json["PrintLabel"],
        closeShift: json["CloseShift"],
        userId: json["UserID"],
        itemViewType: json["ItemViewType"],
        itemPageSize: json["ItemPageSize"],
        seriesId: json["SeriesID"],
        isOrderByQr: json["IsOrderByQR"],
        panelViewMode: json["PanelViewMode"],
        printReceiptOption: json["PrintReceiptOption"],
        printerOrder: json["PrinterOrder"],
        printOrderCount: json["PrintOrderCount"],
        printLabelName: json["PrintLabelName"],
        printBillName: json["PrintBillName"],
        queueOption: json["QueueOption"],
        taxOption: json["TaxOption"],
        tax: json["Tax"],
        enablePromoCode: json["EnablePromoCode"],
        isCusPriceList: json["IsCusPriceList"],
        sortBy: SortBy.fromJson(json["SortBy"]),
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "BranchID": branchId,
        "Receiptsize": receiptsize,
        "ReceiptTemplate": receiptTemplate,
        "DaulScreen": daulScreen,
        "PrintReceiptOrder": printReceiptOrder,
        "PrintReceiptTender": printReceiptTender,
        "PrintCountReceipt": printCountReceipt,
        "PrintCountBill": printCountBill,
        "QueueCount": queueCount,
        "SysCurrencyID": sysCurrencyId,
        "LocalCurrencyID": localCurrencyId,
        "RateIn": rateIn,
        "RateOut": rateOut,
        "Printer": printer,
        "PaymentMeansID": paymentMeansId,
        "CompanyID": companyId,
        "WarehouseID": warehouseId,
        "CustomerID": customerId,
        "PriceListID": priceListId,
        "VatAble": vatAble,
        "VatNum": vatNum,
        "Wifi": wifi,
        "MacAddress": macAddress,
        "AutoQueue": autoQueue,
        "PrintLabel": printLabel,
        "CloseShift": closeShift,
        "UserID": userId,
        "ItemViewType": itemViewType,
        "ItemPageSize": itemPageSize,
        "SeriesID": seriesId,
        "IsOrderByQR": isOrderByQr,
        "PanelViewMode": panelViewMode,
        "PrintReceiptOption": printReceiptOption,
        "PrinterOrder": printerOrder,
        "PrintOrderCount": printOrderCount,
        "PrintLabelName": printLabelName,
        "PrintBillName": printBillName,
        "QueueOption": queueOption,
        "TaxOption": taxOption,
        "Tax": tax,
        "EnablePromoCode": enablePromoCode,
        "IsCusPriceList": isCusPriceList,
        "SortBy": sortBy.toJson(),
      };
}

class SortBy {
  SortBy({
    this.field,
    this.desc,
  });

  String field;
  bool desc;

  factory SortBy.fromJson(Map<String, dynamic> json) => SortBy(
        field: json["Field"],
        desc: json["Desc"],
      );

  Map<String, dynamic> toJson() => {
        "Field": field,
        "Desc": desc,
      };
}
