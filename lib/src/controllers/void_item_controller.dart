import 'dart:convert';

import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/fetch_oreder_model.dart';

class VoidItemController {
  Future<bool> postVoidItem(String ip, Order order) async {
    var _prfre = await SharedPreferences.getInstance();
    var token = _prfre.getString("token");
    var url = ip + Config.voidItem;
    var respon = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer " + token,
      },
      body: jsonEncode(order.toJson()),
    );
    try {
      if (respon.statusCode == 200) {
        print("respone : true ");
      } else {
        print("No data");
      }
    } catch (e) {
      print("error data : ${e.toString()}");
    }
    return true;
  }
}
