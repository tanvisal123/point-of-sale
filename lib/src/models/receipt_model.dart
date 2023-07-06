import 'dart:convert';

import 'package:point_of_sale/src/models/currency_model.dart';

List<ReceiptModel> receiptModelFromJson(String str) => List<ReceiptModel>.from(
    json.decode(str).map((x) => ReceiptModel.fromJson(x)));

String receiptModelToJson(List<ReceiptModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReceiptModel {
  int receiptID;
  int orderID;
  String orderNo;
  int tableID;
  String receiptNo;
  String queueNo;
  String dateIn;
  String dateOut;
  String timeIn;
  String timeOut;
  int waiterID;
  int userOrderID;
  int userDiscountID;
  int customerID;
  int customerCount;
  int priceListID;
  int localCurrencyID;
  int sysCurrencyID;
  double exchangeRate;
  int warehouseID;
  int branchID;
  int companyID;
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
  int paymentMeansID;
  String checkBill;
  bool cancel;
  bool delete;
  bool returns;
  int pLCurrencyID;
  double pLRate;
  double localSetRate;
  String paymentType;
  String receivedType;
  double credit;
  Currency currency;
  UserAccount userAccount;
  Table table;
  double sumGrandTotalLC;
  double sumGrandTotalSC;
  double sumDiscountValue;
  double sumTaxValue;

  @override
  String toString() {
    return 'ReceiptId = $receiptID, ReceiptNo = $receiptNo, $tableID=${table.iD}:${table.name}, SumGrandTotalSC = $sumGrandTotalSC, SumGrandTotalLC = $sumGrandTotalLC, SumDiscountValue = $sumDiscountValue';
  }

  ReceiptModel({
    this.receiptID,
    this.orderID,
    this.orderNo,
    this.tableID,
    this.receiptNo,
    this.queueNo,
    this.dateIn,
    this.dateOut,
    this.timeIn,
    this.timeOut,
    this.waiterID,
    this.userOrderID,
    this.userDiscountID,
    this.customerID,
    this.customerCount,
    this.priceListID,
    this.localCurrencyID,
    this.sysCurrencyID,
    this.exchangeRate,
    this.warehouseID,
    this.branchID,
    this.companyID,
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
    this.paymentMeansID,
    this.checkBill,
    this.cancel,
    this.delete,
    this.returns,
    this.pLCurrencyID,
    this.pLRate,
    this.localSetRate,
    this.paymentType,
    this.receivedType,
    this.credit,
    this.currency,
    this.userAccount,
    this.table,
    this.sumGrandTotalLC,
    this.sumGrandTotalSC,
    this.sumDiscountValue,
    this.sumTaxValue,
  });

  ReceiptModel.fromJson(Map<String, dynamic> json) {
    receiptID = json['ReceiptID'];
    orderID = json['OrderID'];
    orderNo = json['OrderNo'];
    tableID = json['TableID'];
    receiptNo = json['ReceiptNo'];
    queueNo = json['QueueNo'];
    dateIn = json['DateIn'];
    dateOut = json['DateOut'];
    timeIn = json['TimeIn'];
    timeOut = json['TimeOut'];
    waiterID = json['WaiterID'];
    userOrderID = json['UserOrderID'];
    userDiscountID = json['UserDiscountID'];
    customerID = json['CustomerID'];
    customerCount = json['CustomerCount'];
    priceListID = json['PriceListID'];
    localCurrencyID = json['LocalCurrencyID'];
    sysCurrencyID = json['SysCurrencyID'];
    exchangeRate = json['ExchangeRate'];
    warehouseID = json['WarehouseID'];
    branchID = json['BranchID'];
    companyID = json['CompanyID'];
    subTotal = json['Sub_Total'];
    discountRate = json['DiscountRate'];
    discountValue = json['DiscountValue'];
    typeDis = json['TypeDis'];
    taxRate = json['TaxRate'];
    taxValue = json['TaxValue'];
    grandTotal = json['GrandTotal'];
    grandTotalSys = json['GrandTotal_Sys'];
    tip = json['Tip'];
    received = json['Received'];
    change = json['Change'];
    currencyDisplay = json['CurrencyDisplay'];
    displayRate = json['DisplayRate'];
    grandTotalDisplay = json['GrandTotal_Display'];
    changeDisplay = json['Change_Display'];
    paymentMeansID = json['PaymentMeansID'];
    checkBill = json['CheckBill'];
    cancel = json['Cancel'];
    delete = json['Delete'];
    returns = json['Return'];
    pLCurrencyID = json['PLCurrencyID'];
    pLRate = json['PLRate'];
    localSetRate = json['LocalSetRate'];
    paymentType = json['PaymentType'];
    receivedType = json['ReceivedType'];
    credit = json['Credit'];
    sumGrandTotalLC = json['SumGrandTotal'];
    sumGrandTotalSC = json['SumGrandTotalSys'];
    sumDiscountValue = json['SumDiscountValue'];
    sumTaxValue = json['SumTaxValue'];
    currency =
        json['Currency'] != null ? Currency.fromJson(json['Currency']) : null;
    userAccount = json['UserAccount'] != null
        ? new UserAccount.fromJson(json['UserAccount'])
        : null;
    table = json['Table'] != null ? new Table.fromJson(json['Table']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ReceiptID'] = this.receiptID;
    data['OrderID'] = this.orderID;
    data['OrderNo'] = this.orderNo;
    data['TableID'] = this.tableID;
    data['ReceiptNo'] = this.receiptNo;
    data['QueueNo'] = this.queueNo;
    data['DateIn'] = this.dateIn;
    data['DateOut'] = this.dateOut;
    data['TimeIn'] = this.timeIn;
    data['TimeOut'] = this.timeOut;
    data['WaiterID'] = this.waiterID;
    data['UserOrderID'] = this.userOrderID;
    data['UserDiscountID'] = this.userDiscountID;
    data['CustomerID'] = this.customerID;
    data['CustomerCount'] = this.customerCount;
    data['PriceListID'] = this.priceListID;
    data['LocalCurrencyID'] = this.localCurrencyID;
    data['SysCurrencyID'] = this.sysCurrencyID;
    data['ExchangeRate'] = this.exchangeRate;
    data['WarehouseID'] = this.warehouseID;
    data['BranchID'] = this.branchID;
    data['CompanyID'] = this.companyID;
    data['Sub_Total'] = this.subTotal;
    data['DiscountRate'] = this.discountRate;
    data['DiscountValue'] = this.discountValue;
    data['TypeDis'] = this.typeDis;
    data['TaxRate'] = this.taxRate;
    data['TaxValue'] = this.taxValue;
    data['GrandTotal'] = this.grandTotal;
    data['GrandTotal_Sys'] = this.grandTotalSys;
    data['Tip'] = this.tip;
    data['Received'] = this.received;
    data['Change'] = this.change;
    data['CurrencyDisplay'] = this.currencyDisplay;
    data['DisplayRate'] = this.displayRate;
    data['GrandTotal_Display'] = this.grandTotalDisplay;
    data['Change_Display'] = this.changeDisplay;
    data['PaymentMeansID'] = this.paymentMeansID;
    data['CheckBill'] = this.checkBill;
    data['Cancel'] = this.cancel;
    data['Delete'] = this.delete;
    data['Return'] = this.returns;
    data['PLCurrencyID'] = this.pLCurrencyID;
    data['PLRate'] = this.pLRate;
    data['LocalSetRate'] = this.localSetRate;
    data['PaymentType'] = this.paymentType;
    data['ReceivedType'] = this.receivedType;
    data['Credit'] = this.credit;
    data['SumGrandTotal'] = this.sumGrandTotalLC;
    data['SumGrandTotalSys'] = this.sumGrandTotalSC;
    data['SumDiscountValue'] = this.sumDiscountValue;
    data['SumTaxValue'] = this.sumTaxValue;
    if (this.currency != null) {
      data['Currency'] = this.currency.toJson();
    }
    if (this.userAccount != null) {
      data['UserAccount'] = this.userAccount.toJson();
    }
    if (this.table != null) {
      data['Table'] = this.table.toJson();
    }
    return data;
  }
}

class Currency {
  int iD;
  String symbol;
  String description;
  bool delete;

  Currency({this.iD, this.symbol, this.description, this.delete});

  Currency.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    symbol = json['Symbol'];
    description = json['Description'];
    delete = json['Delete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Symbol'] = this.symbol;
    data['Description'] = this.description;
    data['Delete'] = this.delete;
    return data;
  }
}

class UserAccount {
  int iD;
  int employeeID;
  int companyID;
  int branchID;
  String username;
  String password;
  String comfirmPassword;
  bool userPos;
  String language;
  bool status;
  bool delete;
  Employee employee;
  String company;
  String branch;

  UserAccount(
      {this.iD,
      this.employeeID,
      this.companyID,
      this.branchID,
      this.username,
      this.password,
      this.comfirmPassword,
      this.userPos,
      this.language,
      this.status,
      this.delete,
      this.employee,
      this.company,
      this.branch});

  UserAccount.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    employeeID = json['EmployeeID'];
    companyID = json['CompanyID'];
    branchID = json['BranchID'];
    username = json['Username'];
    password = json['Password'];
    comfirmPassword = json['ComfirmPassword'];
    userPos = json['UserPos'];
    language = json['Language'];
    status = json['Status'];
    delete = json['Delete'];
    employee = json['Employee'] != null
        ? new Employee.fromJson(json['Employee'])
        : null;
    company = json['Company'];
    branch = json['Branch'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['EmployeeID'] = this.employeeID;
    data['CompanyID'] = this.companyID;
    data['BranchID'] = this.branchID;
    data['Username'] = this.username;
    data['Password'] = this.password;
    data['ComfirmPassword'] = this.comfirmPassword;
    data['UserPos'] = this.userPos;
    data['Language'] = this.language;
    data['Status'] = this.status;
    data['Delete'] = this.delete;
    if (this.employee != null) {
      data['Employee'] = this.employee.toJson();
    }
    data['Company'] = this.company;
    data['Branch'] = this.branch;
    return data;
  }
}

class Employee {
  String image;
  int iD;
  String code;
  String name;
  int gender;
  String birthdate;
  String hiredate;
  String address;
  String phone;
  String email;
  String photo;
  bool stopwork;
  String position;
  bool isUser;
  bool delete;

  Employee(
      {this.image,
      this.iD,
      this.code,
      this.name,
      this.gender,
      this.birthdate,
      this.hiredate,
      this.address,
      this.phone,
      this.email,
      this.photo,
      this.stopwork,
      this.position,
      this.isUser,
      this.delete});

  Employee.fromJson(Map<String, dynamic> json) {
    image = json['Image'];
    iD = json['ID'];
    code = json['Code'];
    name = json['Name'];
    gender = json['Gender'];
    birthdate = json['Birthdate'];
    hiredate = json['Hiredate'];
    address = json['Address'];
    phone = json['Phone'];
    email = json['Email'];
    photo = json['Photo'];
    stopwork = json['Stopwork'];
    position = json['Position'];
    isUser = json['IsUser'];
    delete = json['Delete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Image'] = this.image;
    data['ID'] = this.iD;
    data['Code'] = this.code;
    data['Name'] = this.name;
    data['Gender'] = this.gender;
    data['Birthdate'] = this.birthdate;
    data['Hiredate'] = this.hiredate;
    data['Address'] = this.address;
    data['Phone'] = this.phone;
    data['Email'] = this.email;
    data['Photo'] = this.photo;
    data['Stopwork'] = this.stopwork;
    data['Position'] = this.position;
    data['IsUser'] = this.isUser;
    data['Delete'] = this.delete;
    return data;
  }
}

class Table {
  int iD;
  String name;
  int groupTableID;
  String image;
  String status;
  String time;
  bool delete;
  String groupTable;

  Table(
      {this.iD,
      this.name,
      this.groupTableID,
      this.image,
      this.status,
      this.time,
      this.delete,
      this.groupTable});

  Table.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    groupTableID = json['GroupTableID'];
    image = json['Image'];
    status = json['Status'];
    time = json['Time'];
    delete = json['Delete'];
    groupTable = json['GroupTable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['GroupTableID'] = this.groupTableID;
    data['Image'] = this.image;
    data['Status'] = this.status;
    data['Time'] = this.time;
    data['Delete'] = this.delete;
    data['GroupTable'] = this.groupTable;
    return data;
  }
}
