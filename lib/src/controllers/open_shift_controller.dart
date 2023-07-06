import 'dart:convert';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:point_of_sale/src/models/open_shift_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OpenShiftController {
  // check open shift
  static Future<List<OpenShiftModel>> checkOpenShift(String ip) async {
    var userId = await FlutterSession().get('userId');
    var url = ip + Config.urlCheckOpenShift + '/$userId';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return openShiftModelFromJson(response.body);
    } else {
      return throw Exception('Failed to check open shift');
    }
  }

  static Future<String> checkOpenShifts(String ip) async {
    var _pref = await SharedPreferences.getInstance();
    var token = _pref.getString("token");
    var url = ip + Config.checkOpenShift;
    var respone = await http.post(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "Bearer " + token,
    });
    if (respone.statusCode == 200) {
      String jsonString = respone.body;
      print("opened : $jsonString");
      return jsonString;
    } else {
      return null;
    }
  }

  //  post open shift
  Future<List<OpenShiftModel>> postOpenShift(
      PostOpenShift shift, String ip) async {
    final String url = ip + Config.urlPostOpenShift;
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(shift.toJson()),
    );
    if (response.statusCode == 200) {
      if (response.body != null) {
        return openShiftModelFromJson(response.body);
      } else {
        return [];
      }
    } else {
      return [];
    }
  }

  static Future<ProcessOpenShift> processOpenShift(
      double amount, String ip) async {
    var _pref = await SharedPreferences.getInstance();
    var token = _pref.getString("token");
    var url = ip + Config.processOpenShift + "/$amount";
    var respone = await http.post(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "Bearer " + token
    });
    if (respone.statusCode == 200) {
      String jsonString = respone.body;
      ProcessOpenShift proccesOpenShift =
          ProcessOpenShift.fromJson(jsonDecode(jsonString));
      print("open shift : ${proccesOpenShift.isApproved}");
      return ProcessOpenShift.fromJson(jsonDecode(jsonString));
    } else {
      return null;
    }
  }
}
