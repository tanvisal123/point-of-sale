import 'dart:convert';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:point_of_sale/src/models/receip_detail.dart';
import 'package:point_of_sale/src/models/receipt_model.dart';
import 'package:point_of_sale/src/models/return_receipt_modal.dart';
import 'package:point_of_sale/src/models/series_model.dart';
import 'package:point_of_sale/src/models/table_ordered.dart';

class ReceiptController {
  //-- modify
  static Future<TableOrdered> getTableOrdered(int tableId, String ip) async {
    var url = ip + Config.getTableOrdered + '/$tableId';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonString = json.decode(response.body);
      return TableOrdered.fromJson(jsonString);
    } else {
      return throw Exception('Failed to getSeries');
    }
  }

  static Future<SeriesModel> getSeries(String ip) async {
    var url = ip + Config.getSeries;
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonString = json.decode(response.body);
      return SeriesModel.fromJson(jsonString);
    } else {
      return throw Exception('Failed to getSeries');
    }
  }

  static Future<List<ReceiptModel>> getReceipt(
      String dateF, String dateT, String ip) async {
    var url = ip + Config.receipt + "/$dateF" + "/$dateT";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var resList = json.decode(response.body) as List;
      List<ReceiptModel> receiptList = [];
      resList.map((e) => receiptList.add(ReceiptModel.fromJson(e))).toList();
      return receiptList;
    } else {
      return throw Exception('Failed to receipt');
    }
  }
  //----

  static Future<List<ReceiptModel>> eatchReceipt(
      int page, int index, String ip) async {
    var url = ip + Config.receipt + "?page=$page" + "&index=$index";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var resList = json.decode(response.body) as List;
      List<ReceiptModel> lsRe = [];
      resList.map((e) => lsRe.add(ReceiptModel.fromJson(e))).toList();
      return lsRe;
    } else {
      return throw Exception('Failed to receipt');
    }
  }

  static Future<List<ReceiptDetail>> eatchReceiptDetail(
      int receiptId, String ip) async {
    var url = ip + Config.receiptDetail + '/$receiptId';
    var response = await http.get(Uri.parse(url));
    var resList = json.decode(response.body) as List;
    List<ReceiptDetail> lsRe = [];
    resList.map((items) {
      return lsRe.add(ReceiptDetail.fromJson(items));
    }).toList();
    return lsRe;
  }

  static const int PAGE = 10;
  static Future<dynamic> getCancelReceipt(
      String dateFrom, String dateTo, int index, String ip) async {
    try {
      var branchId = await FlutterSession().get('branchId');
      var url = ip +
          Config.getCancelReceipt +
          '/$branchId/$dateFrom/$dateTo/$PAGE/$index';
      print('URL = $url');
      return await http.get(Uri.parse(url));
    } catch (e) {
      print('Cancel Error = $e');
      return e.toString();
    }
  }

  static Future<List<ReturnReceipts>> eatchReturnReceipt(
      String dateFrom, String dateTo, int page, int index, String ip) async {
    dynamic branchId = FlutterSession().get("branchId");
    var url = ip +
        Config.receipt +
        "?branchId=$branchId" +
        "&dateFrom=$dateFrom" +
        "&dateTo=$dateTo" +
        "&page=$page" +
        "&index=$index";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var resList = json.decode(response.body) as List;
      List<ReturnReceipts> lsRe = [];
      resList.map((e) => lsRe.add(ReturnReceipts.fromJson(e))).toList();
      return lsRe;
    } else {
      return throw Exception('Failed to receipt');
    }
  }
}
