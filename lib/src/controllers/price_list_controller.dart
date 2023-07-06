import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:point_of_sale/src/models/price_list_modal.dart';

class PriceListController {
  static Future<List<PriceList>> eachPriceList(String ip) async {
    var url = ip + Config.priceListUrl;
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var priceList = json.decode(response.body) as List;
      List<PriceList> item = [];
      priceList.map(
        (items) {
          return item.add(PriceList.fromJson(items));
        },
      ).toList();
      return item;
    } else {
      return throw Exception('Failed to load price list');
    }
  }
}
