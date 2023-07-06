import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:point_of_sale/src/models/getchangerate_template.dart';
import 'package:point_of_sale/src/models/save_display_currencies_model.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SaveDisplayCurrencisController {
  Future<SaveDisplayCurrencies> saveDisplaycurrencies(
      String ip, List<GetChangeRateTemplate> list) async {
    var _pref = await SharedPreferences.getInstance();
    var token = _pref.getString("token");
    var url = ip + Config.saveDisplayCurrencies;
    print("getChangeRate:" + url);
    var respon = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer " + token,
      },
      body: getChangeRateTemplateToJson(list),
    );

    try {
      if (respon.statusCode == 200) {
        return saveDisplayCurrenciesFromJson(respon.body);
      }
    } catch (e) {
      print(e);
    }
    return saveDisplayCurrenciesFromJson(respon.body);
  }
}
