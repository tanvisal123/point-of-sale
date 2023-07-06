import 'dart:convert';

import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:point_of_sale/src/models/getchangerate_template.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GetChangeRateTemplateController {
  Future<List<GetChangeRateTemplate>> getChangeRatetemplate(
      String ip, int orderId) async {
    var _pref = await SharedPreferences.getInstance();
    var token = _pref.getString("token");
    var url = ip + Config.getChangeRateTemplate + "/$orderId";
    print("getChangeRate:" + url);
    var respon = await http.post(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "Bearer " + token
    });

    try {
      if (respon.statusCode == 200) {
        return getChangeRateTemplateFromJson(respon.body);
      }
    } catch (e) {
      print(e);
    }
    return getChangeRateTemplateFromJson(respon.body);
  }
}
