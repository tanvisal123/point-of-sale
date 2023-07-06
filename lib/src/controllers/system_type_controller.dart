import 'package:http/http.dart' as http;
import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:point_of_sale/src/models/system_type_model.dart';

// class SystemTypeController {
//   static Future<SystemTypeModel> getSystemType(String ip) async {
//     try {
//       var url = ip + Config.urlSystemType;
//       var response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         var jsonString = json.decode(response.body);
//         print('Systme Type = $jsonString');
//         return SystemTypeModel.fromJson(jsonString);
//       } else {
//         return null;
//       }
//     } catch (e) {
//       return null;
//     }
//   }
// }

class SystemTypeController {
  static Future<List<String>> getSystemType(String ip) async {
    var url = ip + Config.urlSystemType;
    var respone = await http.post(Uri.parse(url));
    print("url : $url");
    if (respone.statusCode == 200) {
      return systemTypesFromJson(respone.body);
    } else {
      return null;
    }
  }
}

// class CustomerController {
//   static Future<List<CustomerModel>> getCustomer(String ip) async {
//     var url = ip + Config.customerUrl;
//     var response = await http.get(Uri.parse(url));
//     print('Uri : $url');
//     print('Customer Response : ${response.body}');
//     if (response.statusCode == 200) {
//       return customerModelFromJson(response.body);
//     } else {
//       return null;
//     }
//   }
// }
