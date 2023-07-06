import 'dart:convert';

import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:point_of_sale/src/models/return_receipt_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ReturnReceiptController {
  static Future<List<ReturnReceiptModel>> getReceiptToReturn(
      String ip, String dF, String dTo) async {
    var _pref = await SharedPreferences.getInstance();
    var token = _pref.getString("token");
    var url = ip + Config.returnReceipt + "/$dF" + "/$dTo";
    print(url);
    var respone = await http.post(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "Bearer " + token,
    });
    try {
      if (respone.statusCode == 200) {
        return returnReceiptModelFromJson(respone.body);
      } else {
        print("error");
      }
    } catch (e) {
      print(e);
    }
    return returnReceiptModelFromJson(respone.body);
  }

  static Future<ReturnItemComplate> getItemToReturn(
      String ip, List<ReturnItem> list) async {
    var _pref = await SharedPreferences.getInstance();
    var token = _pref.getString("token");
    var url = ip + Config.getReturnItem;
    try {
      var response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': "Bearer " + token
          },
          body: jsonEncode(list));
      if (response.statusCode == 200) {
        ReturnItemComplate returnItemComplate =
            returnComplateFromJson(response.body);
        print(returnItemComplate.data.receipt);
        return returnComplateFromJson(response.body);
      }
    } catch (e) {}
    return null;
  }
}
