import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:point_of_sale/src/models/currency_model.dart';
import 'package:point_of_sale/src/models/customer_model.dart';

FetchOrderModel fetchOrderModelFromJson(String str) =>
    FetchOrderModel.fromJson(json.decode(str));

String fetchOrderModelToJson(FetchOrderModel data) =>
    json.encode(data.toJson());

List<SaleItems> saleItemFromJson(String str) =>
    List<SaleItems>.from(json.decode(str).map((x) => SaleItems.fromJson(x)));

List<Order> orderFromJson(String str) =>
    List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

List<BaseItemGroup> baseItemGroupFromJson(String str) =>
    List<BaseItemGroup>.from(
        json.decode(str).map((x) => BaseItemGroup.fromJson(x)));

class FetchOrderModel {
  final int authOption;
  final int cardMemberOption;
  Order order;
  final List<BaseItemGroup> bItemGroups;
  List<SaleItems> saleItems;
  List<DisplayPayOtherCurrency> displayCurrency;
  final OrderTable orderTable;
  final List<Order> orders;
  final Setting setting;
  final List<TaxGroup> taxGroup;
  final LoyaltyProgram loyaltyProgram;
  final List<Freight> freights;
  final List<ItemGroups> itemGroup;
  final List<PaymentMean> paymentMeans;
  FetchOrderModel({
    this.authOption,
    this.cardMemberOption,
    this.order,
    this.bItemGroups,
    this.saleItems,
    this.displayCurrency,
    this.orderTable,
    this.orders,
    this.setting,
    this.taxGroup,
    this.loyaltyProgram,
    this.freights,
    this.itemGroup,
    this.paymentMeans,
  });
  factory FetchOrderModel.fromJson(Map<String, dynamic> json) =>
      FetchOrderModel(
        authOption: json["AuthOption"],
        cardMemberOption: json["CardMemberOption"],
        order: Order.fromJson(json["Order"]),
        bItemGroups: List<BaseItemGroup>.from(
            json['BaseItemGroups'].map((x) => BaseItemGroup.fromJson(x))),
        saleItems: List<SaleItems>.from(
            json['SaleItems'].map((x) => SaleItems.fromJson(x))),
        displayCurrency: List<DisplayPayOtherCurrency>.from(
            json["DisplayPayOtherCurrency"]
                .map((x) => DisplayPayOtherCurrency.fromJson(x))),
        orderTable: OrderTable.fromJson(json["OrderTable"]),
        orders: List<Order>.from(json["Orders"].map((x) => Order.fromJson(x))),
        setting: Setting.fromJson(json["Setting"]),
        taxGroup: List<TaxGroup>.from(
            json['TaxGroups'].map((x) => TaxGroup.fromJson(x))),
        loyaltyProgram: LoyaltyProgram.fromJson(json["LoyaltyProgram"]),
        freights: List<Freight>.from(
            json["Freights"].map((x) => Freight.fromJson(x))),
        itemGroup: List<ItemGroups>.from(
            json['ItemGroups'].map((x) => ItemGroups.fromJson(x))),
        paymentMeans: List<PaymentMean>.from(
            json['PaymentMeans'].map((x) => PaymentMean.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'AuthOption': authOption,
        'CardMemberOption': cardMemberOption,
        'Order': order.toJson(),
        'BaseItemGroups': List<BaseItemGroup>.from(
          bItemGroups.map((e) => e.toJson()),
        ),
        'SaleItems': List<SaleItems>.from(
          saleItems.map((e) => e.toJson()),
        ),
        "DisplayPayOtherCurrency": List<DisplayPayOtherCurrency>.from(
          displayCurrency.map((x) => x.toJson()),
        ),
        "OrderTable": orderTable.toJson(),
        "Orders": List<Order>.from(orders.map((e) => e.toJson())),
        "Setting": setting.toJson(),
        "TaxGroups": List<TaxGroup>.from(taxGroup.map((e) => e.toJson())),
        "LoyaltyProgram": loyaltyProgram.toJson(),
        "Freights": List<dynamic>.from(freights.map((x) => x.toJson())),
        "ItemGroups": List<dynamic>.from(itemGroup.map((x) => x.toJson())),
        "PaymentMeans": List<dynamic>.from(paymentMeans.map((e) => e.toJson())),
      };
}

class TaxGroup {
  TaxGroup({
    this.id,
    this.name,
    this.rate,
  });

  final int id;
  final String name;
  final double rate;

  factory TaxGroup.fromJson(Map<String, dynamic> json) => TaxGroup(
        id: json["ID"],
        name: json["Name"],
        rate: json["Rate"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Name": name,
        "Rate": rate,
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
    this.enableCountMember,
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
  String wifi;
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
  dynamic printLabelName;
  String printBillName;
  int queueOption;
  int taxOption;
  int tax;
  bool enablePromoCode;
  bool isCusPriceList;
  bool enableCountMember;
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
        enableCountMember: json["EnableCountMember"],
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
        "EnableCountMember": enableCountMember,
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

class BaseItemGroup {
  int id;
  int itemId;
  String code;
  int group1;
  int group2;
  int group3;
  int level;
  String khmerName;
  String englishName;
  double qty;
  double printQty;
  double cost;
  double unitPrice;
  double discountRate;
  double discountValue;
  double vat;
  int currencyId;
  String currency;
  int uomId;
  String barcode;
  int pricListId;
  int groupUomId;
  String description;
  bool isAddon;
  double inStock;
  bool isScale;
  int taxGroupSaleId;
  String image;
  BaseItemGroup({
    this.id,
    this.itemId,
    this.code,
    this.group1,
    this.group2,
    this.group3,
    this.level,
    this.khmerName,
    this.englishName,
    this.qty,
    this.printQty,
    this.cost,
    this.unitPrice,
    this.discountRate,
    this.discountValue,
    this.vat,
    this.currencyId,
    this.currency,
    this.uomId,
    this.barcode,
    this.pricListId,
    this.groupUomId,
    this.description,
    this.isAddon,
    this.inStock,
    this.isScale,
    this.taxGroupSaleId,
    this.image,
  });
  factory BaseItemGroup.fromJson(Map<String, dynamic> json) => BaseItemGroup(
        id: json["ID"],
        itemId: json["ItemID"],
        code: json["Code"] ?? "",
        group1: json["Group1"],
        group2: json["Group2"],
        group3: json["Group3"],
        level: json["Level"],
        khmerName: json["KhmerName"],
        englishName: json["EnglishName"] == null ? null : json['EnglishName'],
        qty: json["Qty"],
        printQty: json["PrintQty"],
        cost: json["Cost"].toDouble(),
        unitPrice: json["UnitPrice"].toDouble(),
        discountRate: json["DiscountRate"],
        discountValue: json["DiscountValue"],
        vat: json["VAT"],
        currencyId: json["CurrencyID"],
        currency: json["Currency"] ?? " ",
        uomId: json["UomID"],
        barcode: json["Barcode"] ?? "",
        pricListId: json["PricListID"],
        groupUomId: json["GroupUomID"],
        description: json["Description"] ?? "",
        isAddon: json["IsAddon"],
        inStock: json["InStock"],
        isScale: json["IsScale"],
        taxGroupSaleId: json["TaxGroupSaleID"],
        image: json["Image"],
      );
  Map<String, dynamic> toJson() => {
        "ID": id,
        "ItemID": itemId,
        "Code": code == null ? null : code,
        "Group1": group1,
        "Group2": group2,
        "Group3": group3,
        "Level": level,
        "KhmerName": khmerName,
        "EnglishName": englishName == null ? null : englishName,
        "Qty": qty,
        "PrintQty": printQty,
        "Cost": cost,
        "UnitPrice": unitPrice,
        "DiscountRate": discountRate,
        "DiscountValue": discountValue,
        "VAT": vat,
        "CurrencyID": currencyId,
        "Currency": currency == null ? null : currency,
        "UomID": uomId,
        "Barcode": barcode == null ? null : barcode,
        "PricListID": pricListId,
        "GroupUomID": groupUomId,
        "Description": description == null ? null : description,
        "IsAddon": isAddon,
        "InStock": inStock,
        "IsScale": isScale,
        "TaxGroupSaleID": taxGroupSaleId,
        "Image": image
      };
}

// To parse this JSON data, do
//
//     final itemGroups = itemGroupsFromJson(jsonString);

class ItemGroups {
  ItemGroups({
    this.id,
    this.itemId,
    this.code,
    this.group1,
    this.group2,
    this.group3,
    this.khmerName,
    this.englishName,
    this.qty,
    this.printQty,
    this.cost,
    this.unitPrice,
    this.discountRate,
    this.discountValue,
    this.typeDis,
    this.vat,
    this.currencyId,
    this.currency,
    this.uomId,
    this.uoM,
    this.barcode,
    this.process,
    this.image,
    this.pricListId,
    this.groupUomId,
    this.printTo,
    this.itemType,
    this.description,
    this.isAddon,
    this.inStock,
    this.isScale,
    this.taxGroupSaleId,
    this.addictionProps,
    this.uomLists,
    this.uomChangeLists,
    this.level,
  });

  final int id;
  final int itemId;
  final dynamic code;
  final int group1;
  final int group2;
  final int group3;
  final String khmerName;
  final dynamic englishName;
  final double qty;
  final double printQty;
  final double cost;
  final double unitPrice;
  final double discountRate;
  final double discountValue;
  final dynamic typeDis;
  final double vat;
  final int currencyId;
  final dynamic currency;
  final int uomId;
  final dynamic uoM;
  final dynamic barcode;
  final dynamic process;
  final dynamic image;
  final int pricListId;
  final int groupUomId;
  final dynamic printTo;
  final dynamic itemType;
  final dynamic description;
  final bool isAddon;
  final double inStock;
  final bool isScale;
  final int taxGroupSaleId;
  final dynamic addictionProps;
  final dynamic uomLists;
  final dynamic uomChangeLists;
  final int level;

  factory ItemGroups.fromJson(Map<String, dynamic> json) => ItemGroups(
        id: json["ID"],
        itemId: json["ItemID"],
        code: json["Code"],
        group1: json["Group1"],
        group2: json["Group2"],
        group3: json["Group3"],
        khmerName: json["KhmerName"],
        englishName: json["EnglishName"],
        qty: json["Qty"],
        printQty: json["PrintQty"],
        cost: json["Cost"],
        unitPrice: json["UnitPrice"],
        discountRate: json["DiscountRate"],
        discountValue: json["DiscountValue"],
        typeDis: json["TypeDis"],
        vat: json["VAT"],
        currencyId: json["CurrencyID"],
        currency: json["Currency"],
        uomId: json["UomID"],
        uoM: json["UoM"],
        barcode: json["Barcode"],
        process: json["Process"],
        image: json["Image"],
        pricListId: json["PricListID"],
        groupUomId: json["GroupUomID"],
        printTo: json["PrintTo"],
        itemType: json["ItemType"],
        description: json["Description"],
        isAddon: json["IsAddon"],
        inStock: json["InStock"],
        isScale: json["IsScale"],
        taxGroupSaleId: json["TaxGroupSaleID"],
        addictionProps: json["AddictionProps"],
        uomLists: json["UomLists"],
        uomChangeLists: json["UomChangeLists"],
        level: json["Level"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "ItemID": itemId,
        "Code": code,
        "Group1": group1,
        "Group2": group2,
        "Group3": group3,
        "KhmerName": khmerName,
        "EnglishName": englishName,
        "Qty": qty,
        "PrintQty": printQty,
        "Cost": cost,
        "UnitPrice": unitPrice,
        "DiscountRate": discountRate,
        "DiscountValue": discountValue,
        "TypeDis": typeDis,
        "VAT": vat,
        "CurrencyID": currencyId,
        "Currency": currency,
        "UomID": uomId,
        "UoM": uoM,
        "Barcode": barcode,
        "Process": process,
        "Image": image,
        "PricListID": pricListId,
        "GroupUomID": groupUomId,
        "PrintTo": printTo,
        "ItemType": itemType,
        "Description": description,
        "IsAddon": isAddon,
        "InStock": inStock,
        "IsScale": isScale,
        "TaxGroupSaleID": taxGroupSaleId,
        "AddictionProps": addictionProps,
        "UomLists": uomLists,
        "UomChangeLists": uomChangeLists,
        "Level": level,
      };
}

class SaleItems {
  SaleItems({
    this.id,
    this.itemId,
    this.code,
    this.group1,
    this.group2,
    this.group3,
    this.level,
    this.khmerName,
    this.englishName,
    this.qty,
    this.printQty,
    this.cost,
    this.unitPrice,
    this.discountRate,
    this.discountValue,
    this.typeDis,
    this.vat,
    this.currencyId,
    this.currency,
    this.uomId,
    this.uoM,
    this.barcode,
    this.process,
    this.image,
    this.pricListId,
    this.groupUomId,
    this.printTo,
    this.itemType,
    this.description,
    this.isAddon,
    this.inStock,
    this.isScale,
    this.taxGroupSaleId,
  });

  int id;
  int itemId;
  String code;
  int group1;
  int group2;
  int group3;
  int level;
  String khmerName;
  String englishName;
  double qty;
  double printQty;
  double cost;
  double unitPrice;
  double discountRate;
  double discountValue;
  String typeDis;
  double vat;
  int currencyId;
  String currency;
  int uomId;
  String uoM;
  String barcode;
  String process;
  String image;
  int pricListId;
  int groupUomId;
  String printTo;
  String itemType;
  String description;
  bool isAddon;
  double inStock;
  bool isScale;
  int taxGroupSaleId;

  factory SaleItems.fromJson(Map<String, dynamic> json) => SaleItems(
        id: json["ID"],
        itemId: json["ItemID"],
        code: json["Code"] == null ? null : json["Code"],
        group1: json["Group1"],
        group2: json["Group2"],
        group3: json["Group3"],
        level: json["Level"],
        khmerName: json["KhmerName"],
        englishName: json["EnglishName"] == null ? null : json["EnglishName"],
        qty: json["Qty"],
        printQty: json["PrintQty"],
        cost: json["Cost"],
        unitPrice: json["UnitPrice"],
        discountRate: json["DiscountRate"],
        discountValue: json["DiscountValue"],
        typeDis: json["TypeDis"] == null ? null : json["TypeDis"],
        vat: json["VAT"],
        currencyId: json["CurrencyID"],
        currency: json["Currency"] == null ? null : json["Currency"],
        uomId: json["UomID"],
        uoM: json["UoM"] == null ? null : json["UoM"],
        barcode: json["Barcode"] == null ? null : json["Barcode"],
        process: json["Process"] == null ? null : json["Process"],
        image: json["Image"] == null ? null : json["Image"],
        pricListId: json["PricListID"],
        groupUomId: json["GroupUomID"],
        printTo: json["PrintTo"] == null ? null : json["PrintTo"],
        itemType: json["ItemType"] == null ? null : json["ItemType"],
        description: json["Description"] == null ? null : json["Description"],
        isAddon: json["IsAddon"],
        inStock: json["InStock"],
        isScale: json["IsScale"],
        taxGroupSaleId: json["TaxGroupSaleID"],
      );
  Map<String, dynamic> toJson() => {
        "ID": id,
        "ItemID": itemId,
        "Code": code == null ? null : code,
        "Group1": group1,
        "Group2": group2,
        "Group3": group3,
        "Level": level,
        "KhmerName": khmerName,
        "EnglishName": englishName == null ? null : englishName,
        "Qty": qty,
        "PrintQty": printQty,
        "Cost": cost,
        "UnitPrice": unitPrice,
        "DiscountRate": discountRate,
        "DiscountValue": discountValue,
        "TypeDis": typeDis == null ? null : typeDis,
        "VAT": vat,
        "CurrencyID": currencyId,
        "Currency": currency == null ? null : currency,
        "UomID": uomId,
        "UoM": uoM == null ? null : uoM,
        "Barcode": barcode == null ? null : barcode,
        "Process": process == null ? null : process,
        "Image": image == null ? null : image,
        "PricListID": pricListId,
        "GroupUomID": groupUomId,
        "PrintTo": printTo == null ? null : printTo,
        "ItemType": itemType == null ? null : itemType,
        "Description": description == null ? null : description,
        "IsAddon": isAddon,
        "InStock": inStock,
        "IsScale": isScale,
        "TaxGroupSaleID": taxGroupSaleId,
      };
}

class OrderTable {
  OrderTable({
    this.id,
    this.name,
    this.groupTableId,
    this.image,
    this.priceListId,
    this.isTablePriceList,
    this.status,
    this.time,
    this.delete,
    this.groupTable,
  });

  int id;
  String name;
  int groupTableId;
  String image;
  int priceListId;
  bool isTablePriceList;
  String status;
  String time;
  bool delete;
  dynamic groupTable;

  factory OrderTable.fromJson(Map<String, dynamic> json) => OrderTable(
        id: json["ID"],
        name: json["Name"],
        groupTableId: json["GroupTableID"],
        image: json["Image"],
        priceListId: json["PriceListID"],
        isTablePriceList: json["IsTablePriceList"],
        status: json["Status"],
        time: json["Time"],
        delete: json["Delete"],
        groupTable: json["GroupTable"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Name": name,
        "GroupTableID": groupTableId,
        "Image": image,
        "PriceListID": priceListId,
        "IsTablePriceList": isTablePriceList,
        "Status": status,
        "Time": time,
        "Delete": delete,
        "GroupTable": groupTable,
      };
}

class Order {
  int orderId;
  DateTime postingDate;
  String orderNo;
  int tableId;
  String receiptNo;
  String queueNo;
  DateTime dateIn;
  DateTime dateOut;
  String timeIn;
  String timeOut;
  int waiterId;
  int userOrderId;
  int userDiscountId;
  int customerId;
  Customer customer;
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
  List<OrderDetailModel> orderDetail;
  String remark;
  String reason;
  int status;
  List<dynamic> freights;
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
  List<dynamic> grandTotalCurrencies;
  List<dynamic> changeCurrencies;
  String grandTotalCurrenciesDisplay; //
  String grandTotalOtherCurrenciesDisplay;
  List<dynamic> grandTotalOtherCurrencies; //
  String changeCurrenciesDisplay; //
  List<dynamic> displayPayOtherCurrency;
  int paymentType;
  CurrencyModel currency;

  Order({
    this.currency,
    this.orderId,
    this.postingDate,
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
    this.remark,
    this.reason,
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
  });

  factory Order.copy(Order obj) => Order(
        currency: obj.currency,
        orderId: obj.orderId,
        orderNo: obj.orderNo,
        tableId: obj.tableId,
        receiptNo: obj.receiptNo,
        queueNo: obj.queueNo,
        dateIn: obj.dateIn,
        dateOut: obj.dateOut,
        timeIn: obj.timeIn,
        timeOut: obj.timeOut,
        waiterId: obj.waiterId,
        userOrderId: obj.userOrderId,
        userDiscountId: obj.userDiscountId,
        customerId: obj.customerId,
        customer: obj.customer,
        customerCount: obj.customerCount,
        priceListId: obj.priceListId,
        localCurrencyId: obj.localCurrencyId,
        sysCurrencyId: obj.sysCurrencyId,
        exchangeRate: obj.exchangeRate,
        warehouseId: obj.warehouseId,
        branchId: obj.branchId,
        companyId: obj.companyId,
        subTotal: obj.subTotal,
        discountRate: obj.discountRate,
        discountValue: obj.discountValue,
        typeDis: obj.typeDis,
        taxRate: obj.taxRate,
        taxValue: obj.taxValue,
        otherPaymentGrandTotal: obj.otherPaymentGrandTotal,
        grandTotal: obj.grandTotal,
        grandTotalSys: obj.grandTotalSys,
        appliedAmount: obj.appliedAmount,
        tip: obj.tip,
        received: obj.received,
        change: obj.change,
        currencyDisplay: obj.currencyDisplay,
        displayRate: obj.displayRate,
        grandTotalDisplay: obj.grandTotalDisplay,
        changeDisplay: obj.changeDisplay,
        paymentMeansId: obj.paymentMeansId,
        checkBill: obj.checkBill,
        cancel: obj.cancel,
        delete: obj.delete,
        plCurrencyId: obj.plCurrencyId,
        plRate: obj.plRate,
        localSetRate: obj.localSetRate,
        seriesId: obj.seriesId,
        seriesDid: obj.seriesDid,
        orderDetail: obj.orderDetail,
        remark: obj.remark,
        reason: obj.reason,
        status: obj.status,
        freights: obj.freights,
        freightAmount: obj.freightAmount,
        titleNote: obj.titleNote,
        vehicleId: obj.vehicleId,
        taxOption: obj.taxOption,
        promoCodeId: obj.promoCodeId,
        promoCodeDiscRate: obj.promoCodeDiscRate,
        promoCodeDiscValue: obj.promoCodeDiscValue,
        remarkDiscountId: obj.remarkDiscountId,
        buyXAmountGetXDisId: obj.buyXAmountGetXDisId,
        buyXAmGetXDisRate: obj.buyXAmGetXDisRate,
        buyXAmGetXDisValue: obj.buyXAmGetXDisValue,
        cardMemberDiscountRate: obj.cardMemberDiscountRate,
        cardMemberDiscountValue: obj.cardMemberDiscountValue,
        buyXAmGetXDisType: obj.buyXAmGetXDisType,
        taxGroupId: obj.taxGroupId,
        grandTotalCurrencies: obj.grandTotalCurrencies,
        changeCurrencies: obj.changeCurrencies,
        grandTotalCurrenciesDisplay: obj.grandTotalCurrenciesDisplay,
        grandTotalOtherCurrenciesDisplay: obj.grandTotalOtherCurrenciesDisplay,
        grandTotalOtherCurrencies: obj.grandTotalOtherCurrencies,
        changeCurrenciesDisplay: obj.changeCurrenciesDisplay,
        displayPayOtherCurrency: obj.displayPayOtherCurrency,
        paymentType: obj.paymentType,
      );

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        currency: CurrencyModel.fromJson(json["Currency"]),
        orderId: json["OrderID"],
        orderNo: json["OrderNo"],
        tableId: json["TableID"],
        receiptNo: json["ReceiptNo"],
        queueNo: json["QueueNo"],
        dateIn: DateTime.parse(json["DateIn"]),
        dateOut: DateTime.parse(json["DateOut"]),
        timeIn: json["TimeIn"],
        timeOut: json["TimeOut"],
        waiterId: json["WaiterID"],
        userOrderId: json["UserOrderID"],
        userDiscountId: json["UserDiscountID"],
        customerId: json["CustomerID"],
        customer: json["Customer"] == null
            ? null
            : Customer.fromJson(json["Customer"]),
        customerCount: json["CustomerCount"],
        priceListId: json["PriceListID"],
        localCurrencyId: json["LocalCurrencyID"],
        sysCurrencyId: json["SysCurrencyID"],
        exchangeRate: json["ExchangeRate"],
        warehouseId: json["WarehouseID"],
        branchId: json["BranchID"],
        companyId: json["CompanyID"],
        subTotal: json["Sub_Total"].toDouble(),
        discountRate: json["DiscountRate"],
        discountValue: json["DiscountValue"],
        taxRate: json["TaxRate"],
        taxValue: json["TaxValue"],
        otherPaymentGrandTotal: json["OtherPaymentGrandTotal"],
        grandTotal: json["GrandTotal"].toDouble(),
        grandTotalSys: json["GrandTotal_Sys"].toDouble(),
        appliedAmount: json["AppliedAmount"],
        tip: json["Tip"],
        received: json["Received"],
        change: json["Change"].toDouble(),
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
        orderDetail: List<OrderDetailModel>.from(
            json["OrderDetail"].map((x) => OrderDetailModel.fromJson(x))),
        remark: json["Remark"] == null ? null : json["Remark"],
        reason: json["Reason"] == null ? null : json["Reason"],
        status: json["Status"],
        freights: json["Freights"] == null
            ? null
            : List<dynamic>.from(json["Freights"].map((x) => x)),
        freightAmount: json["FreightAmount"],
        titleNote: json["TitleNote"] == null ? null : json["TitleNote"],
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
        grandTotalCurrencies: json["GrandTotalCurrencies"] == null
            ? null
            : List<dynamic>.from(json["GrandTotalCurrencies"].map((x) => x)),
        changeCurrencies: json["ChangeCurrencies"] == null
            ? null
            : List<dynamic>.from(json["ChangeCurrencies"].map((x) => x)),
        grandTotalCurrenciesDisplay: json["GrandTotalCurrenciesDisplay"] == null
            ? null
            : json["GrandTotalCurrenciesDisplay"],
        grandTotalOtherCurrenciesDisplay:
            json["GrandTotalOtherCurrenciesDisplay"] == null
                ? null
                : json["GrandTotalOtherCurrenciesDisplay"],
        grandTotalOtherCurrencies: json["GrandTotalOtherCurrencies"] == null
            ? null
            : List<dynamic>.from(
                json["GrandTotalOtherCurrencies"].map((x) => x)),
        changeCurrenciesDisplay: json["ChangeCurrenciesDisplay"] == null
            ? null
            : json["ChangeCurrenciesDisplay"],
        displayPayOtherCurrency: json["DisplayPayOtherCurrency"] == null
            ? null
            : List<dynamic>.from(json["DisplayPayOtherCurrency"].map((x) => x)),
        paymentType: json["PaymentType"],
      );

  Map<String, dynamic> toJson() => {
        "Currency": currency.toJson(),
        "OrderID": orderId,
        "OrderNo": orderNo,
        "TableID": tableId,
        "ReceiptNo": receiptNo,
        "QueueNo": queueNo,
        "DateIn": dateIn.toIso8601String(),
        "DateOut": dateOut.toIso8601String(),
        "TimeIn": timeIn,
        "TimeOut": timeOut,
        "WaiterID": waiterId,
        "UserOrderID": userOrderId,
        "UserDiscountID": userDiscountId,
        "CustomerID": customerId,
        "Customer": customer == null ? null : customer.toJson(),
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
        "OrderDetail": List<dynamic>.from(orderDetail.map((x) => x.toJson())),
        "Remark": remark == null ? null : remark,
        "Reason": reason == null ? null : reason,
        "Status": status,
        "Freights": freights == null
            ? null
            : List<dynamic>.from(freights.map((x) => x)),
        "FreightAmount": freightAmount,
        "TitleNote": titleNote == null ? null : titleNote,
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
        "GrandTotalCurrencies": grandTotalCurrencies == null
            ? null
            : List<dynamic>.from(grandTotalCurrencies.map((x) => x)),
        "ChangeCurrencies": changeCurrencies == null
            ? null
            : List<dynamic>.from(changeCurrencies.map((x) => x)),
        "GrandTotalCurrenciesDisplay": grandTotalCurrenciesDisplay == null
            ? null
            : grandTotalCurrenciesDisplay,
        "GrandTotalOtherCurrenciesDisplay":
            grandTotalOtherCurrenciesDisplay == null
                ? null
                : grandTotalOtherCurrenciesDisplay,
        "GrandTotalOtherCurrencies": grandTotalOtherCurrencies == null
            ? null
            : List<dynamic>.from(grandTotalOtherCurrencies.map((x) => x)),
        "ChangeCurrenciesDisplay":
            changeCurrenciesDisplay == null ? null : changeCurrenciesDisplay,
        "DisplayPayOtherCurrency": displayPayOtherCurrency == null
            ? null
            : List<dynamic>.from(displayPayOtherCurrency.map((x) => x)),
        "PaymentType": paymentType,
      };
}

class Freight {
  Freight({
    this.id,
    this.name,
    this.freightReceiptType,
    this.freightReceiptTypes,
    this.freightId,
    this.receiptId,
    this.amountReven,
    this.isActive,
  });

  final int id;
  final String name;
  int freightReceiptType;
  final List<FreightReceiptType> freightReceiptTypes;
  final int freightId;
  final int receiptId;
  double amountReven;
  bool isActive;

  factory Freight.fromJson(Map<String, dynamic> json) => Freight(
        id: json["ID"],
        name: json["Name"],
        freightReceiptType: json["FreightReceiptType"],
        freightReceiptTypes: List<FreightReceiptType>.from(
            json["FreightReceiptTypes"]
                .map((x) => FreightReceiptType.fromJson(x))),
        freightId: json["FreightID"],
        receiptId: json["ReceiptID"],
        amountReven: json["AmountReven"],
        isActive: json["IsActive"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Name": name,
        "FreightReceiptType": freightReceiptType,
        "FreightReceiptTypes":
            List<dynamic>.from(freightReceiptTypes.map((x) => x.toJson())),
        "FreightID": freightId,
        "ReceiptID": receiptId,
        "AmountReven": amountReven,
        "IsActive": isActive,
      };
}

class FreightReceiptType {
  FreightReceiptType({
    this.disabled,
    this.group,
    this.selected,
    this.text,
    this.value,
  });

  final bool disabled;
  final dynamic group;
  bool selected;
  String text;
  String value;

  factory FreightReceiptType.fromJson(Map<String, dynamic> json) =>
      FreightReceiptType(
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

@JsonSerializable(nullable: true)
class OrderDetailModel {
  OrderDetailModel({
    this.orderDetailId,
    this.orderId,
    this.orderDetailModelLineId,
    this.lineId,
    this.itemId,
    this.prefix,
    this.code,
    this.khmerName,
    this.englishName,
    this.cost,
    this.baseQty,
    this.qty,
    this.printQty,
    this.uomId,
    this.uom,
    this.itemUoms,
    this.groupUomId,
    this.unitPrice,
    this.discountRate,
    this.discountValue,
    this.remarkDiscounts,
    this.typeDis,
    this.taxGroups,
    this.taxGroupId,
    this.taxRate,
    this.taxValue,
    this.total,
    this.totalSys,
    this.totalNet,
    this.itemStatus,
    this.itemPrintTo,
    this.currency,
    this.comment,
    this.itemType,
    this.description,
    this.parentLineId,
    this.parentLevel,
    this.isReadonly,
    this.printer,
    this.promoTypeDisplay,
    this.promoType,
    this.linePosition,
    this.unitofMeansure,
    this.isVoided,
    this.ksServiceSetupId,
    this.vehicleId,
    this.isKsms,
    this.isKsmsMaster,
    this.isScale,
    this.comboSaleType,
    this.remarkDiscountId,
  });
  int orderDetailId;
  int orderId;
  int orderDetailModelLineId;
  String lineId;
  int itemId;
  dynamic prefix;
  String code;
  String khmerName;
  String englishName;
  double cost;
  double baseQty;
  double qty;
  double printQty;
  int uomId;
  String uom;
  final List<SelectListItem> itemUoms;
  int groupUomId;
  double unitPrice;
  double discountRate;
  double discountValue;
  dynamic remarkDiscounts;
  String typeDis;
  final List<SelectListItem> taxGroups;
  int taxGroupId;
  double taxRate;
  double taxValue;
  double total;
  double totalSys;
  double totalNet;
  String itemStatus;
  String itemPrintTo;
  String currency;
  dynamic comment;
  String itemType;
  String description;
  String parentLineId;
  dynamic parentLevel;
  bool isReadonly;
  final List<SelectListItem> printer;
  dynamic promoTypeDisplay;
  int promoType;
  int linePosition;
  dynamic unitofMeansure;
  bool isVoided;
  int ksServiceSetupId;
  int vehicleId;
  bool isKsms;
  bool isKsmsMaster;
  bool isScale;
  int comboSaleType;
  int remarkDiscountId;

  factory OrderDetailModel.copy(OrderDetailModel obj) => OrderDetailModel(
      orderDetailId: obj.orderDetailId,
      orderId: obj.orderId,
      orderDetailModelLineId: obj.orderDetailModelLineId,
      lineId: obj.lineId,
      itemId: obj.itemId,
      prefix: obj.prefix,
      code: obj.code,
      khmerName: obj.khmerName,
      englishName: obj.englishName,
      cost: obj.cost,
      baseQty: obj.baseQty,
      qty: obj.qty,
      printQty: obj.printQty,
      uomId: obj.uomId,
      uom: obj.uom,
      itemUoms: obj.itemUoms,
      groupUomId: obj.groupUomId,
      unitPrice: obj.unitPrice,
      discountRate: obj.discountRate,
      discountValue: obj.discountValue,
      remarkDiscounts: obj.remarkDiscounts,
      typeDis: obj.typeDis,
      taxGroups: obj.taxGroups,
      taxGroupId: obj.taxGroupId,
      taxRate: obj.taxRate,
      taxValue: obj.taxValue,
      total: obj.total,
      totalSys: obj.totalSys,
      totalNet: obj.totalNet,
      itemStatus: obj.itemStatus,
      itemPrintTo: obj.itemPrintTo,
      currency: obj.currency,
      comment: obj.comment,
      itemType: obj.itemType,
      description: obj.description,
      parentLineId: obj.parentLineId,
      parentLevel: obj.parentLevel,
      isReadonly: obj.isReadonly,
      printer: obj.printer,
      promoTypeDisplay: obj.promoTypeDisplay,
      promoType: obj.promoType,
      linePosition: obj.linePosition,
      unitofMeansure: obj.unitofMeansure,
      isVoided: obj.isVoided,
      ksServiceSetupId: obj.ksServiceSetupId,
      vehicleId: obj.vehicleId,
      isKsms: obj.isKsms,
      isKsmsMaster: obj.isKsmsMaster,
      isScale: obj.isScale,
      comboSaleType: obj.comboSaleType,
      remarkDiscountId: obj.remarkDiscountId);
  factory OrderDetailModel.fromJson(Map<String, dynamic> json) =>
      OrderDetailModel(
        orderDetailId: json["OrderDetailID"],
        orderId: json["OrderID"],
        orderDetailModelLineId: json["Line_ID"],
        lineId: json["LineID"],
        itemId: json["ItemID"],
        prefix: json["Prefix"],
        code: json["Code"],
        khmerName: json["KhmerName"],
        englishName: json["EnglishName"],
        cost: json["Cost"],
        baseQty: json["BaseQty"],
        qty: json["Qty"],
        printQty: json["PrintQty"],
        uomId: json["UomID"],
        uom: json["Uom"],
        itemUoms: json["ItemUoMs"] == null
            ? null
            : List<SelectListItem>.from(
                json["ItemUoMs"].map((x) => SelectListItem.fromJson(x))),
        groupUomId: json["GroupUomID"],
        unitPrice: json["UnitPrice"],
        discountRate: json["DiscountRate"],
        discountValue: json["DiscountValue"],
        remarkDiscounts: json["RemarkDiscounts"],
        typeDis: json["TypeDis"],
        taxGroups: json["TaxGroups"] == null
            ? null
            : List<SelectListItem>.from(
                json["TaxGroups"].map((e) => SelectListItem.fromJson(e))),
        taxGroupId: json["TaxGroupID"],
        taxRate: json["TaxRate"],
        taxValue: json["TaxValue"],
        total: json["Total"],
        totalSys: json["Total_Sys"],
        totalNet: json["TotalNet"],
        itemStatus: json["ItemStatus"],
        itemPrintTo: json["ItemPrintTo"],
        currency: json["Currency"],
        comment: json["Comment"],
        itemType: json["ItemType"],
        description: json["Description"] ?? "",
        parentLineId: json["ParentLineID"],
        parentLevel: json["ParentLevel"],
        isReadonly: json["IsReadonly"],
        printer: json['Printers'] == null
            ? null
            : List<SelectListItem>.from(
                json["Printers"].map((e) => SelectListItem.fromJson(e))),
        promoTypeDisplay: json["PromoTypeDisplay"],
        promoType: json["PromoType"],
        linePosition: json["LinePosition"],
        unitofMeansure: json["UnitofMeansure"],
        isVoided: json["IsVoided"],
        ksServiceSetupId: json["KSServiceSetupId"],
        vehicleId: json["VehicleId"],
        isKsms: json["IsKsms"],
        isKsmsMaster: json["IsKsmsMaster"],
        isScale: json["IsScale"],
        comboSaleType: json["ComboSaleType"],
        remarkDiscountId: json["RemarkDiscountID"],
      );

  Map<String, dynamic> toJson() => {
        "OrderDetailID": orderDetailId,
        "OrderID": orderId,
        "Line_ID": orderDetailModelLineId,
        "LineID": lineId,
        "ItemID": itemId,
        "Prefix": prefix,
        "Code": code,
        "KhmerName": khmerName,
        "EnglishName": englishName,
        "Cost": cost,
        "BaseQty": baseQty,
        "Qty": qty,
        "PrintQty": printQty,
        "UomID": uomId,
        "Uom": uom,
        "ItemUoMs": itemUoms == null
            ? null
            : List<dynamic>.from(itemUoms.map((x) => x.toJson())),
        "GroupUomID": groupUomId,
        "UnitPrice": unitPrice,
        "DiscountRate": discountRate,
        "DiscountValue": discountValue,
        "RemarkDiscounts": remarkDiscounts,
        "TypeDis": typeDis,
        "TaxGroups": taxGroups == null
            ? null
            : List<dynamic>.from(taxGroups.map((x) => x.toJson())),
        "TaxGroupID": taxGroupId,
        "TaxRate": taxRate,
        "TaxValue": taxValue,
        "Total": total,
        "Total_Sys": totalSys,
        "TotalNet": totalNet,
        "ItemStatus": itemStatus,
        "ItemPrintTo": itemPrintTo,
        "Currency": currency,
        "Comment": comment,
        "ItemType": itemType,
        "Description": description,
        "ParentLineID": parentLineId,
        "ParentLevel": parentLevel,
        "IsReadonly": isReadonly,
        "Printers": printer == null
            ? null
            : List<dynamic>.from(printer.map((x) => x.toJson())),
        "PromoTypeDisplay": promoTypeDisplay,
        "PromoType": promoType,
        "LinePosition": linePosition,
        "UnitofMeansure": unitofMeansure,
        "IsVoided": isVoided,
        "KSServiceSetupId": ksServiceSetupId,
        "VehicleId": vehicleId,
        "IsKsms": isKsms,
        "IsKsmsMaster": isKsmsMaster,
        "IsScale": isScale,
        "ComboSaleType": comboSaleType,
        "RemarkDiscountID": remarkDiscountId,
      };
}

class SelectListItem {
  SelectListItem({
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

  factory SelectListItem.fromJson(Map<String, dynamic> json) => SelectListItem(
        disabled: json["Disabled"] == null ? null : json["Disabled"],
        group: json["Group"] == null ? null : json["Group"],
        selected: json["Selected"] == null ? null : json["Selected"],
        text: json["Text"] == null ? null : json["Text"],
        value: json["Value"] == null ? null : json["Value"],
      );

  Map<String, dynamic> toJson() => {
        "Disabled": disabled == null ? null : disabled,
        "Group": group == null ? null : group,
        "Selected": selected == null ? null : selected,
        "Text": text == null ? null : text,
        "Value": value == null ? null : value,
      };
}

class DisplayPayOtherCurrency {
  DisplayPayOtherCurrency({
    this.id,
    this.orderId,
    this.lineId,
    this.baseCurrency,
    this.amount,
    this.altCurrency,
    this.altAmount,
    this.rate,
    this.altRate,
    this.baseCurrencyId,
    this.altCurrencyId,
    this.altSymbol,
    this.baseSymbol,
    this.isLocalCurrency,
    this.isShowCurrency,
    this.isActive,
    this.isShowOtherCurrency,
    this.decimalPlaces,
  });

  int id;
  int orderId;
  String lineId;
  String baseCurrency;
  double amount;
  String altCurrency;
  double altAmount;
  double rate;
  double altRate;
  int baseCurrencyId;
  int altCurrencyId;
  String altSymbol;
  String baseSymbol;
  bool isLocalCurrency;
  bool isShowCurrency;
  bool isActive;
  bool isShowOtherCurrency;
  double decimalPlaces;

  factory DisplayPayOtherCurrency.fromJson(Map<String, dynamic> json) =>
      DisplayPayOtherCurrency(
        id: json["ID"],
        orderId: json["OrderID"],
        lineId: json["LineID"],
        baseCurrency: json["BaseCurrency"],
        amount: json["Amount"],
        altCurrency: json["AltCurrency"],
        altAmount: json["AltAmount"],
        rate: json["Rate"].toDouble(),
        altRate: json["AltRate"].toDouble(),
        baseCurrencyId: json["BaseCurrencyID"],
        altCurrencyId: json["AltCurrencyID"],
        altSymbol: json["AltSymbol"],
        baseSymbol: json["BaseSymbol"],
        isLocalCurrency: json["IsLocalCurrency"],
        isShowCurrency: json["IsShowCurrency"],
        isActive: json["IsActive"],
        isShowOtherCurrency: json["IsShowOtherCurrency"],
        decimalPlaces: json["DecimalPlaces"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "OrderID": orderId,
        "LineID": lineId,
        "BaseCurrency": baseCurrency,
        "Amount": amount,
        "AltCurrency": altCurrency,
        "AltAmount": altAmount,
        "Rate": rate,
        "AltRate": altRate,
        "BaseCurrencyID": baseCurrencyId,
        "AltCurrencyID": altCurrencyId,
        "AltSymbol": altSymbol,
        "BaseSymbol": baseSymbol,
        "IsLocalCurrency": isLocalCurrency,
        "IsShowCurrency": isShowCurrency,
        "IsActive": isActive,
        "IsShowOtherCurrency": isShowOtherCurrency,
        "DecimalPlaces": decimalPlaces,
      };
}

class LoyaltyProgram {
  LoyaltyProgram({
    this.buyXGetXDetails,
    this.pointMembers,
    this.comboSales,
    this.buyXAmGetXDis,
    this.buyXQtyGetXDis,
  });

  List<BuyXGetXDetail> buyXGetXDetails;
  List<dynamic> pointMembers;
  List<dynamic> comboSales;
  List<dynamic> buyXAmGetXDis;
  List<dynamic> buyXQtyGetXDis;

  factory LoyaltyProgram.fromJson(Map<String, dynamic> json) => LoyaltyProgram(
        buyXGetXDetails: List<BuyXGetXDetail>.from(
            json["BuyXGetXDetails"].map((x) => BuyXGetXDetail.fromJson(x))),
        pointMembers: List<dynamic>.from(json["PointMembers"].map((x) => x)),
        comboSales: List<dynamic>.from(json["ComboSales"].map((x) => x)),
        buyXAmGetXDis: List<dynamic>.from(json["BuyXAmGetXDis"].map((x) => x)),
        buyXQtyGetXDis:
            List<dynamic>.from(json["BuyXQtyGetXDis"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "BuyXGetXDetails":
            List<dynamic>.from(buyXGetXDetails.map((x) => x.toJson())),
        "PointMembers": List<dynamic>.from(pointMembers.map((x) => x)),
        "ComboSales": List<dynamic>.from(comboSales.map((x) => x)),
        "BuyXAmGetXDis": List<dynamic>.from(buyXAmGetXDis.map((x) => x)),
        "BuyXQtyGetXDis": List<dynamic>.from(buyXQtyGetXDis.map((x) => x)),
      };
}

class BuyXGetXDetail {
  BuyXGetXDetail({
    this.lineId,
    this.buyItemId,
    this.proCode,
    this.itemCode,
    this.itemName,
    this.buyItemName,
    this.buyQty,
    this.uoM,
    this.itemUoMs,
    this.itemUomId,
    this.item,
    this.getItemId,
    this.getItemCode,
    this.getItemName,
    this.getQty,
    this.getUomId,
    this.getUomName,
    this.promoUoMs,
    this.id,
    this.buyXGetXid,
  });

  String lineId;
  int buyItemId;
  String proCode;
  String itemCode;
  String itemName;
  String buyItemName;
  double buyQty;
  String uoM;
  dynamic itemUoMs;
  int itemUomId;
  String item;
  int getItemId;
  String getItemCode;
  String getItemName;
  double getQty;
  int getUomId;
  String getUomName;
  dynamic promoUoMs;
  int id;
  int buyXGetXid;

  factory BuyXGetXDetail.fromJson(Map<String, dynamic> json) => BuyXGetXDetail(
        lineId: json["LineID"],
        buyItemId: json["BuyItemID"],
        proCode: json["ProCode"],
        itemCode: json["ItemCode"],
        itemName: json["ItemName"],
        buyItemName: json["BuyItemName"],
        buyQty: json["BuyQty"],
        uoM: json["UoM"],
        itemUoMs: json["ItemUoMs"],
        itemUomId: json["ItemUomID"],
        item: json["Item"],
        getItemId: json["GetItemID"],
        getItemCode: json["GetItemCode"],
        getItemName: json["GetItemName"],
        getQty: json["GetQty"],
        getUomId: json["GetUomID"],
        getUomName: json["GetUomName"],
        promoUoMs: json["PromoUoMs"],
        id: json["ID"],
        buyXGetXid: json["BuyXGetXID"],
      );

  Map<String, dynamic> toJson() => {
        "LineID": lineId,
        "BuyItemID": buyItemId,
        "ProCode": proCode,
        "ItemCode": itemCode,
        "ItemName": itemName,
        "BuyItemName": buyItemName,
        "BuyQty": buyQty,
        "UoM": uoM,
        "ItemUoMs": itemUoMs,
        "ItemUomID": itemUomId,
        "Item": item,
        "GetItemID": getItemId,
        "GetItemCode": getItemCode,
        "GetItemName": getItemName,
        "GetQty": getQty,
        "GetUomID": getUomId,
        "GetUomName": getUomName,
        "PromoUoMs": promoUoMs,
        "ID": id,
        "BuyXGetXID": buyXGetXid,
      };
}
// To parse this JSON data, do
//
//     final paymentMean = paymentMeanFromJson(jsonString);

class PaymentMean {
  PaymentMean({
    this.id,
    this.accountId,
    this.type,
    this.status,
    this.delete,
    this.paymentMeanDefault,
    this.companyId,
    this.isChecked,
    this.isReceivedChange,
    this.amount,
    this.pmName,
    this.glAccName,
    this.glAccCode,
    this.currency,
    this.spk,
    this.cpk,
    this.synced,
    this.syncDate,
  });

  final int id;
  final int accountId;
  final String type;
  final bool status;
  final bool delete;
  final bool paymentMeanDefault;
  final int companyId;
  bool isChecked;
  bool isReceivedChange;
  final double amount;
  final dynamic pmName;
  final dynamic glAccName;
  final dynamic glAccCode;
  final dynamic currency;
  final int spk;
  final int cpk;
  final bool synced;
  final DateTime syncDate;

  factory PaymentMean.fromJson(Map<String, dynamic> json) => PaymentMean(
        id: json["ID"],
        accountId: json["AccountID"],
        type: json["Type"],
        status: json["Status"],
        delete: json["Delete"],
        paymentMeanDefault: json["Default"],
        companyId: json["CompanyID"],
        isChecked: json["IsChecked"],
        isReceivedChange: json["IsReceivedChange"],
        amount: json["Amount"],
        pmName: json["PMName"],
        glAccName: json["GLAccName"],
        glAccCode: json["GLAccCode"],
        currency: json["Currency"],
        spk: json["Spk"],
        cpk: json["Cpk"],
        synced: json["Synced"],
        syncDate: DateTime.parse(json["SyncDate"]),
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "AccountID": accountId,
        "Type": type,
        "Status": status,
        "Delete": delete,
        "Default": paymentMeanDefault,
        "CompanyID": companyId,
        "IsChecked": isChecked,
        "IsReceivedChange": isReceivedChange,
        "Amount": amount,
        "PMName": pmName,
        "GLAccName": glAccName,
        "GLAccCode": glAccCode,
        "Currency": currency,
        "Spk": spk,
        "Cpk": cpk,
        "Synced": synced,
        "SyncDate": syncDate.toIso8601String(),
      };
}
