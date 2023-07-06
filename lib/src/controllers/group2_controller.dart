import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:point_of_sale/src/helpers/repositorys.dart';
import 'package:point_of_sale/src/models/gorupItem_modal.dart';

class Group2Controller {
  Repository _repository;
  Group2Controller() {
    _repository = Repository();
  }
  static Future<List<GroupItemModel>> eachGroup2(
      int group1Id, String ip) async {
    var url = ip + Config.getGroup2 + "?g1Id=$group1Id";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var responseGroup2List = json.decode(response.body) as List;
      List<GroupItemModel> tempGorup2 = [];
      responseGroup2List.map((gorup) {
        return tempGorup2.add(GroupItemModel.fromJson(gorup));
      }).toList();
      return tempGorup2;
    } else {
      return throw Exception('Failed to load group2');
    }
  }

  static Future<List<GroupItemModel>> eachGroup2Local(String ip) async {
    var url = ip + Config.getG2Local;
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var responseGroup2List = json.decode(response.body) as List;
      List<GroupItemModel> tempGorup2 = [];
      responseGroup2List.map((gorup) {
        return tempGorup2.add(GroupItemModel.fromJson(gorup));
      }).toList();
      return tempGorup2;
    } else {
      return throw Exception('Failed to load group2');
    }
  }

  insertGroup2(GroupItemModel item) async {
    return await _repository.insertData('tbGroup2', item.toJson());
  }

  updateGroup2(GroupItemModel item, int g2Id) async {
    return await _repository.updateGroup2("tbGroup2", item.toJson(), g2Id);
  }

  Future<List<GroupItemModel>> hasGroup2(int g2Id) async {
    var res = await _repository.selectGroup2ById("tbGroup2", g2Id) as List;
    List<GroupItemModel> tempGorup2 = [];
    res.map((gorup) {
      return tempGorup2.add(GroupItemModel.fromJson(gorup));
    }).toList();
    return tempGorup2;
  }

  Future<List<GroupItemModel>> getGroup2(int g1Id) async {
    var res = await _repository.selectGroup1ById('tbGroup2', g1Id) as List;
    List<GroupItemModel> tempGorup2 = [];
    res.map((gorup) {
      return tempGorup2.add(GroupItemModel.fromJson(gorup));
    }).toList();
    return tempGorup2;
  }
}
