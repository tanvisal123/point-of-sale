import 'package:shared_preferences/shared_preferences.dart';

class SharePrefer {
  SharedPreferences _preferences;
  static const _keyPayby = 'payby';

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  void setPayby(String payby) async {
    _preferences.setString(_keyPayby, payby);
  }

  String getPayby() => _preferences.getString(_keyPayby);
}
