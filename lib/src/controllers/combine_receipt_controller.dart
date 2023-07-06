import 'dart:convert';

import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:point_of_sale/src/models/combine_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CombineReceiptController {
  static Future<List<CombineReceipt>> eachCombine(
      int orderId, String ip) async {
    dynamic branchId = await FlutterSession().get("branchId");
    var url = ip +
        Config.getReceiptCombine +
        "?branchId=$branchId" +
        "&orderId=$orderId";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var comList = json.decode(response.body) as List;
      List<CombineReceipt> item = [];
      comList.map((items) {
        return item.add(CombineReceipt.fromJson(items));
      }).toList();
      return item;
    } else {
      return throw Exception('Failed to load combine receipt');
    }
  }

  Future<String> postOrder(CombineReceipt receipt, String ip) async {
    final String url = ip + Config.postCombineReceipt;
    final response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(receipt.toJson()));

    if (response.statusCode == 200) {
      var res = response.body;
      return res;
    } else {
      return null;
    }
  }
}
