import 'dart:convert';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:point_of_sale/src/controllers/setting_controller.dart';
import 'package:point_of_sale/src/models/fetch_oreder_model.dart';
import 'package:point_of_sale/src/models/item_modal.dart';
import 'package:point_of_sale/src/models/order_detail_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScanBarcodeController {
  static Future<List<ItemMaster>> searchItemByBarcode(
      String barcode, String ip) async {
    try {
      bool result = await DataConnectionChecker().hasConnection;
      var setting;
      if (!result) {
        setting = await SettingController().selectSetting();
      } else {
        setting = await SettingController.getSetting(ip);
      }
      var url = ip +
          Config.searchItemByBarcode +
          '/${setting.first.priceListId}/$barcode';
      var response = await http.get(Uri.parse(url));
      List<ItemMaster> itemMasterList = [];
      if (response.statusCode == 200) {
        var jsonList = json.decode(response.body) as List;
        jsonList.map((e) {
          itemMasterList.add(ItemMaster.fromJson(e));
        }).toList();
      }
      return itemMasterList;
    } catch (e) {
      print('Error = $e');
      return throw Exception('Invalid Exeption.');
    }
  }

  static Future<OrderDetailModel> searchByBarcode(
      String ip, int orderId, int priceListId, String barCode) async {
    var _pref = await SharedPreferences.getInstance();
    var token = _pref.getString("token");
    var url = ip +
        Config.searchByBarcode +
        "/$orderId" +
        "/$priceListId" +
        "/$barCode";
    var respone = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer " + token,
      },
    );
    try {
      if (respone.statusCode == 200) {
        return OrderDetailModel.fromJson(jsonDecode(respone.body));
      }
    } catch (e) {
      print(e);
    }
    return OrderDetailModel.fromJson(jsonDecode(respone.body));
  }
}
