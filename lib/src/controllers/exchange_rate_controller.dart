import 'dart:convert';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:point_of_sale/src/models/exchange_rate_modal.dart';

class ExchangeRateController {
  static Future<ExchangRate> eachExchange(String ip) async {
    var userId = await FlutterSession().get("userId");
    var url = ip + Config.urlExchange + '/$userId';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      ExchangRate ex = ExchangRate.fromJson(res);
      return ex;
    } else {
      return throw Exception('Failed to exchange');
    }
  }
}
