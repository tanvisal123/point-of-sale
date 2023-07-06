import 'dart:convert';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/fetch_oreder_model.dart';

class OrderDetialController {
  Future<OrderDetailModel> getOrderDetail(
    String ip,
    int saleItemId,
    int orderId,
  ) async {
    var _pref = await SharedPreferences.getInstance();
    var url = ip + Config.getNewLineItem + "/$saleItemId" + "/$orderId";
    bool _connection = await DataConnectionChecker().hasConnection;
    if (_connection) {
      var token = _pref.getString("token");
      var response = await http.post(Uri.parse(url), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer " + token,
      });
      if (response.statusCode == 200) {
        return OrderDetailModel.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } else {
      return throw Exception('No internet !');
    }
  }
}
