import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:point_of_sale/src/models/warehouse_modal.dart';

class WarehouseController {
  static Future<List<Warehouse>> eachWarehouse(String ip) async {
    var url = ip + Config.warehouseUrl;
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var wareList = json.decode(response.body) as List;
      List<Warehouse> item = [];
      wareList.map((items) {
        return item.add(Warehouse.fromJson(items));
      }).toList();
      return item;
    } else {
      return throw Exception('Failed to load price list');
    }
  }
}
