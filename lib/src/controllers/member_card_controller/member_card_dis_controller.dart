import 'package:point_of_sale/src/models/member_card_discount.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../constants/api_config.dart';

class MemberCardDisController {
  Future<MemberCardDiscount> getMemberCardDiscount(
      String ip, String cardNumber, int pId) async {
    var _pref = await SharedPreferences.getInstance();
    var token = _pref.getString("token");
    var url = ip + Config.getMemberCardDiscount + "/$cardNumber" + "/$pId";
    print("url : $url");

    var respone = await http.post(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': token
    });
    try {
      print("statue code : ${respone.statusCode}");
      if (respone.statusCode == 200) {
        //print(respone.body);
        return memberCardDiscountFromJson(respone.body);
      }
    } catch (e) {
      print("error : $e");
    }
    return memberCardDiscountFromJson(respone.body);
  }

  Future<MemberCardDiscount> getCardMemberDetail(
      String ip, String cardNumber, double grandTotal, int pId) async {
    var _pref = await SharedPreferences.getInstance();
    var token = _pref.getString("token");
    var url = ip +
        Config.getCardMemberDetail +
        "/$cardNumber" +
        "/$grandTotal" +
        "/$pId";
    print("url : $url");
    var respone = await http.post(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': token
    });
    try {
      print("statue code : ${respone.statusCode}");
      if (respone.statusCode == 200) {
        //print(respone.body);
        return memberCardDiscountFromJson(respone.body);
      }
    } catch (e) {
      print("error : $e");
    }
    return memberCardDiscountFromJson(respone.body);
  }
}
