import 'dart:convert';

import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:point_of_sale/src/models/fetch_oreder_model.dart';
import 'package:point_of_sale/src/models/pending_void_item_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PendingVoidItemController {
  static Future<bool> pendingVoidItem(String ip, Order order) async {
    var _pref = await SharedPreferences.getInstance();
    var token = _pref.getString("token");
    var url = ip + Config.pendingVoidItem;
    print(order.toJson());
    var respone = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer " + token,
      },
      body: jsonEncode(order.toJson()),
    );
    try {
      if (respone.statusCode == 200) {
        print("true");
        return true;
      }
    } catch (e) {
      print(e);
    }
    return true;
  }

  static Future<List<PendingVoidItemModel>> getPandingVoidItem(
      String ip, String dateFrom, String dateTo) async {
    var url =
        ip + Config.getPendingVoidItem + "/" + '$dateFrom' + "/" + '$dateTo';
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    print('PendingURL:$url');
    var respon = await http.post(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "Bearer " + token
    });
    try {
      if (respon.statusCode == 200) {
        return pendingVoidItemModelFromJson(respon.body);
      }
    } catch (e) {
      print(e.toString());
    }
    return pendingVoidItemModelFromJson(respon.body);
  }

  Future<void> submitPendingitemController(
      String ip, List<PendingVoidItemModel> list, String reason) async {
    var _prefs = await SharedPreferences.getInstance();
    var token = _prefs.getString('token');
    var url = ip + Config.submitPendingVoidItem + '/' + '$reason';
    var respon = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "Bearer " + token
        },
        body: pendingVoidItemModelToJson(list));
    try {
      if (respon.statusCode == 200) {
        print('respon true');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deletePendingitemCotroller(String ip, int id) async {
    var _prefs = await SharedPreferences.getInstance();
    var token = _prefs.getString('token');
    var url = ip + Config.deletePendingVoidItem + "/" + "$id";
    var respon = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer " + token
      },
    );
    try {
      if (respon.statusCode == 200) {
        print('status : true');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
