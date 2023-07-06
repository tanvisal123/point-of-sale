import 'dart:convert';
import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:point_of_sale/src/helpers/repositorys.dart';
import 'package:point_of_sale/src/models/gorupItem_modal.dart';
import 'package:http/http.dart' as http;

class Group3Controller {
  Repository _repository;
  Group3Controller() {
    _repository = Repository();
  }
  static Future<List<GroupItemModel>> eachGroup3(
      int group1Id, int group2Id, String ip) async {
    var url = ip + Config.getGroup3 + "?g1Id=$group1Id" + "&g2Id=$group2Id";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var responseGroup3List = json.decode(response.body) as List;
      List<GroupItemModel> tempGorup3 = [];
      responseGroup3List.map((gorup) {
        return tempGorup3.add(GroupItemModel.fromJson(gorup));
      }).toList();
      return tempGorup3;
    } else {
      return throw Exception('Failed to load group3');
    }
  }

  static Future<List<GroupItemModel>> eachGroup3Local(String ip) async {
    var url = ip + Config.getG3Local;
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var responseGroup3List = json.decode(response.body) as List;
      List<GroupItemModel> tempGorup3 = [];
      responseGroup3List.map((gorup) {
        return tempGorup3.add(GroupItemModel.fromJson(gorup));
      }).toList();
      return tempGorup3;
    } else {
      return throw Exception('Failed to load group3');
    }
  }

  insertGroup3(GroupItemModel item) async {
    return await _repository.insertData('tbGroup3', item.toJson());
  }

  updateGorup3(GroupItemModel item, int g3Id) async {
    return await _repository.updateGroup3("tbGroup3", item.toJson(), g3Id);
  }

  Future<List<GroupItemModel>> hasGroup3(int g3Id) async {
    var res = await _repository.selectGroup3ById("tbGroup3", g3Id) as List;
    List<GroupItemModel> tempGorup3 = [];
    res.map((gorup) {
      return tempGorup3.add(GroupItemModel.fromJson(gorup));
    }).toList();
    return tempGorup3;
  }

  Future<List<GroupItemModel>> getGroup3(int g1Id, int g2Id) async {
    var res = await _repository.selectGorup3("tbGroup3", g1Id, g2Id) as List;
    List<GroupItemModel> tempGorup3 = [];
    res.map((gorup) {
      return tempGorup3.add(GroupItemModel.fromJson(gorup));
    }).toList();
    return tempGorup3;
  }
}
