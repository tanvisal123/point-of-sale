import 'dart:convert';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:http/http.dart' as http;
import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:point_of_sale/src/controllers/setting_controller.dart';
import 'package:point_of_sale/src/helpers/repositorys.dart';
import 'package:point_of_sale/src/models/gorupItem_modal.dart';
import 'package:point_of_sale/src/models/item_modal.dart';

class ItemController {
  Repository _repository;
  ItemController() {
    _repository = Repository();
  }

  //---------------------------

  static Future<List<ItemMaster>> eachItem(GroupItemModel group, List<int> keys,
      int pageSize, int pageIndex, String ip) async {
    bool _result = await DataConnectionChecker().hasConnection;
    var _setting;
    if (!_result)
      _setting = await SettingController().selectSetting();
    else
      _setting = await SettingController.getSetting(ip);

    //${baseUrl}api/master/getitem
    var url = ip + Config.itemUrl + '?plid=${_setting.first.priceListId}';
    if (keys == null) {
      url = url +
          '&key=$keys' +
          '&g1id=${group.g1Id}' +
          '&g2id=${group.g2Id}' +
          '&g3id=${group.g3Id}' +
          '&type=item' +
          '&page=$pageSize' +
          '&index=$pageIndex';
    } else if (keys.length > 0) {
      keys.forEach((i) => url = url + '&key=$i');
      url = url +
          '&g1id=0' +
          '&g2id=0' +
          '&g3id=0}' +
          '&type=item' +
          '&page=$pageSize' +
          '&index=$pageIndex';
    }
    var response = await http.get(Uri.parse(url));
    var responseItemList = json.decode(response.body) as List;
    List<ItemMaster> item = [];
    responseItemList.map((items) {
      return item.add(ItemMaster.fromJson(items));
    }).toList();
    return item;
  }

  static Future<List<ItemMaster>> eachItemLocal(String ip) async {
    var url = ip + Config.itemUrlLocal;
    var response = await http.get(Uri.parse(url));
    var responseItemList = json.decode(response.body) as List;
    List<ItemMaster> item = [];
    responseItemList.map((items) {
      return item.add(ItemMaster.fromJson(items));
    }).toList();
    return item;
  }

  static Future<List<ItemMaster>> searchItem(String name, String ip) async {
    bool result = await DataConnectionChecker().hasConnection;
    var setting;
    if (!result) {
      setting = await SettingController().selectSetting();
    } else {
      setting = await SettingController.getSetting(ip);
    }
    var url = ip + Config.searchItemUrl + "?plid=${setting.first.priceListId}";
    print('PLID = ${setting.first.priceListId}');
    url = url + "&name=$name";
    var response = await http.get(Uri.parse(url));
    var responseItemList = json.decode(response.body) as List;
    List<ItemMaster> item = [];
    responseItemList.map((items) {
      return item.add(ItemMaster.fromJson(items));
    }).toList();
    return item;
  }

  // get local stor

  insertItem(ItemMaster item) async {
    return await _repository.insertData('tbItem', item.toMap());
  }

  update(ItemMaster item) async {
    return await _repository.updateItem("tbItem", item.toMap(), item.key);
  }

  Future<List<ItemMaster>> getItems(
      GroupItemModel group, int page, int index, String ip) async {
    bool result = await DataConnectionChecker().hasConnection;
    var settting;
    if (!result) {
      settting = await SettingController().selectSetting();
    } else {
      settting = await SettingController.getSetting(ip);
    }

    var res = await _repository.selectItem(
        'tbItem', group, settting.first.priceListId) as List;
    List<ItemMaster> list = [];
    res.map((item) {
      return list.add(ItemMaster.fromJson(item));
    }).toList();
    int totalPage = list.length;
    totalPage = (totalPage / page).floor();
    List<ItemMaster> itemList = [];
    if (list.length % page != 0) {
      totalPage += 1;
    }
    if (totalPage >= index) {
      itemList = list.skip((index - 1) * page).take(page).toList();
    }
    return itemList;
  }

  Future<List<ItemMaster>> hasItem(int key) async {
    var res = await _repository.selectItemByKey("tbItem", key) as List;
    List<ItemMaster> list = [];
    res.map((item) {
      return list.add(ItemMaster.fromJson(item));
    }).toList();
    return list;
  }
}
