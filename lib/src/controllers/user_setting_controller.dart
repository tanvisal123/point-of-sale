import 'dart:convert';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:point_of_sale/src/models/user_setting_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserSettingController {
  Future<UserSettingModel> getUserSetting(String ip) async {
    bool _connection = await DataConnectionChecker().hasConnection;
    if (_connection) {
      var _pref = await SharedPreferences.getInstance();
      var token = _pref.getString("token");
      var url = ip + Config.getUserSetting;
      print("url : $url");
      var response = await http.post(Uri.parse(url), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer " + token,
      });
      if (response.statusCode == 200) {
        return UserSettingModel.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } else {
      return throw Exception('No internet !');
    }
  }
}
