import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:point_of_sale/src/models/reprint_receipt_model.dart';
import 'package:point_of_sale/src/models/reprint_receipt_temple_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ReprintReceiptController {
  Future<List<ReprintReceiptTample>> getReceiptToReprint(
      String ip, String dateFrom, String dateTo) async {
    var _pref = await SharedPreferences.getInstance();
    var token = _pref.getString("token");
    var url = ip + Config.receiptToReprint + "/$dateFrom" + "/$dateTo";
    print("url : $url");
    var respone = await http.post(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "Bearer " + token,
    });
    try {
      if (respone.statusCode == 200) {
        return reprintReceiptTampleFromJson(respone.body);
      }
    } catch (e) {
      print(e);
    }
    return reprintReceiptTampleFromJson(respone.body);
  }

  Future<List<ReprintReceiptModel>> getReprintReceipt(
      String ip, int receiptNo, String printType) async {
    var _pref = await SharedPreferences.getInstance();
    var token = _pref.getString("token");
    var url = ip + Config.reprintReceipt + "/$receiptNo" + "/$printType";
    print("url : $url");
    var respone = await http.post(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "Bearer " + token
    });
    try {
      if (respone.statusCode == 200) {
        List<ReprintReceiptModel> list =
            reprintReceiptModelFromJson(respone.body);
        for (var temp in list) {
          print(temp.branchName);
        }
        return reprintReceiptModelFromJson(respone.body);
      }
    } catch (e) {
      print(e);
    }
    return reprintReceiptModelFromJson(respone.body);
  }
}
