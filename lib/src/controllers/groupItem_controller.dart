import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:point_of_sale/src/models/fetch_oreder_model.dart';
import 'package:point_of_sale/src/models/group_item_model.dart';
import 'package:point_of_sale/src/models/item_modal.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_config.dart';
import 'package:http/http.dart' as http;

class GroupItemController {
  Future<List<SaleItems>> getGroupItem(
    String ip,
    int g1,
    int g2,
    int g3,
    int pId,
    int level,
  ) async {
    bool _connection = await DataConnectionChecker().hasConnection;
    if (_connection) {
      var _pref = await SharedPreferences.getInstance();
      var token = _pref.getString("token");
      var url = ip +
          Config.getItemByGroup +
          "/$g1" +
          "/$g2" +
          "/$g3" +
          "/$pId" +
          "/$level" +
          "/false";
      print("url : $url");
      var respone = await http.post(Uri.parse(url), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer " + token
      });
      print("group1: $g1");
      print("group2: $g2");
      print("group3: $g3");
      print("pID: $pId");
      print("level: $level");
      if (respone.statusCode == 200) {
        String jsonString = respone.body;
        print("body 1 respone : $jsonString");

        return saleItemFromJson(jsonString);
      } else {
        return throw Exception("No data");
      }
    } else {
      return throw Exception('No internet !');
    }
  }

  static Future<List<SaleItems>> searchItems(
      String ip, int orderId, String itemName) async {
    bool _connection = await DataConnectionChecker().hasConnection;
    var _pref = await SharedPreferences.getInstance();
    var token = _pref.getString("token");
    var url = ip + Config.searchItem + "/$orderId" + "/$itemName";
    var respone = await http.post(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "Bearer " + token
    });
    if (_connection) {
      try {
        print("ip : $ip");
        print("orderId : $orderId");
        print("Item name: $itemName");
        print("respone : ${respone.statusCode}");
        print("url : $url");
        if (respone.statusCode == 200) {
          String jsonString = respone.body;
          print("item respone: $jsonString");
          List<SaleItems> saleItem = saleItemFromJson(jsonString);
          print("item search : ${saleItem.first.khmerName}");
          return saleItemFromJson(jsonString);
        } else {
          return throw Exception("No data");
        }
      } catch (e) {
        print("error ${e.toString()}");
      }
    } else {
      return throw Exception('No internet !');
    }
    return saleItemFromJson(respone.body);
  }
}
