import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:point_of_sale/src/models/receipt_to_cancel_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ReceiptToCancelController {
  static Future<List<ReceiptToCancelModel>> getReceiptToCancel(
      String ip, String dfrom, String dTo) async {
    var _pref = await SharedPreferences.getInstance();
    var token = _pref.getString("token");
    var url = ip + Config.getReceiptToCancel + "/$dfrom" + "/$dTo";
    print(url);
    List<ReceiptToCancelModel> list = [];
    var respone = await http.post(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "Bearer " + token,
    });
    try {
      if (respone.statusCode == 200) {
        list = receiptToCancelFromJson(respone.body);
        print("receipt : ${list.first.receiptNo}");
        return receiptToCancelFromJson(respone.body);
      } else {
        print("error");
      }
    } catch (e) {
      print(e);
    }
    return receiptToCancelFromJson(respone.body);
  }

  static Future<CancelReceiptModel> getcancelReceipt(
      String ip, int receiptId) async {
    var _pref = await SharedPreferences.getInstance();
    var token = _pref.getString("token");
    var url = ip + Config.cancelReceipt + "/$receiptId";
    var respone = await http.post(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "Bearer " + token
    });
    try {
      return cencelReceiptSuccessFromJson(respone.body);
    } catch (e) {
      print(e);
    }
    return cencelReceiptSuccessFromJson(respone.body);
  }
}
