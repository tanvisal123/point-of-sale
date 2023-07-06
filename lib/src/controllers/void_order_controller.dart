import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:http/http.dart' as http;

class VoidOrderController {
  // check permission open  shift
  static Future<String> voidOrder(String ip, int orderId, String reason) async {
    var url = ip + Config.voidOrder + '/$orderId/$reason';
    var response = await http.get(Uri.parse(url));
    print('URL = $url');
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return throw Exception('Failed to check void order');
    }
  }
}
