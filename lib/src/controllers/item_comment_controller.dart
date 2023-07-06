import 'dart:convert';

import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:point_of_sale/src/models/delete_item_comment.dart';
import 'package:point_of_sale/src/models/item_comment_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ItemCommentController {
  Future<List<ItemCommentModel>> getItemComment(String ip) async {
    var _pref = await SharedPreferences.getInstance();
    var token = _pref.getString("token");
    var url = ip + Config.getItemComment;
    var respone = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer " + token
      },
    );
    if (respone.statusCode == 200) {
      return itemCommentModelFromJson(respone.body);
    } else {
      return null;
    }
  }

  Future<void> saveItemComment(String ip, ItemCommentModel itemComment) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var url = ip + Config.saveItemComment;
    print('Controller saved:$url');
    var respon = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "Bearer " + token
        },
        body: jsonEncode(itemComment.toJson()));
    try {
      if (respon.statusCode == 200) {
        return respon.body;
      }
    } catch (e) {
      print(e.toString());
    }
    return respon.body;
  }

  Future<DeleteItemComment> deleteItemComment(String ip, int id) async {
    var _pref = await SharedPreferences.getInstance();
    var token = _pref.getString("token");
    var url = ip + Config.deleteItemComment + "/$id";
    var respone = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer " + token
      },
    );
    if (respone.statusCode == 200) {
      return deleteItemCommentFromJson(respone.body);
    } else {
      return null;
    }
  }
}
