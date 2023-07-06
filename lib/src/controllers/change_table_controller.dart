import 'dart:convert';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:point_of_sale/src/models/table_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ChangeTableController {
  static Future<TableModel> getTableChange(
      String ip, int fromtbId, int toTbId) async {
    bool _connection = await DataConnectionChecker().hasConnection;
    var _pref = await SharedPreferences.getInstance();
    var token = _pref.getString("token");
    var url = ip + Config.changeTable + "/$fromtbId" + "/$toTbId";
    print("url : $url");
    var respone = await http.post(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "Bearer " + token
    });
    if (_connection) {
      try {
        if (respone.statusCode == 200) {
          return TableModel.fromJson(jsonDecode(respone.body));
        }
      } catch (e) {
        print(e);
      }
    } else {
      print("No Internel!");
    }
    return TableModel.fromJson(jsonDecode(respone.body));
  }
}
