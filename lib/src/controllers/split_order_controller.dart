import 'dart:convert';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:point_of_sale/src/models/fetch_oreder_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SplitOrderController {
  static Future<Order> splitOrder(String ip, Order order) async {
    bool _connection = await DataConnectionChecker().hasConnection;
    var _pref = await SharedPreferences.getInstance();
    var token = _pref.getString("token");
    var url = ip + Config.splitOrder;
    print(url);
    var respone = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "Bearer " + token,
        },
        body: jsonEncode(order));
    print("order : ${jsonEncode(order)}");
    if (_connection) {
      try {
        print("status : ${respone.statusCode}");
        if (respone.statusCode == 200) {
          Order order = Order.fromJson(jsonDecode(respone.body));
          print("order no ${order.orderNo}");
          return Order.fromJson(jsonDecode(respone.body));
        }
      } catch (e) {
        print(e);
      }
    } else {
      print("no internet");
    }
    return Order.fromJson(jsonDecode(respone.body));
  }
}
