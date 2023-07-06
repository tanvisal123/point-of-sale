import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:point_of_sale/src/helpers/repositorys.dart';
import 'package:point_of_sale/src/models/receipt_information.dart';

class ReceiptInformationController {
  Repository _repository;
  ReceiptInformationController() {
    _repository = Repository();
  }

  static Future<List<ReceiptInformation>> eachRI(String ip) async {
    var url = ip + Config.receiptInfo;
    var response = await http.get(Uri.parse(url));
    var resList = json.decode(response.body) as List;
    List<ReceiptInformation> receiptList = [];
    resList.map((items) {
      return receiptList.add(ReceiptInformation.fromJson(items));
    }).toList();
    return receiptList;
  }

  insertReceipt(ReceiptInformation res) async {
    return await _repository.insertData('tbReceipt', res.toMap());
  }

  updateReceipt(ReceiptInformation res, int id) async {
    return await _repository.updateData('tbReceipt', res.toMap(), id);
  }

  Future<List<ReceiptInformation>> hasReceipt(int id) async {
    var res = await _repository.selectDataById('tbReceipt', id) as List;
    List<ReceiptInformation> reList = [];
    res.map((e) {
      return reList.add(ReceiptInformation.fromJson(e));
    }).toList();
    return reList;
  }

  Future<List<ReceiptInformation>> getReceipt() async {
    var res = await _repository.selectData('tbReceipt') as List;
    List<ReceiptInformation> reList = [];
    res.map((e) {
      return reList.add(ReceiptInformation.fromJson(e));
    }).toList();
    return reList;
  }
}
