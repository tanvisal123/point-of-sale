// To parse this JSON data, do
//
//     final orderDetailModel = orderDetailModelFromJson(jsonString);

import 'dart:convert';

OrderDetailModels orderDetailModelFromJson(String str) =>
    OrderDetailModels.fromJson(json.decode(str));

String orderDetailModelToJson(OrderDetailModels data) =>
    json.encode(data.toJson());

class OrderDetailModels {
  OrderDetailModels({
    this.setting,
    this.authOption,
    this.cardMemberOption,
    this.orders,
    this.order,
    this.orderTable,
    this.baseItemGroups,
    this.saleItems,
    this.freights,
    this.itemUoMs,
    this.taxGroups,
    this.promoTypes,
    this.loyaltyProgram,
    this.seriesPs,
    this.remarkDiscountItem,
    this.displayPayOtherCurrency,
    this.displayTotalAndChangeCurrency,
    this.displayGrandTotalOtherCurrency,
  });

  Setting setting;
  int authOption;
  int cardMemberOption;
  List<Order> orders;
  Order order;
  OrderTable orderTable;
  List<BaseItemGroup> baseItemGroups;
  List<BaseItemGroup> saleItems;
  List<Freight> freights;
  List<ItemUoM> itemUoMs;
  List<TaxGroup> taxGroups;
  Map<String, String> promoTypes;
  LoyaltyProgram loyaltyProgram;
  List<SeriesP> seriesPs;
  List<RemarkDiscountItem> remarkDiscountItem;
  List<DisplayCurrency> displayPayOtherCurrency;
  List<DisplayCurrency> displayTotalAndChangeCurrency;
  List<DisplayCurrency> displayGrandTotalOtherCurrency;

  factory OrderDetailModels.fromJson(Map<String, dynamic> json) =>
      OrderDetailModels(
        setting: Setting.fromJson(json["Setting"]),
        authOption: json["AuthOption"],
        cardMemberOption: json["CardMemberOption"],
        orders: List<Order>.from(json["Orders"].map((x) => Order.fromJson(x))),
        order: Order.fromJson(json["Order"]),
        orderTable: OrderTable.fromJson(json["OrderTable"]),
        baseItemGroups: List<BaseItemGroup>.from(
            json["BaseItemGroups"].map((x) => BaseItemGroup.fromJson(x))),
        saleItems: List<BaseItemGroup>.from(
            json["SaleItems"].map((x) => BaseItemGroup.fromJson(x))),
        freights: List<Freight>.from(
            json["Freights"].map((x) => Freight.fromJson(x))),
        itemUoMs: List<ItemUoM>.from(
            json["ItemUoMs"].map((x) => ItemUoM.fromJson(x))),
        taxGroups: List<TaxGroup>.from(
            json["TaxGroups"].map((x) => TaxGroup.fromJson(x))),
        promoTypes: Map.from(json["PromoTypes"])
            .map((k, v) => MapEntry<String, String>(k, v)),
        loyaltyProgram: LoyaltyProgram.fromJson(json["LoyaltyProgram"]),
        seriesPs: List<SeriesP>.from(
            json["SeriesPS"].map((x) => SeriesP.fromJson(x))),
        remarkDiscountItem: List<RemarkDiscountItem>.from(
            json["RemarkDiscountItem"]
                .map((x) => RemarkDiscountItem.fromJson(x))),
        displayPayOtherCurrency: List<DisplayCurrency>.from(
            json["DisplayPayOtherCurrency"]
                .map((x) => DisplayCurrency.fromJson(x))),
        displayTotalAndChangeCurrency: List<DisplayCurrency>.from(
            json["DisplayTotalAndChangeCurrency"]
                .map((x) => DisplayCurrency.fromJson(x))),
        displayGrandTotalOtherCurrency: List<DisplayCurrency>.from(
            json["DisplayGrandTotalOtherCurrency"]
                .map((x) => DisplayCurrency.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Setting": setting.toJson(),
        "AuthOption": authOption,
        "CardMemberOption": cardMemberOption,
        "Orders": List<dynamic>.from(orders.map((x) => x.toJson())),
        "Order": order.toJson(),
        "OrderTable": orderTable.toJson(),
        "BaseItemGroups":
            List<dynamic>.from(baseItemGroups.map((x) => x.toJson())),
        "SaleItems": List<dynamic>.from(saleItems.map((x) => x.toJson())),
        "Freights": List<dynamic>.from(freights.map((x) => x.toJson())),
        "ItemUoMs": List<dynamic>.from(itemUoMs.map((x) => x.toJson())),
        "TaxGroups": List<dynamic>.from(taxGroups.map((x) => x.toJson())),
        "PromoTypes":
            Map.from(promoTypes).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "LoyaltyProgram": loyaltyProgram.toJson(),
        "SeriesPS": List<dynamic>.from(seriesPs.map((x) => x.toJson())),
        "RemarkDiscountItem":
            List<dynamic>.from(remarkDiscountItem.map((x) => x.toJson())),
        "DisplayPayOtherCurrency":
            List<dynamic>.from(displayPayOtherCurrency.map((x) => x.toJson())),
        "DisplayTotalAndChangeCurrency": List<dynamic>.from(
            displayTotalAndChangeCurrency.map((x) => x.toJson())),
        "DisplayGrandTotalOtherCurrency": List<dynamic>.from(
            displayGrandTotalOtherCurrency.map((x) => x.toJson())),
      };
}

class BaseItemGroup {
  BaseItemGroup({
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
  });

  int id;
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
  BaseCurrency currency;
  int uomId;
  UoM uoM;
  String barcode;
  Process process;
  Image image;
  int pricListId;
  int groupUomId;
  PrintBillName printTo;
  ItemType itemType;
  String description;
  bool isAddon;
  int inStock;
  bool isScale;
  int taxGroupSaleId;
  AddictionProps addictionProps;

  factory BaseItemGroup.fromJson(Map<String, dynamic> json) => BaseItemGroup(
        id: json["ID"],
        itemId: json["ItemID"],
        code: json["Code"] == null ? null : json["Code"],
        group1: json["Group1"],
        group2: json["Group2"],
        group3: json["Group3"],
        khmerName: json["KhmerName"],
        englishName: json["EnglishName"] == null ? null : json["EnglishName"],
        qty: json["Qty"],
        printQty: json["PrintQty"],
        cost: json["Cost"].toDouble(),
        unitPrice: json["UnitPrice"].toDouble(),
        discountRate: json["DiscountRate"],
        discountValue: json["DiscountValue"],
        typeDis:
            json["TypeDis"] == null ? null : typeDisValues.map[json["TypeDis"]],
        vat: json["VAT"],
        currencyId: json["CurrencyID"],
        currency: json["Currency"] == null
            ? null
            : baseCurrencyValues.map[json["Currency"]],
        uomId: json["UomID"],
        uoM: json["UoM"] == null ? null : uoMValues.map[json["UoM"]],
        barcode: json["Barcode"] == null ? null : json["Barcode"],
        process:
            json["Process"] == null ? null : processValues.map[json["Process"]],
        image: json["Image"] == null ? null : imageValues.map[json["Image"]],
        pricListId: json["PricListID"],
        groupUomId: json["GroupUomID"],
        printTo: json["PrintTo"] == null
            ? null
            : printBillNameValues.map[json["PrintTo"]],
        itemType: json["ItemType"] == null
            ? null
            : itemTypeValues.map[json["ItemType"]],
        description: json["Description"] == null ? null : json["Description"],
        isAddon: json["IsAddon"],
        inStock: json["InStock"],
        isScale: json["IsScale"],
        taxGroupSaleId: json["TaxGroupSaleID"],
        addictionProps: json["AddictionProps"] == null
            ? null
            : AddictionProps.fromJson(json["AddictionProps"]),
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "ItemID": itemId,
        "Code": code == null ? null : code,
        "Group1": group1,
        "Group2": group2,
        "Group3": group3,
        "KhmerName": khmerName,
        "EnglishName": englishName == null ? null : englishName,
        "Qty": qty,
        "PrintQty": printQty,
        "Cost": cost,
        "UnitPrice": unitPrice,
        "DiscountRate": discountRate,
        "DiscountValue": discountValue,
        "TypeDis": typeDis == null ? null : typeDisValues.reverse[typeDis],
        "VAT": vat,
        "CurrencyID": currencyId,
        "Currency":
            currency == null ? null : baseCurrencyValues.reverse[currency],
        "UomID": uomId,
        "UoM": uoM == null ? null : uoMValues.reverse[uoM],
        "Barcode": barcode == null ? null : barcode,
        "Process": process == null ? null : processValues.reverse[process],
        "Image": image == null ? null : imageValues.reverse[image],
        "PricListID": pricListId,
        "GroupUomID": groupUomId,
        "PrintTo":
            printTo == null ? null : printBillNameValues.reverse[printTo],
        "ItemType": itemType == null ? null : itemTypeValues.reverse[itemType],
        "Description": description == null ? null : description,
        "IsAddon": isAddon,
        "InStock": inStock,
        "IsScale": isScale,
        "TaxGroupSaleID": taxGroupSaleId,
        "AddictionProps":
            addictionProps == null ? null : addictionProps.toJson(),
      };
}

class AddictionProps {
  AddictionProps({
    this.brand,
    this.countryOfOrigin,
    this.sellByDate,
    this.color,
    this.width,
    this.height,
  });

  Brand brand;
  Brand countryOfOrigin;
  Brand sellByDate;
  Brand color;
  Brand width;
  Brand height;

  factory AddictionProps.fromJson(Map<String, dynamic> json) => AddictionProps(
        brand: Brand.fromJson(json["Brand"]),
        countryOfOrigin: Brand.fromJson(json["CountryOfOrigin"]),
        sellByDate: Brand.fromJson(json["SellByDate"]),
        color: Brand.fromJson(json["Color"]),
        width: Brand.fromJson(json["Width"]),
        height: Brand.fromJson(json["height"]),
      );

  Map<String, dynamic> toJson() => {
        "Brand": brand.toJson(),
        "CountryOfOrigin": countryOfOrigin.toJson(),
        "SellByDate": sellByDate.toJson(),
        "Color": color.toJson(),
        "Width": width.toJson(),
        "height": height.toJson(),
      };
}

class Brand {
  Brand({
    this.id,
    this.proId,
    this.itemId,
    this.value,
    this.valueName,
  });

  int id;
  int proId;
  int itemId;
  int value;
  String valueName;

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
        id: json["ID"],
        proId: json["ProID"],
        itemId: json["ItemID"],
        value: json["Value"],
        valueName: json["ValueName"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "ProID": proId,
        "ItemID": itemId,
        "Value": value,
        "ValueName": valueName,
      };
}

enum BaseCurrency { USD }

final baseCurrencyValues = EnumValues({"USD": BaseCurrency.USD});

enum Image { THE_0_A5_B31_F5_E1_E543618_C941113_CFB0_A9_BE_JPG, NO_IMAGE_JPG }

final imageValues = EnumValues({
  "no-image.jpg": Image.NO_IMAGE_JPG,
  "0a5b31f5e1e543618c941113cfb0a9be.jpg":
      Image.THE_0_A5_B31_F5_E1_E543618_C941113_CFB0_A9_BE_JPG
});

enum ItemType { ITEM }

final itemTypeValues = EnumValues({"Item": ItemType.ITEM});

enum PrintBillName { PAY }

final printBillNameValues = EnumValues({"Pay": PrintBillName.PAY});

enum Process { FIFO, AVERAGE, STANDARD, SEBA }

final processValues = EnumValues({
  "Average": Process.AVERAGE,
  "FIFO": Process.FIFO,
  "SEBA": Process.SEBA,
  "Standard": Process.STANDARD
});

enum TypeDis { PERCENT }

final typeDisValues = EnumValues({"Percent": TypeDis.PERCENT});

enum UoM { PACK, BOX, KG, UNIT, CAN, CASE }

final uoMValues = EnumValues({
  "Box": UoM.BOX,
  "Can": UoM.CAN,
  "Case": UoM.CASE,
  "KG": UoM.KG,
  "Pack": UoM.PACK,
  "UNIT": UoM.UNIT
});

class DisplayCurrency {
  DisplayCurrency({
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
  BaseCurrency baseCurrency;
  int amount;
  String altCurrency;
  int altAmount;
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
  int decimalPlaces;

  factory DisplayCurrency.fromJson(Map<String, dynamic> json) =>
      DisplayCurrency(
        id: json["ID"],
        orderId: json["OrderID"],
        lineId: json["LineID"],
        baseCurrency: baseCurrencyValues.map[json["BaseCurrency"]],
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
        "BaseCurrency": baseCurrencyValues.reverse[baseCurrency],
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

class Freight {
  Freight({
    this.id,
    this.name,
    this.freightId,
    this.receiptId,
    this.amountReven,
  });

  int id;
  String name;
  int freightId;
  int receiptId;
  int amountReven;

  factory Freight.fromJson(Map<String, dynamic> json) => Freight(
        id: json["ID"],
        name: json["Name"],
        freightId: json["FreightID"],
        receiptId: json["ReceiptID"],
        amountReven: json["AmountReven"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Name": name,
        "FreightID": freightId,
        "ReceiptID": receiptId,
        "AmountReven": amountReven,
      };
}

class ItemUoM {
  ItemUoM({
    this.groupUomId,
    this.uomId,
    this.name,
  });

  int groupUomId;
  int uomId;
  String name;

  factory ItemUoM.fromJson(Map<String, dynamic> json) => ItemUoM(
        groupUomId: json["GroupUomID"],
        uomId: json["UomID"],
        name: json["Name"],
      );

  Map<String, dynamic> toJson() => {
        "GroupUomID": groupUomId,
        "UomID": uomId,
        "Name": name,
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

  List<dynamic> buyXGetXDetails;
  List<dynamic> pointMembers;
  List<dynamic> comboSales;
  List<dynamic> buyXAmGetXDis;
  List<dynamic> buyXQtyGetXDis;

  factory LoyaltyProgram.fromJson(Map<String, dynamic> json) => LoyaltyProgram(
        buyXGetXDetails:
            List<dynamic>.from(json["BuyXGetXDetails"].map((x) => x)),
        pointMembers: List<dynamic>.from(json["PointMembers"].map((x) => x)),
        comboSales: List<dynamic>.from(json["ComboSales"].map((x) => x)),
        buyXAmGetXDis: List<dynamic>.from(json["BuyXAmGetXDis"].map((x) => x)),
        buyXQtyGetXDis:
            List<dynamic>.from(json["BuyXQtyGetXDis"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "BuyXGetXDetails": List<dynamic>.from(buyXGetXDetails.map((x) => x)),
        "PointMembers": List<dynamic>.from(pointMembers.map((x) => x)),
        "ComboSales": List<dynamic>.from(comboSales.map((x) => x)),
        "BuyXAmGetXDis": List<dynamic>.from(buyXAmGetXDis.map((x) => x)),
        "BuyXQtyGetXDis": List<dynamic>.from(buyXQtyGetXDis.map((x) => x)),
      };
}

class Order {
  Order({
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
    this.currency,
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
  TypeDis typeDis;
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
  List<OrderDetail> orderDetail;
  Currency currency;
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
  int cardMemberDiscountRate;
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

  factory Order.fromJson(Map<String, dynamic> json) => Order(
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
        typeDis: typeDisValues.map[json["TypeDis"]],
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
        orderDetail: List<OrderDetail>.from(
            json["OrderDetail"].map((x) => OrderDetail.fromJson(x))),
        currency: Currency.fromJson(json["Currency"]),
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
        "Currency": currency.toJson(),
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

class Currency {
  Currency({
    this.id,
    this.symbol,
    this.description,
    this.delete,
  });

  int id;
  String symbol;
  BaseCurrency description;
  bool delete;

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        id: json["ID"],
        symbol: json["Symbol"],
        description: baseCurrencyValues.map[json["Description"]],
        delete: json["Delete"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Symbol": symbol,
        "Description": baseCurrencyValues.reverse[description],
        "Delete": delete,
      };
}

class Customer {
  Customer({
    this.id,
    this.glAccId,
    this.code,
    this.name,
    this.cumulativePoint,
    this.cardMemberId,
    this.balance,
    this.redeemedPoint,
    this.outstandPoint,
    this.birthDate,
    this.type,
    this.priceListId,
    this.phone,
    this.email,
    this.address,
    this.delete,
    this.autoMobile,
    this.groupId,
    this.group1Id,
    this.group2Id,
    this.saleEmid,
    this.vatNumber,
    this.priceList,
  });

  int id;
  int glAccId;
  String code;
  String name;
  double cumulativePoint;
  int cardMemberId;
  double balance;
  int redeemedPoint;
  double outstandPoint;
  DateTime birthDate;
  String type;
  int priceListId;
  String phone;
  String email;
  String address;
  bool delete;
  dynamic autoMobile;
  int groupId;
  int group1Id;
  int group2Id;
  int saleEmid;
  int vatNumber;
  PriceList priceList;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["ID"],
        glAccId: json["GLAccID"],
        code: json["Code"],
        name: json["Name"],
        cumulativePoint: json["CumulativePoint"].toDouble(),
        cardMemberId: json["CardMemberID"],
        balance: json["Balance"].toDouble(),
        redeemedPoint: json["RedeemedPoint"],
        outstandPoint: json["OutstandPoint"].toDouble(),
        birthDate: DateTime.parse(json["BirthDate"]),
        type: json["Type"],
        priceListId: json["PriceListID"],
        phone: json["Phone"],
        email: json["Email"],
        address: json["Address"],
        delete: json["Delete"],
        autoMobile: json["AutoMobile"],
        groupId: json["GroupID"],
        group1Id: json["Group1ID"],
        group2Id: json["Group2ID"],
        saleEmid: json["SaleEMID"],
        vatNumber: json["VatNumber"],
        priceList: PriceList.fromJson(json["PriceList"]),
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "GLAccID": glAccId,
        "Code": code,
        "Name": name,
        "CumulativePoint": cumulativePoint,
        "CardMemberID": cardMemberId,
        "Balance": balance,
        "RedeemedPoint": redeemedPoint,
        "OutstandPoint": outstandPoint,
        "BirthDate": birthDate.toIso8601String(),
        "Type": type,
        "PriceListID": priceListId,
        "Phone": phone,
        "Email": email,
        "Address": address,
        "Delete": delete,
        "AutoMobile": autoMobile,
        "GroupID": groupId,
        "Group1ID": group1Id,
        "Group2ID": group2Id,
        "SaleEMID": saleEmid,
        "VatNumber": vatNumber,
        "PriceList": priceList.toJson(),
      };
}

class PriceList {
  PriceList({
    this.id,
    this.name,
    this.delete,
    this.currencyId,
    this.currency,
  });

  int id;
  String name;
  bool delete;
  int currencyId;
  Currency currency;

  factory PriceList.fromJson(Map<String, dynamic> json) => PriceList(
        id: json["ID"],
        name: json["Name"],
        delete: json["Delete"],
        currencyId: json["CurrencyID"],
        currency: Currency.fromJson(json["Currency"]),
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Name": name,
        "Delete": delete,
        "CurrencyID": currencyId,
        "Currency": currency.toJson(),
      };
}

class OrderDetail {
  OrderDetail({
    this.orderDetailId,
    this.orderId,
    this.orderDetailLineId,
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
    this.addictionProps,
  });

  int orderDetailId;
  int orderId;
  int orderDetailLineId;
  String lineId;
  int itemId;
  dynamic prefix;
  String code;
  String khmerName;
  String englishName;
  double cost;
  int baseQty;
  int qty;
  int printQty;
  int uomId;
  UoM uom;
  dynamic itemUoMs;
  int groupUomId;
  double unitPrice;
  int discountRate;
  int discountValue;
  dynamic remarkDiscounts;
  TypeDis typeDis;
  dynamic taxGroups;
  int taxGroupId;
  int taxRate;
  int taxValue;
  double total;
  double totalSys;
  double totalNet;
  String itemStatus;
  PrintBillName itemPrintTo;
  BaseCurrency currency;
  dynamic comment;
  ItemType itemType;
  String description;
  String parentLineId;
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
  AddictionProps addictionProps;

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
        orderDetailId: json["OrderDetailID"],
        orderId: json["OrderID"],
        orderDetailLineId: json["Line_ID"],
        lineId: json["LineID"],
        itemId: json["ItemID"],
        prefix: json["Prefix"],
        code: json["Code"],
        khmerName: json["KhmerName"],
        englishName: json["EnglishName"],
        cost: json["Cost"].toDouble(),
        baseQty: json["BaseQty"],
        qty: json["Qty"],
        printQty: json["PrintQty"],
        uomId: json["UomID"],
        uom: uoMValues.map[json["Uom"]],
        itemUoMs: json["ItemUoMs"],
        groupUomId: json["GroupUomID"],
        unitPrice: json["UnitPrice"].toDouble(),
        discountRate: json["DiscountRate"],
        discountValue: json["DiscountValue"],
        remarkDiscounts: json["RemarkDiscounts"],
        typeDis: typeDisValues.map[json["TypeDis"]],
        taxGroups: json["TaxGroups"],
        taxGroupId: json["TaxGroupID"],
        taxRate: json["TaxRate"],
        taxValue: json["TaxValue"],
        total: json["Total"].toDouble(),
        totalSys: json["Total_Sys"].toDouble(),
        totalNet: json["TotalNet"].toDouble(),
        itemStatus: json["ItemStatus"],
        itemPrintTo: printBillNameValues.map[json["ItemPrintTo"]],
        currency: baseCurrencyValues.map[json["Currency"]],
        comment: json["Comment"],
        itemType: itemTypeValues.map[json["ItemType"]],
        description: json["Description"] == null ? null : json["Description"],
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
        addictionProps: AddictionProps.fromJson(json["AddictionProps"]),
      );

  Map<String, dynamic> toJson() => {
        "OrderDetailID": orderDetailId,
        "OrderID": orderId,
        "Line_ID": orderDetailLineId,
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
        "Currency": baseCurrencyValues.reverse[currency],
        "Comment": comment,
        "ItemType": itemTypeValues.reverse[itemType],
        "Description": description == null ? null : description,
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
        "AddictionProps": addictionProps.toJson(),
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

class RemarkDiscountItem {
  RemarkDiscountItem({
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

  factory RemarkDiscountItem.fromJson(Map<String, dynamic> json) =>
      RemarkDiscountItem(
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
  int rateIn;
  int rateOut;
  PrintBillName printer;
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
  PrintBillName printerOrder;
  int printOrderCount;
  PrintBillName printLabelName;
  PrintBillName printBillName;
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
        printLabelName: printBillNameValues.map[json["PrintLabelName"]],
        printBillName: printBillNameValues.map[json["PrintBillName"]],
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
        "PrintLabelName": printBillNameValues.reverse[printLabelName],
        "PrintBillName": printBillNameValues.reverse[printBillName],
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
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
