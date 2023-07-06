import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccessIPController extends GetxController {
  String ip = 'http://'.obs();
  setIP(String ipAddress) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('ip', ipAddress);
    print('IP in Getx:$ip');
    update();
    getIP();
  }

  getIP() async {
    var prefs = await SharedPreferences.getInstance();
    this.ip = prefs.getString('ip') ?? 'http://';
    update();
  }
}
