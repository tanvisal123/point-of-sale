import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:point_of_sale/src/models/account_loging.dart';
import 'package:point_of_sale/src/models/return_from_server_login.dart';

class LoginController {
  Future<ReturnFromServerLogin> login(AccountLogin account, String ip) async {
    final url = ip + Config.urlLogin;
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(account.toJson()),
      // josonEncode: convert dart to json,cuz be post
    );
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);
      //print("Respone 1 : $res");
      // jsonDecode: convert form json to dart
      ReturnFromServerLogin result = ReturnFromServerLogin.fromJson(res);
      // String Bearer = 'Bearer ' + result.accessToken;
      // result.accessToken = "Bearer " + result.accessToken;
      return result;
    } else {
      return null;
    }
  }
}
