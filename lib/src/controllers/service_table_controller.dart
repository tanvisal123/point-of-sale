import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:http/http.dart' as http;
import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:point_of_sale/src/models/service_table_modal.dart';
import 'package:point_of_sale/src/models/table_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as dev;

class ServiceTableController {
  static Future<ServiceTableModel> getGroupTable(String ip) async {
    var prefs = await SharedPreferences.getInstance();
    ip = prefs.getString('ip');
    bool _connection = await DataConnectionChecker().hasConnection;

    dev.log("IP:$ip");
    if (_connection) {
      var _pref = await SharedPreferences.getInstance();
      var token = _pref.getString("token");
      var url = ip + Config.urlGroupTable;
      print("service url : $url");
      var response = await http.post(Uri.parse(url), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer " + token
      });
      print('token in Controller: $token');
      if (response.statusCode == 200) {
        String jsonString = response.body;
        ServiceTableModel serviceTableModel =
            groupTableModelFromJson(jsonString);
        List<Table> table = serviceTableModel.tables;
        for (var temp in table) {
          print("group table : ${temp.groupTable.name}");
          print("table name : ${temp.name}");
        }
        return groupTableModelFromJson(jsonString);
      } else {
        throw Exception('Failed to load Group Table');
      }
    } else {
      return throw Exception('No internet !');
    }
  }
}

class TableController {
  static Future<List<TableModel>> getTable(int groupId, String ip) async {
    bool _connection = await DataConnectionChecker().hasConnection;
    var _pref = await SharedPreferences.getInstance();
    var token = _pref.getString("token");

    if (_connection) {
      var _url = ip + Config.urlTable + '/$groupId';
      var response = await http.post(Uri.parse(_url), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer " + token,
      });

      if (response.statusCode == 200) {
        String jsonString = response.body;
        print("table by group: $jsonString");
        return tableModelFromJson(jsonString);
      } else if (response.statusCode == 401) {
        return throw Exception('Failed to load table');
      } else {
        return throw Exception('Failed to load table');
      }
    } else {
      return throw Exception('No internet');
    }
  }

  static Future<List<TableModel>> searchTable(String name, String ip) async {
    bool _connection = await DataConnectionChecker().hasConnection;
    var _pref = await SharedPreferences.getInstance();
    var token = _pref.getString("token");

    if (_connection) {
      var _url = ip + Config.urlSearchTable + '/$name' + '/false';
      var response = await http.post(Uri.parse(_url), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer " + token
      });
      if (response.statusCode == 200) {
        String jsonString = response.body;
        print("table by group: $jsonString");
        return tableModelFromJson(jsonString);
      } else {
        return throw Exception('Failed to load table');
      }
    } else {
      return throw Exception('No internet');
    }
  }
}
