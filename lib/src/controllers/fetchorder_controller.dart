import 'dart:convert';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:point_of_sale/src/models/fetch_oreder_model.dart';
//import 'dart:developer' as dev;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FetchOrderController {
  Future<FetchOrderModel> getFetchOrder(
    String ip,
    int tableId,
    int orderId,
    int customerId,
    bool defualtOrder,
  ) async {
    bool _connection = await DataConnectionChecker().hasConnection;
    var _pref = await SharedPreferences.getInstance();
    if (_connection) {
      var token = _pref.getString("token");
      var url = ip +
          Config.fetchOrder +
          "/$tableId" +
          "/$orderId" +
          "/$customerId" +
          "/$defualtOrder";

      print("url $url");
      print("IP $ip");
      var respone = await http.post(Uri.parse(url), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer " + token
      });
      //  dev.log('FetchOrder:${respone.body}');
      print("this is token :${token}");
      if (respone.statusCode == 200) {
        String jsonString = respone.body;
        FetchOrderModel fetchOrderModel =
            FetchOrderModel.fromJson(jsonDecode(jsonString));
        Order order = fetchOrderModel.order;
        for (var temp in order.orderDetail) {
          print("show item orded : ${temp.khmerName}");
        }
        return FetchOrderModel.fromJson(jsonDecode(jsonString));
      } else {
        return throw Exception("No data");
      }
    } else {
      return throw Exception('No internet !');
    }
  }
}
