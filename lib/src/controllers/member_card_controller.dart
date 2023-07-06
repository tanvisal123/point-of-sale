import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:point_of_sale/src/models/member_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemberCardController {
  static Future<List<MemberCard>> eachMember() async {
    var _sp = await SharedPreferences.getInstance();
    var _ip = _sp.getString('ip');
    var url = _ip + Config.urlMember;
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var memberList = json.decode(response.body) as List;
      List<MemberCard> item = [];
      memberList.map((items) {
        return item.add(MemberCard.fromJson(items));
      }).toList();
      return item;
    } else {
      return throw Exception('Failed to load member card');
    }
  }

  static Future<List<MemberCard>> searchMember(String name, String ip) async {
    var url = ip + Config.searchMember + "?name=$name";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var memberList = json.decode(response.body) as List;
      List<MemberCard> item = [];
      memberList.map((items) {
        return item.add(MemberCard.fromJson(items));
      }).toList();
      return item;
    } else {
      return throw Exception('Failed to load search member card');
    }
  }
}
