import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:point_of_sale/src/helpers/repositorys.dart';
import 'package:point_of_sale/src/models/setting_modal.dart';

class SettingController {
  Repository _repository;
  SettingController() {
    _repository = Repository();
  }
  static Future<List<SettingModel>> getSetting(String ip) async {
    try {
      var userId = await FlutterSession().get('userId');
      final url = ip + Config.urlSetting + '/$userId';
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return settingModelFromJson(response.body);
      } else {
        return throw Exception('Fialed to load setting');
      }
    } catch (e) {
      print('Setting Error : $e');
      return e;
    }
  }

  Future<int> insertSetting(SettingModel setting) async {
    return await _repository.insertData('tbSetting', setting.toJson());
  }

  Future<int> updateSetting(SettingModel setting) async {
    return await _repository.updateData(
        'tbSetting', setting.toJson(), setting.id);
  }

  Future<List<SettingModel>> hasSetting(int id) async {
    var _response = await _repository.selectDataById("tbSetting", id);
    return settingModelFromJson(_response);
  }

  Future<List<SettingModel>> selectSetting() async {
    var _response = await _repository.selectData('tbSetting');
    List<SettingModel> settingList = [];
    _response.map((e) {
      return settingList.add(SettingModel.fromJson(e));
    }).toList();
    return settingList;
    // return settingModelFromJson(_response);
  }

  deleteSetting() async {
    return await _repository.deleteAllData('tbSetting');
  }
}
