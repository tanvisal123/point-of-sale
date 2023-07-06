import 'dart:convert';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MoveOrderController {
  static Future<int> getMoveOrder(
      String ip, int fromTbId, int toTableId, int orderId) async {
    bool _connection = await DataConnectionChecker().hasConnection;
    var _pref = await SharedPreferences.getInstance();
    var token = _pref.getString("token");
    var url =
        ip + Config.moveOrder + "/$fromTbId" + "/$toTableId" + "/$orderId";
    print("url : $url");
    var respone = await http.post(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "Bearer " + token
    });
    if (_connection) {
      try {
        if (respone.statusCode == 200) {
          return orderId;
        }
      } catch (e) {
        print(e);
      }
    }
    return orderId;
  }
}
