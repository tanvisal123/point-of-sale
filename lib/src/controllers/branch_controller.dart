import 'dart:convert';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:http/http.dart' as http;
import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:point_of_sale/src/models/branch_modal.dart';

class BranchController {
  static Future<List<Branch>> eachBranch(String ip) async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result) {
      List<Branch> item = [];
      var url = ip + Config.branchUrl;
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var branchList = json.decode(response.body) as List;
        branchList.map((items) {
          return item.add(Branch.fromJson(items));
        }).toList();
      } else {
        return throw Exception('Failed to load branch');
      }
      return item;
    } else {
      return throw Exception('No internet');
    }
  }
}
