import 'dart:convert';

FetchOrderModelNew fetchOrderModelFromJson(String str) =>
    FetchOrderModelNew.fromJson(json.decode(str));

String fetchOrderModelToJson(FetchOrderModelNew data) =>
    json.encode(data.toJson());

class FetchOrderModelNew {
  FetchOrderModelNew({
    this.authOption,
    this.cardMemberOption,
    this.order,
    this.baseItemGroups,
    this.saleItems,
    this.displayPayOtherCurrency,
    this.orderTable,
    this.orders,
    this.setting,
    this.taxGroups,
    this.loyaltyProgram,
    this.freights,
    this.itemGroups,
    this.paymentMeans,
  });

  int authOption;
  int cardMemberOption;
  Order order;
  List<BaseItemGroup> baseItemGroups;
  List<BaseItemGroup> saleItems;
  List<DisplayPayOtherCurrency> displayPayOtherCurrency;
  OrderTable orderTable;
  List<Order> orders;
  Setting setting;
  List<TaxGroup> taxGroups;
  LoyaltyProgram loyaltyProgram;
  List<Freight> freights;
  List<BaseItemGroup> itemGroups;
  List<PaymentMean> paymentMeans;

  factory FetchOrderModelNew.fromJson(Map<String, dynamic> json) =>
      FetchOrderModelNew(
        authOption: json["AuthOption"],
        cardMemberOption: json["CardMemberOption"],
        order: Order.fromJson(json["Order"]),
        baseItemGroups: List<BaseItemGroup>.from(
          json["BaseItemGroups"].map((x) => BaseItemGroup.fromJson(x)),
        ),
        saleItems: List<BaseItemGroup>.from(
          json["SaleItems"].map((x) => BaseItemGroup.fromJson(x)),
        ),
        displayPayOtherCurrency: List<DisplayPayOtherCurrency>.from(
          json["DisplayPayOtherCurrency"].map(
            (x) => DisplayPayOtherCurrency.fromJson(x),
          ),
        ),
        orderTable: OrderTable.fromJson(json["OrderTable"]),
        orders: List<Order>.from(json["Orders"].map((x) => Order.fromJson(x))),
        setting: Setting.fromJson(json["Setting"]),
        taxGroups: List<TaxGroup>.from(
          json["TaxGroups"].map((x) => TaxGroup.fromJson(x)),
        ),
        loyaltyProgram: LoyaltyProgram.fromJson(json["LoyaltyProgram"]),
        freights: List<Freight>.from(
          json["Freights"].map((x) => Freight.fromJson(x)),
        ),
        itemGroups: List<BaseItemGroup>.from(
          json["ItemGroups"].map((x) => BaseItemGroup.fromJson(x)),
        ),
        paymentMeans: List<PaymentMean>.from(
          json["PaymentMeans"].map((x) => PaymentMean.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
        "AuthOption": authOption,
        "CardMemberOption": cardMemberOption,
        "Order": order.toJson(),
        "BaseItemGroups":
            List<dynamic>.from(baseItemGroups.map((x) => x.toJson())),
        "SaleItems": List<dynamic>.from(saleItems.map((x) => x.toJson())),
        "DisplayPayOtherCurrency":
            List<dynamic>.from(displayPayOtherCurrency.map((x) => x.toJson())),
        "OrderTable": orderTable.toJson(),
        "Orders": List<dynamic>.from(orders.map((x) => x.toJson())),
        "Setting": setting.toJson(),
        "TaxGroups": List<dynamic>.from(taxGroups.map((x) => x.toJson())),
        "LoyaltyProgram": loyaltyProgram.toJson(),
        "Freights": List<dynamic>.from(freights.map((x) => x.toJson())),
        "ItemGroups": List<dynamic>.from(itemGroups.map((x) => x.toJson())),
        "PaymentMeans": List<dynamic>.from(paymentMeans.map((x) => x.toJson())),
      };
}

class BaseItemGroup {
  BaseItemGroup({
    this.id,
    this.promotionId,
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
    this.symbol,
    this.startDate,
    this.stopDate,
    this.barcode,
    this.inStock,
    this.process,
    this.image,
    this.pricListId,
    this.groupUomId,
    this.printTo,
    this.itemType,
    this.description,
    this.isAddon,
    this.isScale,
    this.taxGroupSaleId,
    this.addictionProps,
    this.uomLists,
    this.uomChangeLists,
    this.level,
  });

  int id;
  int promotionId;
  int itemId;
  String code;
  int group1;
  int group2;
  int group3;
  String khmerName;
  String englishName;
  int qty;
  int printQty;
  double cost;
  double unitPrice;
  int discountRate;
  int discountValue;
  TypeDis typeDis;
  int vat;
  int currencyId;
  dynamic currency;
  int uomId;
  UoM uoM;
  Symbol symbol;
  DateTime startDate;
  DateTime stopDate;
  String barcode;
  int inStock;
  Process process;
  String image;
  int pricListId;
  int groupUomId;
  PrintBillName printTo;
  ItemType itemType;
  String description;
  bool isAddon;
  bool isScale;
  int taxGroupSaleId;
  dynamic addictionProps;
  dynamic uomLists;
  dynamic uomChangeLists;
  int level;

  factory BaseItemGroup.fromJson(Map<String, dynamic> json) => BaseItemGroup(
        id: json["ID"],
        promotionId: json["PromotionID"],
        itemId: json["ItemID"],
        code: json["Code"],
        group1: json["Group1"],
        group2: json["Group2"],
        group3: json["Group3"],
        khmerName: json["KhmerName"],
        englishName: json["EnglishName"],
        qty: json["Qty"],
        printQty: json["PrintQty"],
        cost: json["Cost"].toDouble(),
        unitPrice: json["UnitPrice"].toDouble(),
        discountRate: json["DiscountRate"],
        discountValue: json["DiscountValue"],
        typeDis: typeDisValues.map[json["TypeDis"]],
        vat: json["VAT"],
        currencyId: json["CurrencyID"],
        currency: json["Currency"],
        uomId: json["UomID"],
        uoM: uoMValues.map[json["UoM"]],
        symbol: symbolValues.map[json["Symbol"]],
        startDate: DateTime.parse(json["StartDate"]),
        stopDate: DateTime.parse(json["StopDate"]),
        barcode: json["Barcode"],
        inStock: json["InStock"],
        process: processValues.map[json["Process"]],
        image: json["Image"],
        pricListId: json["PricListID"],
        groupUomId: json["GroupUomID"],
        printTo: printBillNameValues.map[json["PrintTo"]],
        itemType: itemTypeValues.map[json["ItemType"]],
        description: json["Description"],
        isAddon: json["IsAddon"],
        isScale: json["IsScale"],
        taxGroupSaleId: json["TaxGroupSaleID"],
        addictionProps: json["AddictionProps"],
        uomLists: json["UomLists"],
        uomChangeLists: json["UomChangeLists"],
        level: json["Level"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "PromotionID": promotionId,
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
        "TypeDis": typeDisValues.reverse[typeDis],
        "VAT": vat,
        "CurrencyID": currencyId,
        "Currency": currency,
        "UomID": uomId,
        "UoM": uoMValues.reverse[uoM],
        "Symbol": symbolValues.reverse[symbol],
        "StartDate": startDate.toIso8601String(),
        "StopDate": stopDate.toIso8601String(),
        "Barcode": barcode,
        "InStock": inStock,
        "Process": processValues.reverse[process],
        "Image": image,
        "PricListID": pricListId,
        "GroupUomID": groupUomId,
        "PrintTo": printBillNameValues.reverse[printTo],
        "ItemType": itemTypeValues.reverse[itemType],
        "Description": description,
        "IsAddon": isAddon,
        "IsScale": isScale,
        "TaxGroupSaleID": taxGroupSaleId,
        "AddictionProps": addictionProps,
        "UomLists": uomLists,
        "UomChangeLists": uomChangeLists,
        "Level": level,
      };
}

enum ItemType { ITEM }

final itemTypeValues = EnumValues({"Item": ItemType.ITEM});

enum PrintBillName { SOFT_DRINK, PAY }

final printBillNameValues = EnumValues(
    {"Pay": PrintBillName.PAY, "SoftDrink": PrintBillName.SOFT_DRINK});

enum Process { FIFO, STANDARD }

final processValues =
    EnumValues({"FIFO": Process.FIFO, "Standard": Process.STANDARD});

enum Symbol { EMPTY }

final symbolValues = EnumValues({"\u0024": Symbol.EMPTY});

enum TypeDis { PERCENT }

final typeDisValues = EnumValues({"Percent": TypeDis.PERCENT});

enum UoM { UNIT }

final uoMValues = EnumValues({"Unit": UoM.UNIT});

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
    this.scRate,
    this.lcRate,
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
  int amount;
  String altCurrency;
  int altAmount;
  double rate;
  int altRate;
  int scRate;
  int lcRate;
  int baseCurrencyId;
  int altCurrencyId;
  String altSymbol;
  Symbol baseSymbol;
  bool isLocalCurrency;
  bool isShowCurrency;
  bool isActive;
  bool isShowOtherCurrency;
  int decimalPlaces;

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
        altRate: json["AltRate"],
        scRate: json["SCRate"],
        lcRate: json["LCRate"],
        baseCurrencyId: json["BaseCurrencyID"],
        altCurrencyId: json["AltCurrencyID"],
        altSymbol: json["AltSymbol"],
        baseSymbol: symbolValues.map[json["BaseSymbol"]],
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
        "SCRate": scRate,
        "LCRate": lcRate,
        "BaseCurrencyID": baseCurrencyId,
        "AltCurrencyID": altCurrencyId,
        "AltSymbol": altSymbol,
        "BaseSymbol": symbolValues.reverse[baseSymbol],
        "IsLocalCurrency": isLocalCurrency,
        "IsShowCurrency": isShowCurrency,
        "IsActive": isActive,
        "IsShowOtherCurrency": isShowOtherCurrency,
        "DecimalPlaces": decimalPlaces,
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
    this.rowId,
    this.changeLog,
  });

  int id;
  String name;
  int freightReceiptType;
  List<FreightReceiptType> freightReceiptTypes;
  int freightId;
  int receiptId;
  int amountReven;
  bool isActive;
  String rowId;
  DateTime changeLog;

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
        rowId: json["RowId"],
        changeLog: DateTime.parse(json["ChangeLog"]),
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
        "RowId": rowId,
        "ChangeLog": changeLog.toIso8601String(),
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

  bool disabled;
  dynamic group;
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

class LoyaltyProgram {
  LoyaltyProgram({
    this.buyXGetXDetails,
    this.pointMembers,
    this.comboSales,
    this.buyXAmGetXDis,
    this.buyXQtyGetXDis,
    this.name,
  });

  List<dynamic> buyXGetXDetails;
  List<dynamic> pointMembers;
  List<dynamic> comboSales;
  List<dynamic> buyXAmGetXDis;
  List<dynamic> buyXQtyGetXDis;
  String name;

  factory LoyaltyProgram.fromJson(Map<String, dynamic> json) => LoyaltyProgram(
        buyXGetXDetails: List<dynamic>.from(
          json["BuyXGetXDetails"].map((x) => x),
        ),
        pointMembers: List<dynamic>.from(json["PointMembers"].map((x) => x)),
        comboSales: List<dynamic>.from(json["ComboSales"].map((x) => x)),
        buyXAmGetXDis: List<dynamic>.from(json["BuyXAmGetXDis"].map((x) => x)),
        buyXQtyGetXDis: List<dynamic>.from(
          json["BuyXQtyGetXDis"].map((x) => x),
        ),
        name: json["Name"],
      );

  Map<String, dynamic> toJson() => {
        "BuyXGetXDetails": List<dynamic>.from(buyXGetXDetails.map((x) => x)),
        "PointMembers": List<dynamic>.from(pointMembers.map((x) => x)),
        "ComboSales": List<dynamic>.from(comboSales.map((x) => x)),
        "BuyXAmGetXDis": List<dynamic>.from(buyXAmGetXDis.map((x) => x)),
        "BuyXQtyGetXDis": List<dynamic>.from(buyXQtyGetXDis.map((x) => x)),
        "Name": name,
      };
}

class Order {
  Order({
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
    this.refNo,
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
    this.customerTips,
  });

  int orderId;
  DateTime postingDate;
  String orderNo;
  String customerCode;
  String customerName;
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
  Customer customer;
  int customerCount;
  int priceListId;
  int localCurrencyId;
  int sysCurrencyId;
  int exchangeRate;
  int warehouseId;
  int branchId;
  int companyId;
  int subTotal;
  int discountRate;
  int discountValue;
  TypeDis typeDis;
  int taxRate;
  int taxValue;
  int otherPaymentGrandTotal;
  int grandTotal;
  int grandTotalSys;
  int appliedAmount;
  int tip;
  int received;
  int change;
  String currencyDisplay;
  int displayRate;
  double grandTotalDisplay;
  double changeDisplay;
  int paymentMeansId;
  String checkBill;
  bool cancel;
  bool delete;
  int plCurrencyId;
  int plRate;
  int localSetRate;
  int seriesId;
  int seriesDid;
  List<OrderDetail> orderDetail;
  dynamic serialNumbers;
  dynamic batchNos;
  Currency currency;
  dynamic remark;
  dynamic reason;
  int male;
  int female;
  int children;
  int status;
  dynamic freights;
  int freightAmount;
  dynamic titleNote;
  int vehicleId;
  int taxOption;
  int promoCodeId;
  int promoCodeDiscRate;
  int promoCodeDiscValue;
  int remarkDiscountId;
  int buyXAmountGetXDisId;
  int buyXAmGetXDisRate;
  int buyXAmGetXDisValue;
  int cardMemberDiscountRate;
  int cardMemberDiscountValue;
  dynamic refNo;
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
  dynamic customerTips;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
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
        customer: Customer.fromJson(json["Customer"]),
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
        typeDis: typeDisValues.map[json["TypeDis"]],
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
        grandTotalDisplay: json["GrandTotal_Display"].toDouble(),
        changeDisplay: json["Change_Display"].toDouble(),
        paymentMeansId: json["PaymentMeansID"],
        checkBill: json["CheckBill"],
        cancel: json["Cancel"],
        delete: json["Delete"],
        plCurrencyId: json["PLCurrencyID"],
        plRate: json["PLRate"],
        localSetRate: json["LocalSetRate"],
        seriesId: json["SeriesID"],
        seriesDid: json["SeriesDID"],
        orderDetail: List<OrderDetail>.from(
          json["OrderDetail"].map((x) => OrderDetail.fromJson(x)),
        ),
        serialNumbers: json["SerialNumbers"],
        batchNos: json["BatchNos"],
        currency: Currency.fromJson(json["Currency"]),
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
        refNo: json["RefNo"],
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
        customerTips: json["CustomerTips"],
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
        "Customer": customer.toJson(),
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
        "TypeDis": typeDisValues.reverse[typeDis],
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
        "SerialNumbers": serialNumbers,
        "BatchNos": batchNos,
        "Currency": currency.toJson(),
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
        "RefNo": refNo,
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
        "CustomerTips": customerTips,
      };
}

class Currency {
  Currency({
    this.id,
    this.symbol,
    this.description,
    this.delete,
    this.rowId,
    this.changeLog,
    this.spk,
    this.cpk,
    this.synced,
    this.syncDate,
  });

  int id;
  Symbol symbol;
  String description;
  bool delete;
  String rowId;
  DateTime changeLog;
  int spk;
  int cpk;
  bool synced;
  DateTime syncDate;

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        id: json["ID"],
        symbol: symbolValues.map[json["Symbol"]],
        description: json["Description"],
        delete: json["Delete"],
        rowId: json["RowId"],
        changeLog: DateTime.parse(json["ChangeLog"]),
        spk: json["Spk"],
        cpk: json["Cpk"],
        synced: json["Synced"],
        syncDate: DateTime.parse(json["SyncDate"]),
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Symbol": symbolValues.reverse[symbol],
        "Description": description,
        "Delete": delete,
        "RowId": rowId,
        "ChangeLog": changeLog.toIso8601String(),
        "Spk": spk,
        "Cpk": cpk,
        "Synced": synced,
        "SyncDate": syncDate.toIso8601String(),
      };
}

class Customer {
  Customer({
    this.id,
    this.group1Id,
    this.group2Id,
    this.saleEmid,
    this.vatNumber,
    this.territoryId,
    this.customerSourceId,
    this.paymentTermsId,
    this.gpSink,
    this.creditLimit,
    this.glAccId,
    this.glAccDepositId,
    this.terrName,
    this.saleEmpName,
    this.territory,
    this.group1Name,
    this.group1,
    this.phoneNumber,
    this.priceListName,
    this.paymentCode,
    this.customerSourceName,
    this.instaillmentId,
    this.group2Name,
    this.code,
    this.name,
    this.name2,
    this.storeName,
    this.cumulativePoint,
    this.cardMemberId,
    this.balance,
    this.redeemedPoint,
    this.lineId,
    this.totalPoint,
    this.clearPoints,
    this.afterClear,
    this.outstandPoint,
    this.birthDate,
    this.type,
    this.contactPerson,
    this.daysInstail,
    this.instiallment,
    this.tel,
    this.glCode,
    this.instaillId,
    this.glName,
    this.actId,
    this.priName,
    this.priceListId,
    this.phone,
    this.months,
    this.days,
    this.email,
    this.address,
    this.point,
    this.delete,
    this.autoMobile,
    this.groupId,
    this.activities,
    this.priceList,
    this.contactPeople,
    this.contractBilings,
    this.bpBranches,
    this.rowId,
    this.changeLog,
    this.spk,
    this.cpk,
    this.synced,
    this.syncDate,
  });

  int id;
  int group1Id;
  int group2Id;
  int saleEmid;
  String vatNumber;
  int territoryId;
  int customerSourceId;
  int paymentTermsId;
  dynamic gpSink;
  int creditLimit;
  int glAccId;
  int glAccDepositId;
  dynamic terrName;
  dynamic saleEmpName;
  dynamic territory;
  dynamic group1Name;
  dynamic group1;
  dynamic phoneNumber;
  dynamic priceListName;
  dynamic paymentCode;
  dynamic customerSourceName;
  int instaillmentId;
  dynamic group2Name;
  String code;
  String name;
  dynamic name2;
  dynamic storeName;
  int cumulativePoint;
  int cardMemberId;
  int balance;
  int redeemedPoint;
  dynamic lineId;
  int totalPoint;
  int clearPoints;
  int afterClear;
  int outstandPoint;
  DateTime birthDate;
  String type;
  dynamic contactPerson;
  dynamic daysInstail;
  dynamic instiallment;
  int tel;
  dynamic glCode;
  int instaillId;
  dynamic glName;
  int actId;
  dynamic priName;
  int priceListId;
  String phone;
  int months;
  int days;
  String email;
  String address;
  bool point;
  bool delete;
  dynamic autoMobile;
  int groupId;
  int activities;
  PriceList priceList;
  dynamic contactPeople;
  dynamic contractBilings;
  dynamic bpBranches;
  String rowId;
  DateTime changeLog;
  int spk;
  int cpk;
  bool synced;
  DateTime syncDate;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["ID"],
        group1Id: json["Group1ID"],
        group2Id: json["Group2ID"],
        saleEmid: json["SaleEMID"],
        vatNumber: json["VatNumber"],
        territoryId: json["TerritoryID"],
        customerSourceId: json["CustomerSourceID"],
        paymentTermsId: json["PaymentTermsID"],
        gpSink: json["GPSink"],
        creditLimit: json["CreditLimit"],
        glAccId: json["GLAccID"],
        glAccDepositId: json["GLAccDepositID"],
        terrName: json["TerrName"],
        saleEmpName: json["SaleEmpName"],
        territory: json["Territory"],
        group1Name: json["Group1Name"],
        group1: json["Group1"],
        phoneNumber: json["PhoneNumber"],
        priceListName: json["PriceListName"],
        paymentCode: json["PaymentCode"],
        customerSourceName: json["CustomerSourceName"],
        instaillmentId: json["InstaillmentID"],
        group2Name: json["Group2Name"],
        code: json["Code"],
        name: json["Name"],
        name2: json["Name2"],
        storeName: json["StoreName"],
        cumulativePoint: json["CumulativePoint"],
        cardMemberId: json["CardMemberID"],
        balance: json["Balance"],
        redeemedPoint: json["RedeemedPoint"],
        lineId: json["LineID"],
        totalPoint: json["TotalPoint"],
        clearPoints: json["ClearPoints"],
        afterClear: json["AfterClear"],
        outstandPoint: json["OutstandPoint"],
        birthDate: DateTime.parse(json["BirthDate"]),
        type: json["Type"],
        contactPerson: json["ContactPerson"],
        daysInstail: json["DaysInstail"],
        instiallment: json["Instiallment"],
        tel: json["Tel"],
        glCode: json["GLCode"],
        instaillId: json["InstaillID"],
        glName: json["GLName"],
        actId: json["ActID"],
        priName: json["PriName"],
        priceListId: json["PriceListID"],
        phone: json["Phone"],
        months: json["Months"],
        days: json["Days"],
        email: json["Email"],
        address: json["Address"],
        point: json["Point"],
        delete: json["Delete"],
        autoMobile: json["AutoMobile"],
        groupId: json["GroupID"],
        activities: json["Activities"],
        priceList: PriceList.fromJson(json["PriceList"]),
        contactPeople: json["ContactPeople"],
        contractBilings: json["ContractBilings"],
        bpBranches: json["BPBranches"],
        rowId: json["RowId"],
        changeLog: DateTime.parse(json["ChangeLog"]),
        spk: json["Spk"],
        cpk: json["Cpk"],
        synced: json["Synced"],
        syncDate: DateTime.parse(json["SyncDate"]),
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Group1ID": group1Id,
        "Group2ID": group2Id,
        "SaleEMID": saleEmid,
        "VatNumber": vatNumber,
        "TerritoryID": territoryId,
        "CustomerSourceID": customerSourceId,
        "PaymentTermsID": paymentTermsId,
        "GPSink": gpSink,
        "CreditLimit": creditLimit,
        "GLAccID": glAccId,
        "GLAccDepositID": glAccDepositId,
        "TerrName": terrName,
        "SaleEmpName": saleEmpName,
        "Territory": territory,
        "Group1Name": group1Name,
        "Group1": group1,
        "PhoneNumber": phoneNumber,
        "PriceListName": priceListName,
        "PaymentCode": paymentCode,
        "CustomerSourceName": customerSourceName,
        "InstaillmentID": instaillmentId,
        "Group2Name": group2Name,
        "Code": code,
        "Name": name,
        "Name2": name2,
        "StoreName": storeName,
        "CumulativePoint": cumulativePoint,
        "CardMemberID": cardMemberId,
        "Balance": balance,
        "RedeemedPoint": redeemedPoint,
        "LineID": lineId,
        "TotalPoint": totalPoint,
        "ClearPoints": clearPoints,
        "AfterClear": afterClear,
        "OutstandPoint": outstandPoint,
        "BirthDate": birthDate.toIso8601String(),
        "Type": type,
        "ContactPerson": contactPerson,
        "DaysInstail": daysInstail,
        "Instiallment": instiallment,
        "Tel": tel,
        "GLCode": glCode,
        "InstaillID": instaillId,
        "GLName": glName,
        "ActID": actId,
        "PriName": priName,
        "PriceListID": priceListId,
        "Phone": phone,
        "Months": months,
        "Days": days,
        "Email": email,
        "Address": address,
        "Point": point,
        "Delete": delete,
        "AutoMobile": autoMobile,
        "GroupID": groupId,
        "Activities": activities,
        "PriceList": priceList.toJson(),
        "ContactPeople": contactPeople,
        "ContractBilings": contractBilings,
        "BPBranches": bpBranches,
        "RowId": rowId,
        "ChangeLog": changeLog.toIso8601String(),
        "Spk": spk,
        "Cpk": cpk,
        "Synced": synced,
        "SyncDate": syncDate.toIso8601String(),
      };
}

class PriceList {
  PriceList({
    this.id,
    this.name,
    this.delete,
    this.currencyId,
    this.currency,
    this.currencyName,
    this.rowId,
    this.changeLog,
    this.spk,
    this.cpk,
    this.synced,
    this.syncDate,
  });

  int id;
  String name;
  bool delete;
  int currencyId;
  Currency currency;
  dynamic currencyName;
  String rowId;
  DateTime changeLog;
  int spk;
  int cpk;
  bool synced;
  DateTime syncDate;

  factory PriceList.fromJson(Map<String, dynamic> json) => PriceList(
        id: json["ID"],
        name: json["Name"],
        delete: json["Delete"],
        currencyId: json["CurrencyID"],
        currency: Currency.fromJson(json["Currency"]),
        currencyName: json["CurrencyName"],
        rowId: json["RowId"],
        changeLog: DateTime.parse(json["ChangeLog"]),
        spk: json["Spk"],
        cpk: json["Cpk"],
        synced: json["Synced"],
        syncDate: DateTime.parse(json["SyncDate"]),
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Name": name,
        "Delete": delete,
        "CurrencyID": currencyId,
        "Currency": currency.toJson(),
        "CurrencyName": currencyName,
        "RowId": rowId,
        "ChangeLog": changeLog.toIso8601String(),
        "Spk": spk,
        "Cpk": cpk,
        "Synced": synced,
        "SyncDate": syncDate.toIso8601String(),
      };
}

class OrderDetail {
  OrderDetail({
    this.orderDetailId,
    this.orderId,
    this.orderDetailLineId,
    this.lineId,
    this.copyId,
    this.itemId,
    this.prefix,
    this.code,
    this.khmerName,
    this.englishName,
    this.cost,
    this.baseQty,
    this.qty,
    this.returnQty,
    this.printQty,
    this.uomId,
    this.uom,
    this.itemUoMs,
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
    this.commentUpdate,
    this.itemType,
    this.description,
    this.parentLineId,
    this.parentLevel,
    this.isReadonly,
    this.printers,
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
    this.serialNumbers,
    this.batchNos,
    this.addictionProps,
    this.serialNumberSelectedDetial,
    this.serialNumber,
    this.batchNo,
    this.isOutOfStock,
    this.isSerialNumber,
    this.isBatchNo,
    this.instock,
  });

  int orderDetailId;
  int orderId;
  int orderDetailLineId;
  String lineId;
  dynamic copyId;
  int itemId;
  dynamic prefix;
  String code;
  String khmerName;
  String englishName;
  int cost;
  int baseQty;
  int qty;
  int returnQty;
  int printQty;
  int uomId;
  UoM uom;
  dynamic itemUoMs;
  int groupUomId;
  int unitPrice;
  int discountRate;
  int discountValue;
  dynamic remarkDiscounts;
  TypeDis typeDis;
  dynamic taxGroups;
  int taxGroupId;
  int taxRate;
  int taxValue;
  int total;
  int totalSys;
  int totalNet;
  String itemStatus;
  PrintBillName itemPrintTo;
  String currency;
  dynamic comment;
  dynamic commentUpdate;
  ItemType itemType;
  dynamic description;
  dynamic parentLineId;
  dynamic parentLevel;
  bool isReadonly;
  dynamic printers;
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
  dynamic serialNumbers;
  dynamic batchNos;
  dynamic addictionProps;
  dynamic serialNumberSelectedDetial;
  dynamic serialNumber;
  dynamic batchNo;
  bool isOutOfStock;
  bool isSerialNumber;
  bool isBatchNo;
  int instock;

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
        orderDetailId: json["OrderDetailID"],
        orderId: json["OrderID"],
        orderDetailLineId: json["Line_ID"],
        lineId: json["LineID"],
        copyId: json["CopyID"],
        itemId: json["ItemID"],
        prefix: json["Prefix"],
        code: json["Code"],
        khmerName: json["KhmerName"],
        englishName: json["EnglishName"],
        cost: json["Cost"],
        baseQty: json["BaseQty"],
        qty: json["Qty"],
        returnQty: json["ReturnQty"],
        printQty: json["PrintQty"],
        uomId: json["UomID"],
        uom: uoMValues.map[json["Uom"]],
        itemUoMs: json["ItemUoMs"],
        groupUomId: json["GroupUomID"],
        unitPrice: json["UnitPrice"],
        discountRate: json["DiscountRate"],
        discountValue: json["DiscountValue"],
        remarkDiscounts: json["RemarkDiscounts"],
        typeDis: typeDisValues.map[json["TypeDis"]],
        taxGroups: json["TaxGroups"],
        taxGroupId: json["TaxGroupID"],
        taxRate: json["TaxRate"],
        taxValue: json["TaxValue"],
        total: json["Total"],
        totalSys: json["Total_Sys"],
        totalNet: json["TotalNet"],
        itemStatus: json["ItemStatus"],
        itemPrintTo: printBillNameValues.map[json["ItemPrintTo"]],
        currency: json["Currency"],
        comment: json["Comment"],
        commentUpdate: json["CommentUpdate"],
        itemType: itemTypeValues.map[json["ItemType"]],
        description: json["Description"],
        parentLineId: json["ParentLineID"],
        parentLevel: json["ParentLevel"],
        isReadonly: json["IsReadonly"],
        printers: json["Printers"],
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
        serialNumbers: json["SerialNumbers"],
        batchNos: json["BatchNos"],
        addictionProps: json["AddictionProps"],
        serialNumberSelectedDetial: json["SerialNumberSelectedDetial"],
        serialNumber: json["SerialNumber"],
        batchNo: json["BatchNo"],
        isOutOfStock: json["IsOutOfStock"],
        isSerialNumber: json["IsSerialNumber"],
        isBatchNo: json["IsBatchNo"],
        instock: json["Instock"],
      );

  Map<String, dynamic> toJson() => {
        "OrderDetailID": orderDetailId,
        "OrderID": orderId,
        "Line_ID": orderDetailLineId,
        "LineID": lineId,
        "CopyID": copyId,
        "ItemID": itemId,
        "Prefix": prefix,
        "Code": code,
        "KhmerName": khmerName,
        "EnglishName": englishName,
        "Cost": cost,
        "BaseQty": baseQty,
        "Qty": qty,
        "ReturnQty": returnQty,
        "PrintQty": printQty,
        "UomID": uomId,
        "Uom": uoMValues.reverse[uom],
        "ItemUoMs": itemUoMs,
        "GroupUomID": groupUomId,
        "UnitPrice": unitPrice,
        "DiscountRate": discountRate,
        "DiscountValue": discountValue,
        "RemarkDiscounts": remarkDiscounts,
        "TypeDis": typeDisValues.reverse[typeDis],
        "TaxGroups": taxGroups,
        "TaxGroupID": taxGroupId,
        "TaxRate": taxRate,
        "TaxValue": taxValue,
        "Total": total,
        "Total_Sys": totalSys,
        "TotalNet": totalNet,
        "ItemStatus": itemStatus,
        "ItemPrintTo": printBillNameValues.reverse[itemPrintTo],
        "Currency": currency,
        "Comment": comment,
        "CommentUpdate": commentUpdate,
        "ItemType": itemTypeValues.reverse[itemType],
        "Description": description,
        "ParentLineID": parentLineId,
        "ParentLevel": parentLevel,
        "IsReadonly": isReadonly,
        "Printers": printers,
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
        "SerialNumbers": serialNumbers,
        "BatchNos": batchNos,
        "AddictionProps": addictionProps,
        "SerialNumberSelectedDetial": serialNumberSelectedDetial,
        "SerialNumber": serialNumber,
        "BatchNo": batchNo,
        "IsOutOfStock": isOutOfStock,
        "IsSerialNumber": isSerialNumber,
        "IsBatchNo": isBatchNo,
        "Instock": instock,
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
    this.startDateTime,
    this.endDateTime,
    this.type,
    this.duration,
    this.durationText,
    this.rowId,
    this.changeLog,
    this.spk,
    this.cpk,
    this.synced,
    this.syncDate,
    this.refNo,
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
  DateTime startDateTime;
  DateTime endDateTime;
  int type;
  double duration;
  String durationText;
  String rowId;
  DateTime changeLog;
  int spk;
  int cpk;
  bool synced;
  DateTime syncDate;
  dynamic refNo;

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
        startDateTime: DateTime.parse(json["StartDateTime"]),
        endDateTime: DateTime.parse(json["EndDateTime"]),
        type: json["Type"],
        duration: json["Duration"].toDouble(),
        durationText: json["DurationText"],
        rowId: json["RowId"],
        changeLog: DateTime.parse(json["ChangeLog"]),
        spk: json["Spk"],
        cpk: json["Cpk"],
        synced: json["Synced"],
        syncDate: DateTime.parse(json["SyncDate"]),
        refNo: json["RefNo"],
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
        "StartDateTime": startDateTime.toIso8601String(),
        "EndDateTime": endDateTime.toIso8601String(),
        "Type": type,
        "Duration": duration,
        "DurationText": durationText,
        "RowId": rowId,
        "ChangeLog": changeLog.toIso8601String(),
        "Spk": spk,
        "Cpk": cpk,
        "Synced": synced,
        "SyncDate": syncDate.toIso8601String(),
        "RefNo": refNo,
      };
}

class PaymentMean {
  PaymentMean({
    this.id,
    this.accountId,
    this.type,
    this.currency,
    this.status,
    this.delete,
    this.paymentMeanDefault,
    this.companyId,
    this.isChecked,
    this.isReceivedChange,
    this.amount,
    this.pmName,
    this.altCurrencyId,
    this.glAccName,
    this.glAccCode,
    this.payment,
    this.paymentMethod,
    this.rowId,
    this.changeLog,
    this.spk,
    this.cpk,
    this.synced,
    this.syncDate,
  });

  int id;
  int accountId;
  String type;
  List<FreightReceiptType> currency;
  bool status;
  bool delete;
  bool paymentMeanDefault;
  int companyId;
  bool isChecked;
  bool isReceivedChange;
  int amount;
  dynamic pmName;
  int altCurrencyId;
  dynamic glAccName;
  dynamic glAccCode;
  dynamic payment;
  int paymentMethod;
  String rowId;
  DateTime changeLog;
  int spk;
  int cpk;
  bool synced;
  DateTime syncDate;

  factory PaymentMean.fromJson(Map<String, dynamic> json) => PaymentMean(
        id: json["ID"],
        accountId: json["AccountID"],
        type: json["Type"],
        currency: List<FreightReceiptType>.from(
          json["Currency"].map((x) => FreightReceiptType.fromJson(x)),
        ),
        status: json["Status"],
        delete: json["Delete"],
        paymentMeanDefault: json["Default"],
        companyId: json["CompanyID"],
        isChecked: json["IsChecked"],
        isReceivedChange: json["IsReceivedChange"],
        amount: json["Amount"],
        pmName: json["PMName"],
        altCurrencyId: json["AltCurrencyID"],
        glAccName: json["GLAccName"],
        glAccCode: json["GLAccCode"],
        payment: json["Payment"],
        paymentMethod: json["PaymentMethod"],
        rowId: json["RowId"],
        changeLog: DateTime.parse(json["ChangeLog"]),
        spk: json["Spk"],
        cpk: json["Cpk"],
        synced: json["Synced"],
        syncDate: DateTime.parse(json["SyncDate"]),
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "AccountID": accountId,
        "Type": type,
        "Currency": List<dynamic>.from(currency.map((x) => x.toJson())),
        "Status": status,
        "Delete": delete,
        "Default": paymentMeanDefault,
        "CompanyID": companyId,
        "IsChecked": isChecked,
        "IsReceivedChange": isReceivedChange,
        "Amount": amount,
        "PMName": pmName,
        "AltCurrencyID": altCurrencyId,
        "GLAccName": glAccName,
        "GLAccCode": glAccCode,
        "Payment": payment,
        "PaymentMethod": paymentMethod,
        "RowId": rowId,
        "ChangeLog": changeLog.toIso8601String(),
        "Spk": spk,
        "Cpk": cpk,
        "Synced": synced,
        "SyncDate": syncDate.toIso8601String(),
      };
}

class Setting {
  Setting({
    this.id,
    this.branchId,
    this.delayHours,
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
    this.previewReceipt,
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
    this.rememberCustomer,
    this.cash,
    this.enableCountMember,
    this.sortBy,
    this.portraite,
    this.customerTips,
    this.slideShow,
    this.timeOut,
  });

  int id;
  int branchId;
  int delayHours;
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
  int rateIn;
  int rateOut;
  PrintBillName printer;
  int paymentMeansId;
  int companyId;
  int warehouseId;
  int customerId;
  int priceListId;
  bool vatAble;
  dynamic vatNum;
  dynamic wifi;
  dynamic macAddress;
  bool previewReceipt;
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
  PrintBillName printerOrder;
  int printOrderCount;
  dynamic printLabelName;
  PrintBillName printBillName;
  int queueOption;
  int taxOption;
  int tax;
  bool enablePromoCode;
  bool isCusPriceList;
  bool rememberCustomer;
  bool cash;
  bool enableCountMember;
  SortBy sortBy;
  bool portraite;
  bool customerTips;
  bool slideShow;
  int timeOut;

  factory Setting.fromJson(Map<String, dynamic> json) => Setting(
        id: json["ID"],
        branchId: json["BranchID"],
        delayHours: json["DelayHours"],
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
        printer: printBillNameValues.map[json["Printer"]],
        paymentMeansId: json["PaymentMeansID"],
        companyId: json["CompanyID"],
        warehouseId: json["WarehouseID"],
        customerId: json["CustomerID"],
        priceListId: json["PriceListID"],
        vatAble: json["VatAble"],
        vatNum: json["VatNum"],
        wifi: json["Wifi"],
        macAddress: json["MacAddress"],
        previewReceipt: json["PreviewReceipt"],
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
        printerOrder: printBillNameValues.map[json["PrinterOrder"]],
        printOrderCount: json["PrintOrderCount"],
        printLabelName: json["PrintLabelName"],
        printBillName: printBillNameValues.map[json["PrintBillName"]],
        queueOption: json["QueueOption"],
        taxOption: json["TaxOption"],
        tax: json["Tax"],
        enablePromoCode: json["EnablePromoCode"],
        isCusPriceList: json["IsCusPriceList"],
        rememberCustomer: json["RememberCustomer"],
        cash: json["Cash"],
        enableCountMember: json["EnableCountMember"],
        sortBy: SortBy.fromJson(json["SortBy"]),
        portraite: json["Portraite"],
        customerTips: json["CustomerTips"],
        slideShow: json["SlideShow"],
        timeOut: json["TimeOut"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "BranchID": branchId,
        "DelayHours": delayHours,
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
        "Printer": printBillNameValues.reverse[printer],
        "PaymentMeansID": paymentMeansId,
        "CompanyID": companyId,
        "WarehouseID": warehouseId,
        "CustomerID": customerId,
        "PriceListID": priceListId,
        "VatAble": vatAble,
        "VatNum": vatNum,
        "Wifi": wifi,
        "MacAddress": macAddress,
        "PreviewReceipt": previewReceipt,
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
        "PrinterOrder": printBillNameValues.reverse[printerOrder],
        "PrintOrderCount": printOrderCount,
        "PrintLabelName": printLabelName,
        "PrintBillName": printBillNameValues.reverse[printBillName],
        "QueueOption": queueOption,
        "TaxOption": taxOption,
        "Tax": tax,
        "EnablePromoCode": enablePromoCode,
        "IsCusPriceList": isCusPriceList,
        "RememberCustomer": rememberCustomer,
        "Cash": cash,
        "EnableCountMember": enableCountMember,
        "SortBy": sortBy.toJson(),
        "Portraite": portraite,
        "CustomerTips": customerTips,
        "SlideShow": slideShow,
        "TimeOut": timeOut,
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

class TaxGroup {
  TaxGroup({
    this.id,
    this.name,
    this.rate,
  });

  int id;
  String name;
  int rate;

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

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
