import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:http/http.dart' as http;
import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckPrivilegeController {
  Future<String> checkprivilege(String code, String ip) async {
    bool _connection = await DataConnectionChecker().hasConnection;
    if (_connection) {
      var _pref = await SharedPreferences.getInstance();
      var token = _pref.getString("token");
      var url = ip + Config.urlCheckPrivilege + "/$code";
      var respone = await http.post(Uri.parse(url), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer " + token
      });
      if (respone.statusCode == 200) {
        print("respone ${respone.body}");
        return respone.body;
      } else {
        return throw Exception("No data");
      }
    } else {
      return throw Exception('No internet !');
    }
  }
}
