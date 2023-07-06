import 'package:http/http.dart' as http;
import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:point_of_sale/src/helpers/repositorys.dart';
import 'package:point_of_sale/src/models/gorupItem_modal.dart';

class Group1Controller {
  Repository _repository;

  Group1Controller() {
    _repository = Repository();
  }

  static Future<List<GroupItemModel>> eachGroup1(String ip) async {
    var response = await http.get(Uri.parse(ip + Config.getGroup1));
    if (response.statusCode == 200) {
      return groupItemModelFromJson(response.body);
    } else {
      return throw Exception('Failed to load group1');
    }
  }

  insertGroup1(GroupItemModel group1) async {
    return await _repository.insertData('tbGroup1', group1.toJson());
  }

  updateGroup1(GroupItemModel item, int g1Id) async {
    return await _repository.updateGroup1("tbGroup1", item.toJson(), g1Id);
  }

  Future<List<GroupItemModel>> hasGroup1(int g1Id) async {
    var res = await _repository.selectGroup1ById("tbGroup1", g1Id) as List;
    List<GroupItemModel> tempGorup1 = [];
    res.map((gorup) {
      return tempGorup1.add(GroupItemModel.fromJson(gorup));
    }).toList();
    return tempGorup1;
  }

  Future<List<GroupItemModel>> getGroup1() async {
    var res = await _repository.selectData('tbGroup1') as List;
    List<GroupItemModel> tempGorup1 = [];
    res.map((gorup) {
      return tempGorup1.add(GroupItemModel.fromJson(gorup));
    }).toList();
    return tempGorup1;
  }
}
