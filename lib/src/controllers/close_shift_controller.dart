import 'dart:convert';
import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:point_of_sale/src/models/close_shift_model.dart';
import 'package:point_of_sale/src/models/reprint_close_shift_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/receipt_reprint_close_shift.dart';

class CloseShiftController {
  //  post close shift
  static Future<ProccesCloseShift> processCloseShift(
      double total, String ip) async {
    var _pref = await SharedPreferences.getInstance();
    var token = _pref.getString("token");
    var url = ip + Config.processCloseShift + "/$total";
    print(url);
    var respone = await http.post(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "Bearer " + token,
    });
    if (respone.statusCode == 200) {
      String jsonString = respone.body;

      return ProccesCloseShift.fromJson(jsonDecode(jsonString));
    } else {
      return null;
    }
  }

  Future<List<ReprintCloseShiftModel>> getReprintCloseShift(
      String ip, String dateFrom, String dateTo) async {
    var _pref = await SharedPreferences.getInstance();
    var token = _pref.getString("token");
    var url = ip + Config.getCloseShift + "/$dateFrom" + "/$dateTo";
    print("url : $url");
    var respone = await http.post(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "Bearer " + token,
    });
    try {
      if (respone.statusCode == 200) {
        return reprintCloseShiftFromJson(respone.body);
      }
    } catch (e) {
      print(e);
    }
    return reprintCloseShiftFromJson(respone.body);
  }

  Future<List<ReceiptReprintCloseShift>> receiptReprintCloseShift(
      String ip, int userId, int closeshiftId) async {
    var _pref = await SharedPreferences.getInstance();
    var token = _pref.getString("token");
    var url =
        ip + Config.receiptReprintCloseShift + "/$userId" + "/$closeshiftId";
    print(url);
    var respone = await http.post(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "Bearer " + token,
    });
    print("status code : ${respone.statusCode}");
    try {
      if (respone.statusCode == 200) {
        return receiptReprintCloseShiftFromJson(respone.body);
      }
    } catch (e) {
      print(e);
    }
    return receiptReprintCloseShiftFromJson(respone.body);
  }
}
