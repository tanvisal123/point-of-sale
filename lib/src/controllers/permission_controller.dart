import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:point_of_sale/src/constants/api_config.dart';

class PermissionController {
  // check permission open  shift
  static Future<String> checkPermissionOpenShift(String ip) async {
    dynamic userId = await FlutterSession().get("userId");
    var url = ip + Config.urlCheckPerOpenShift + "?userId=$userId";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return throw Exception('Failed to check permission open shift');
    }
  }

  // check permission bill
  static Future<String> permissionBill(String ip) async {
    dynamic userId = await FlutterSession().get("userId");
    var url = ip + Config.permisBill + "?userId=$userId";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return throw Exception('Failed to check permission bill');
    }
  }

  // check permission Pay
  static Future<String> permissionPay(String ip) async {
    dynamic userId = await FlutterSession().get("userId");
    var url = ip + Config.permisPay + "?userId=$userId";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return throw Exception('Failed to check permission pay');
    }
  }

  // check permission void order
  static Future<String> permissionVoidOrder(String ip) async {
    dynamic userId = await FlutterSession().get("userId");
    var url = ip + Config.permisVoidOrder + "?userId=$userId";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return throw Exception('Failed to check permission void order');
    }
  }

  // check permission move table
  static Future<String> permissionMoveTable(String ip) async {
    dynamic userId = await FlutterSession().get("userId");
    var url = ip + Config.permisMoveTable + "?userId=$userId";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return throw Exception('Failed to check permission move table');
    }
  }

  // check permission combine receipt
  static Future<String> permissionCombineReceipt(String ip) async {
    dynamic userId = await FlutterSession().get("userId");
    var url = ip + Config.permiscombine + "?userId=$userId";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return throw Exception('Failed to check permission combine receipt');
    }
  }

  // check permission split receipt
  static Future<String> permissionSplitReceipt(String ip) async {
    dynamic userId = await FlutterSession().get("userId");
    var url = ip + Config.permissplit + "?userId=$userId";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return throw Exception('Failed to check permission split receipt');
    }
  }

  // check permission delete item
  static Future<String> permissionDeleteItem(String ip) async {
    dynamic userId = await FlutterSession().get("userId");
    var url = ip + Config.permisDeleteItem + "?userId=$userId";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return throw Exception('Failed to check permission split receipt');
    }
  }

  // check permission member card
  static Future<String> permissionMemberCard(String ip) async {
    dynamic userId = await FlutterSession().get("userId");
    var url = ip + Config.permisMemberCard + "?userId=$userId";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return throw Exception('Failed to check permission member card');
    }
  }

  // check permission return order
  static Future<String> permissionReturnOrder(String ip) async {
    dynamic userId = await FlutterSession().get("userId");
    var url = ip + Config.permisReturnOrder + "?userId=$userId";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return throw Exception('Failed to check permission return order');
    }
  }

  // check permission cancel order
  static Future<String> permissionCancelOrder(String ip) async {
    dynamic userId = await FlutterSession().get("userId");
    var url = ip + Config.permisCancelOrder + "?userId=$userId";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return throw Exception('Failed to check permission cancel order');
    }
  }

  // check permission discount item
  static Future<String> permissionDiscountItem(String ip) async {
    var userId = await FlutterSession().get("userId");
    var url = ip + Config.permisDiscountItem + "?userId=$userId";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return throw Exception('Failed to check permission discount item');
    }
  }
}
