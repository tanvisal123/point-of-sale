import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:point_of_sale/src/models/display_currency_modal.dart';
import 'package:point_of_sale/src/models/receipt_model.dart';
import 'package:point_of_sale/src/models/gorupItem_modal.dart';
import 'package:sqflite/sqflite.dart';
import 'connection_database.dart';

class Repository {
  ConnectionDatabase _connectionDatabase;
  Repository() {
    _connectionDatabase = ConnectionDatabase();
  }
  static Database _database;
  Future<Database> get database async {
    //-----------------------------Run onlyone---------------------------------
    // Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // String path = join(documentsDirectory.path, "db_pos");
    // await deleteDatabase(path);
    // print("here");
    //---------------

    if (_database != null) return _database;
    _database = await _connectionDatabase.setDatabase();
    return _database;
  }

  //-----------Repository---------
  insertData(table, data) async {
    var _con = await database;
    return await _con.insert(table, data);
  }

  selectData(table) async {
    var _con = await database;
    return await _con.query(table);
  }

  selectDataById(table, int id) async {
    var con = await database;
    return await con.query(table, where: 'id = ?', whereArgs: [id]);
  }

  deleteData(table, id) async {
    var con = await database;
    return await con.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  deleteAllData(table) async {
    var con = await database;
    return await con.delete(table);
  }

  updateData(table, data, id) async {
    var con = await database;
    return await con.update(table, data, where: 'id = ?', whereArgs: [id]);
  }
  //-----------------------------------------------------------------------

  //----------------Order--------------------
  selectOrderDetailKey(table, lineId) async {
    var con = await database;
    return await con.query(table, where: 'lineId = ?', whereArgs: [lineId]);
  }

  selectOrderBill(table, build) async {
    var con = await database;
    return await con.query(table, where: 'checkBill = ?', whereArgs: [build]);
  }
  //--------------------------------------------------------------------------

  //----------------Bill-----------------
  selectFirstBill(table, orderId) async {
    var con = await database;
    return await con.query(table, where: 'orderId = ?', whereArgs: [orderId]);
  }

  selectBillDetail(table, orderId) async {
    var con = await database;
    return await con.query(table, where: 'orderId = ?', whereArgs: [orderId]);
  }

  updateBill(table, data, orderId) async {
    var con = await database;
    return await con.update(
      table,
      data,
      where: 'orderId = ?',
      whereArgs: [orderId],
    );
  }

  updateBillDetail(table, data, orderDetailId) async {
    var con = await database;
    return await con.update(
      table,
      data,
      where: 'orderDetailId = ?',
      whereArgs: [orderDetailId],
    );
  }
  //-------------------------------------------------------------

  //------------------Item----------------
  updateItem(table, data, int key) async {
    var con = await database;
    return await con.update(table, data, where: 'key = ?', whereArgs: [key]);
  }

  selectItemByKey(table, int key) async {
    var con = await database;
    return await con.query(table, where: 'key = ?', whereArgs: [key]);
  }

  selectItem(table, GroupItemModel group, int plId) async {
    var con = await database;
    if (group.g1Id != 0 && group.g2Id == 0 && group.g3Id == 0) {
      return await con.query(
        table,
        where: 'g1Id=? AND itemType=? AND priceListId=?',
        whereArgs: [group.g1Id, "Item", plId],
      );
    } else if (group.g1Id != 0 && group.g2Id != 0 && group.g3Id == 0) {
      return await con.query(
        table,
        where: 'g1Id=? AND g2Id=? AND itemType=? AND priceListId=?',
        whereArgs: [group.g1Id, group.g2Id, 'Item', plId],
      );
    } else if (group.g1Id != 0 && group.g2Id != 0 && group.g3Id != 0) {
      return await con.query(
        table,
        where: 'g1Id=? AND g2Id=? AND g3Id=? AND itemType=? AND priceListId=?',
        whereArgs: [group.g1Id, group.g2Id, group.g3Id, 'Item', plId],
      );
    }
  }
  //----------------------------------------------------------------------------

  //--------------Item Group1------------
  updateGroup1(table, data, g1Id) async {
    var con = await database;
    return await con.update(table, data, where: 'g1Id = ?', whereArgs: [g1Id]);
  }

  selectGroup1ById(table, int g1Id) async {
    var con = await database;
    return await con.query(table, where: 'g1Id=?', whereArgs: [g1Id]);
  }
  //-------------------------------------------------------------------

  //--------------Group2-----------------
  updateGroup2(table, data, g2Id) async {
    var con = await database;
    return await con.update(table, data, where: 'g2Id = ?', whereArgs: [g2Id]);
  }

  selectGroup2ById(table, int g2Id) async {
    var con = await database;
    return await con.query(table, where: 'g2Id = ?', whereArgs: [g2Id]);
  }
  //-------------------------------------------------------------------

  //----------------Group3---------------
  updateGroup3(table, data, g3Id) async {
    var con = await database;
    return await con.update(table, data, where: 'g3Id = ?', whereArgs: [g3Id]);
  }

  selectGroup3ById(table, int g3Id) async {
    var con = await database;
    return await con.query(table, where: 'g3Id = ?', whereArgs: [g3Id]);
  }

  selectGorup3(table, g1Id, g2Id) async {
    var con = await database;
    return await con.query(
      table,
      where: 'g1Id=? AND g2Id = ?',
      whereArgs: [g1Id, g2Id],
    );
  }
  //---------------------------
}
