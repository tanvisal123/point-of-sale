import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:point_of_sale/src/controllers/setting_controller.dart';
import 'package:point_of_sale/src/models/local_currency.dart';

class CurrencyController {
  static Future<LocalCurrency> getLocalCurrency(int userId, String ip) async {
    var settingList = await SettingController.getSetting(ip);
    var url;
    if (settingList.length > 0) {
      url = ip +
          Config.urlLocalCurrency +
          '/${settingList.first.localCurrencyId}';
    }
    print('Local Curr = $url');
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return LocalCurrency.fromJson(data);
    } else {
      return throw Exception('Failed to load local currency');
    }
  }

  static Future<LocalCurrency> getSysCurrency(String ip) async {
    final url = ip + Config.urlSysCurrency;
    print('Sysstem Curr = $url');
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return LocalCurrency.fromJson(data);
    } else {
      return throw Exception('Failed to load system currency');
    }
  }
}
