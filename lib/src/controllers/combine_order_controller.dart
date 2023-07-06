import 'dart:convert';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:point_of_sale/src/ManageLocalData/constant_ip.dart';
import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:point_of_sale/src/models/combine_order_model.dart';
import 'package:point_of_sale/src/models/order_to_combine.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CombineOrderController {
  static Future<List<OrderToCombine>> getOrderToCombine(
      String ip, int orderId) async {
    bool _connection = await DataConnectionChecker().hasConnection;
    var _pref = await SharedPreferences.getInstance();
    var token = _pref.getString("token");
    var url = ip + Config.orderTocombine + "/$orderId";
    print("url : $url");
    var respone = await http.post(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "Bearer " + token
    });
    if (_connection) {
      try {
        if (respone.statusCode == 200) {
          return orderToCombineFromJson(respone.body);
        }
      } catch (e) {
        print(e);
      }
    } else {
      print("No Internel!");
    }

    return orderToCombineFromJson(respone.body);
  }

  static Future<CombineOrder> postCombineOrder(
      String ip, CombineOrder combineOrder) async {
    var _pref = await SharedPreferences.getInstance();
    var token = _pref.getString("token");
    var url = ip + Config.combineOrder;
    print(jsonEncode(combineOrder.toJson()));
    print(url);
    var respone = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer " + token
      },
      body: jsonEncode(combineOrder.toJson()),
    );
    print(respone.statusCode);
    try {
      if (respone.statusCode == 200) {
        CombineOrder order = CombineOrder.fromJson(jsonDecode(respone.body));
        print(order);
        return CombineOrder.fromJson(jsonDecode(respone.body));
      }
    } catch (e) {
      print(e);
    }
    return CombineOrder.fromJson(jsonDecode(respone.body));
  }
}
