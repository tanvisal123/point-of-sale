import 'package:http/http.dart' as http;
import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:point_of_sale/src/models/compay_modal.dart';

class CompanyController {
  static Future<List<CompanyModel>> eachCompany(String ip) async {
    var url = ip + Config.companyUrl;
    print('Company URL = $url');
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return companyModelFromJson(response.body);
    } else {
      return throw Exception('Failed to load company');
    }
  }
}
