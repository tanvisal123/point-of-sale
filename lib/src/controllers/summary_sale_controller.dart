import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:point_of_sale/src/models/summary_sale_model.dart';
import 'package:point_of_sale/src/models/summary_salereceipt_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SummarySaleController {
  static Future<List<SummarySaleModel>> getSummarySale(
      String dateF,
      String dateT,
      String timeF,
      String timeT,
      int branchId,
      int userId,
      String douType,
      String ip) async {
    var url = ip +
        Config.getSummarySale +
        "/$dateF/$dateT/$timeF/$timeT/$branchId/$userId/$douType";
    var response = await http.get(Uri.parse(url));
    print('URL = $url');
    if (response.statusCode == 200) {
      var resList = json.decode(response.body) as List;
      List<SummarySaleModel> summarySaleList = [];
      resList
          .map((e) => summarySaleList.add(SummarySaleModel.fromJson(e)))
          .toList();
      return summarySaleList;
    } else {
      return throw Exception('Failed to receipt');
    }
  }

  static Future<List<SummarySalesModel>> getSummarySalesReceipt(
      String datefrom, String dateto, String ip) async {
    var url = ip + Config.getSummarySalesReceipt + "/$datefrom" + "/$dateto";
    var _pref = await SharedPreferences.getInstance();
    var token = _pref.getString("token");
    var respon = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer " + token
      },
    );

    print('getSummarySalesReceipt : $url');
    if (respon.statusCode == 200) {
      return summarySalesModelFromJson(respon.body);
    }
    return summarySalesModelFromJson(respon.body);
  }
}
