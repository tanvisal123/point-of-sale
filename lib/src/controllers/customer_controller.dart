import 'dart:convert';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:http/http.dart' as http;
import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:point_of_sale/src/models/customer_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerController {
  static Future<List<Customer>> getCustomer(String ip) async {
    var url = ip + Config.customerUrl + "/${0}";
    bool _connection = await DataConnectionChecker().hasConnection;
    if (_connection) {
      var _pref = await SharedPreferences.getInstance();
      var token = _pref.getString("token");
      var response = await http.post(Uri.parse(url), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer " + token
      });
      print('Uri : $url');
      print('Customer Response : ${response.body}');
      if (response.statusCode == 200) {
        return customerFromJson(response.body);
      } else {
        return null;
      }
    } else {
      return throw Exception('No internet !');
    }
  }
}
