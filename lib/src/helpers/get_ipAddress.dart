import 'package:shared_preferences/shared_preferences.dart';

class GetIPAddress {
  Future<String> getIP() async {
    var _prefs = await SharedPreferences.getInstance();
    var _ip = _prefs.getString('ip');
    print(_ip);
    return _ip;
  }
}
