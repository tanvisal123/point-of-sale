// ignore: import_of_legacy_library_into_null_safe
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ConnectionDatabase {
  setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'db_pos');
    var database =
        await openDatabase(path, version: 1, onCreate: _onCreateDatabase);
    return database;
  }

  _onCreateDatabase(Database database, int version) async {
    //
    // await database.execute(
    //   "CREATE TABLE tbUser ("
    //   "userId TEXT PRIMARY KEY,"
    //   "userName TEXT,"
    //   "companyName TEXT,"
    //   "logo TEXT,"
    //   ")",
    // );
    // await database.execute(
    //   "CREATE TABLE tbPrinter ("
    //   "printerId TEXT PRIMARY KEY,"
    //   "printerName TEXT,"
    //   "interface TEXT,"
    //   "printerMode TEXT,"
    //   "paperWidth INTEGER,"
    //   "printReceiptStatus TEXT,"
    //   "autoPrintReceiptStatus TEXT"
    //   ")",
    // );
    await database.execute(
      'CREATE TABLE tbSetting ('
      'id INTEGER PRIMARY KEY,'
      'branchId INTEGER,'
      'receiptSize TEXT,'
      'receiptTemplate TEXT,'
      'printReceiptOrder BIT,'
      'printReceiptTender BIT,'
      'printCountReceipt INTEGER,'
      'queueCount INTEGER,'
      'sysCurrencyId INTEGER,'
      'localCurrencyId INTEGER,'
      'rateIn REAL,'
      'rateOut REAL,'
      'printer TEXT,'
      'paymentMeansId INTEGER,'
      'companyId INTEGER,'
      'warehouseId INTEGER,'
      'customerId INTEGER,'
      'priceListId INTEGER,'
      'vatAble BIT,'
      'vatNum TEXT,'
      'wifi TEXT,'
      'macAddress TEXT,'
      'autoQueue BIT,'
      'printLabel BIT,'
      'closeShift INTEGER'
      ')',
    );
    await database.execute(
      'CREATE TABLE tbOpenShift('
      'ID INTEGER PRIMARY KEY,'
      'DateIn TEXT,'
      'TimeIn TEXT,'
      'BranchID INTEGER,'
      'UserID INTEGER,'
      'CashAmount_Sys REAL,'
      'Trans_From REAL,'
      'Open BIT,'
      'LocalCurrencyID INTEGER,'
      'SysCurrencyID INTEGER,'
      'LocalSetRate REAL'
      ')',
    );
    await database.execute(
      'CREATE TABLE tbTax('
      'id INTEGER PRIMARY KEY,'
      'name TEXT,'
      'rate REAL'
      ')',
    );
    await database.execute(
      'CREATE TABLE tbPaymentMean('
      'id INTEGER PRIMARY KEY,'
      'type TEXT'
      ')',
    );
    await database.execute(
      'CREATE TABLE tbDisplayCurr('
      'id INTEGER PRIMARY KEY,'
      'altCurr TEXT,'
      'baseCurr TEXT,'
      'rate REAL'
      ')',
    );
    await database.execute(
      "CREATE TABLE tbReceipt ("
      "key INTEGER PRIMARY KEY,"
      "id INTEGER,"
      "branchId INTEGER,"
      "branchName TEXT,"
      "address TEXT,"
      "deskhmer TEXT,"
      "desEnglish TEXT,"
      "logo TEXT,"
      "phone1 TEXT,"
      "phone2 TEXT,"
      "title TEXT"
      ")",
    );
    await database.execute(
      "CREATE TABLE tbGroup1 ("
      "Id INTEGER PRIMARY KEY,"
      "g1Id INTEGER,"
      "g2Id INTEGER,"
      "g3Id INTEGER,"
      "name TEXT,"
      "image TEXT"
      ")",
    );
    await database.execute(
      "CREATE TABLE tbGroup2 ("
      "Id INTEGER PRIMARY KEY,"
      "g1Id INTEGER,"
      "g2Id INTEGER,"
      "g3Id INTEGER,"
      "name TEXT,"
      "image TEXT"
      ")",
    );
    await database.execute(
      "CREATE TABLE tbGroup3 ("
      "Id INTEGER PRIMARY KEY,"
      "g1Id INTEGER,"
      "g2Id INTEGER,"
      "g3Id INTEGER,"
      "name TEXT,"
      "image TEXT"
      ")",
    );
    await database.execute(
      "CREATE TABLE tbItem ("
      "id INTEGER PRIMARY KEY,"
      "key INTEGER,"
      "itemId INTEGER,"
      "itemCode TEXT,"
      "itemName TEXT,"
      "qty REAL,"
      "printQty REAL,"
      "cost REAL,"
      "unitPrice REAL,"
      "disRate REAL,"
      "disValue REAL,"
      "typeDis TEXT,"
      "vat REAL,"
      "currencyId INTEGER,"
      "currency TEXT,"
      "uomId INTEGER,"
      "uom TEXT,"
      "barcode TEXT,"
      "process TEXT,"
      "image TEXT,"
      "priceListId INTEGER,"
      "inStock INTEGER,"
      "commited INTEGER,"
      "ordered INTEGER,"
      "available INTEGER,"
      "printTo TEXT,"
      "itemType TEXT,"
      "typeDisItem TEXT,"
      "disValueItem REAL,"
      "status BIT,"
      "g1Id INTEGER,"
      "g2Id INTEGER,"
      "g3Id INTEGER"
      ")",
    );

    await database.execute(
      "CREATE TABLE tbOrder ("
      "id INTEGER PRIMARY KEY,"
      "orderId INTEGER,"
      "orderNo TEXT,"
      "tableId INTEGER,"
      "receiptNo TEXT,"
      "queueNo TEXT,"
      "dateIn DATETIME,"
      "dateOut DATETIME,"
      "timeIn TEXT,"
      "timeOut TEXT,"
      "waiterId INTEGER,"
      "userOrderId INTEGER,"
      "userDiscountId INTEGER,"
      "customerId INTEGER,"
      "customerCount INTEGER,"
      "priceListId INTEGER,"
      "localCurrencyId INTEGER,"
      "sysCurrencyId INTEGER,"
      "exchangeRate REAL,"
      "warehouseId INTEGER,"
      "branchId INTEGER,"
      "companyId INTEGER,"
      "subTotal REAL,"
      "discountRate REAL,"
      "discountValue REAL,"
      "typeDis TEXT,"
      "taxRate REAL,"
      "taxValue REAL,"
      "grandTotal REAL,"
      "grandTotalSys REAL,"
      "tip REAL,"
      "received REAL,"
      "change REAL,"
      "currencyDisplay TEXT,"
      "displayRate REAL,"
      "grandTotalDisplay REAL,"
      "changeDisplay REAL,"
      "paymentMeansId INTEGER,"
      "checkBill TEXT,"
      "cancel BIT,"
      "[delete] BIT,"
      "paymentType TEXT,"
      "receivedType TEXT,"
      "credit REAL,"
      "localSetRate REAL,"
      "plCurrencyId INTEGER,"
      "plRate REAL"
      ")",
    );
    await database.execute(
      "CREATE TABLE tbOrderDetail ("
      "id INTEGER PRIMARY KEY,"
      "masterId INTEGER,"
      "orderDetailId INTEGER,"
      "orderId INTEGER,"
      "lineId INTEGER,"
      "itemId INTEGER,"
      "code TEXT,"
      "khmerName TEXT,"
      "englishName TEXT,"
      "qty REAL,"
      "printQty REAL,"
      "unitPrice REAL,"
      "cost REAL,"
      "discountRate REAL,"
      "discountValue REAL,"
      "typeDis TEXT,"
      "total REAL,"
      "totalSys REAL,"
      "uomId INTEGER,"
      "uomName TEXT,"
      "itemStatus TEXT,"
      "itemPrintTo TEXT,"
      "currency TEXT,"
      "comment TEXT,"
      "itemType TEXT,"
      "description TEXT,"
      "parentLevel TEXT,"
      "image TEXT,"
      "show INTEGER"
      ")",
    );
    await database.execute(
      "CREATE TABLE tbBill("
      "orderId INTEGER PRIMARY KEY,"
      "orderNo TEXT,"
      "tableId INTEGER,"
      "receiptNo TEXT,"
      "queueNo TEXT,"
      "dateIn DATETIME,"
      "dateOut DATETIME,"
      "timeIn TEXT,"
      "timeOut TEXT,"
      "waiterId INTEGER,"
      "userOrderId INTEGER,"
      "userDiscountId INTEGER,"
      "customerId INTEGER,"
      "customerCount INTEGER,"
      "priceListId INTEGER,"
      "localCurrencyId INTEGER,"
      "sysCurrencyId INTEGER,"
      "exchangeRate REAL,"
      "warehouseId INTEGER,"
      "branchId INTEGER,"
      "companyId INTEGER,"
      "subTotal REAL,"
      "discountRate REAL,"
      "discountValue REAL,"
      "typeDis TEXT,"
      "taxRate REAL,"
      "taxValue REAL,"
      "grandTotal REAL,"
      "grandTotalSys REAL,"
      "tip REAL,"
      "received REAL,"
      "change REAL,"
      "currencyDisplay TEXT,"
      "displayRate REAL,"
      "grandTotalDisplay REAL,"
      "changeDisplay REAL,"
      "paymentMeansId INTEGER,"
      "checkBill TEXT,"
      "cancel BIT,"
      "[delete] BIT,"
      "paymentType TEXT,"
      "receivedType TEXT,"
      "credit REAL"
      ")",
    );
    await database.execute(
      "CREATE TABLE tbBillDetail ("
      "orderDetailId INTEGER PRIMARY KEY,"
      "orderId INTEGER,"
      "lineId INTEGER,"
      "itemId INTEGER,"
      "code TEXT,"
      "khmerName TEXT,"
      "englishName TEXT,"
      "qty REAL,"
      "printQty REAL,"
      "unitPrice REAL,"
      "cost REAL,"
      "discountRate REAL,"
      "discountValue REAL,"
      "typeDis TEXT,"
      "total REAL,"
      "totalSys REAL,"
      "uomId INTEGER,"
      "uomName TEXT,"
      "itemStatus TEXT,"
      "itemPrintTo TEXT,"
      "currency TEXT,"
      "comment TEXT,"
      "itemType TEXT,"
      "description TEXT,"
      "parentLevel TEXT,"
      "image TEXT,"
      "show INTEGER"
      ")",
    );
  }
}
