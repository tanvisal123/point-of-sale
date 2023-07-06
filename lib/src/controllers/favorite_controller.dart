import 'dart:convert';
import 'package:point_of_sale/src/controllers/sale_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteController {
  static Future<List<int>> read() async {
    List<int> lists = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var favorites = (prefs.getString('favorite') ?? '');
    if (favorites != '') {
      var favouriteList = json.decode(favorites) as List;
      lists = favouriteList.map((id) => int.parse(id.toString())).toList();
    }
    return lists;
  }

  static void save(int id) async {
    List<int> lists = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    lists = await read().then((result) {
      return result;
    });
    lists.add(id);
    await prefs.setString("favorite", json.encode(lists));
  }

  static void remove(int id) async {
    List<int> lists = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    lists = await read().then((result) {
      return result;
    });
    lists.remove(id);
    await prefs.setString("favorite", json.encode(lists));
  }

  static Future<bool> isFavorite(int id) async {
    bool isfavorite = false;
    List<int> lists = [];
    // ignore: unused_local_variable
    SharedPreferences prefs = await SharedPreferences.getInstance();
    lists = await read().then((result) {
      return result;
    });
    if (lists.indexOf(id) >= 0) {
      isfavorite = true;
    }
    return isfavorite;
  }

  static void removeAll(String name) async {
    List<int> lists = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    lists = await read().then((result) {
      return result;
    });
    lists.forEach((element) {
      SaleController().deleteOrder(element);
    });
    prefs.remove(name);
  }
}
