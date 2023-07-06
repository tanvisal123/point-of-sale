import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:point_of_sale/src/models/shift_template_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShiftTemplateController {
  static Future<ShiftTemplateModel> getShiftTemplate(String ip) async {
    var _pref = await SharedPreferences.getInstance();
    var token = _pref.getString("token");
    var url = ip + Config.getShiftTemplate;
    var response = await http.post(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "Bearer " + token,
    });
    if (response.statusCode == 200) {
      var jsonString = json.decode(response.body);
      return ShiftTemplateModel.fromJson(jsonString);
    } else {
      return throw Exception('Failed to shift template');
    }
  }
}
