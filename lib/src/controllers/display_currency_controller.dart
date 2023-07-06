import 'package:http/http.dart' as http;
import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:point_of_sale/src/controllers/setting_controller.dart';
import 'package:point_of_sale/src/helpers/repositorys.dart';
import 'package:point_of_sale/src/models/display_currency_modal.dart';

class DisplayCurrController {
  Repository _repository;
  DisplayCurrController() {
    _repository = Repository();
  }
  static Future<List<DisplayCurrModel>> getDisplayCurr(String ip) async {
    var _setting = await SettingController.getSetting(ip);
    var url;
    if (_setting.length > 0) {
      url = ip + Config.displayCurrUrl + "/${_setting.first.priceListId}";
    }
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return displayCurrModelFromJson(response.body);
    } else {
      return throw Exception('Failed to load display currency');
    }
  }

  Future<void> insertDisplayCurr(DisplayCurrModel displayCurrModel) {
    return _repository.insertData('tbDisplayCurr', displayCurrModel.toJson());
  }

  Future<List<DisplayCurrModel>> selectDisplayCurr() async {
    var response = await _repository.selectData('tbDisplayCurr') as List;
    List<DisplayCurrModel> displayCurrList = [];
    response.map((value) {
      return displayCurrList.add(DisplayCurrModel.fromJson(value));
    }).toList();
    return displayCurrList;
  }

  Future<void> deleteDisplayCurr(int id) {
    return _repository.deleteData('tbDisplayCurr', id);
  }

  Future<void> updateDisplayCurr(DisplayCurrModel displayCurrModel) {
    return _repository.updateData(
      'tbDisplayCurr',
      displayCurrModel.toJson(),
      displayCurrModel.id,
    );
  }
}
