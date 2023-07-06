
import 'dart:convert';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:point_of_sale/src/models/jsonplaceholder.dart';
import 'package:http/http.dart' as http;
var data ;
Future<void> getUserApi ()async{
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

  if(response.statusCode == 200){
    data = jsonDecode(response.body.toString());
  }else {

  }
}
// class jsonplaceholder{
//   static Future getjsonplaceholder(
//       String ip,int id,int userid,String body,String title,
//       )async{
//     bool _connection = await DataConnectionChecker().hasConnection;
//     var url = "https://jsonplaceholder.typicode.com/posts";
//     print("url:$url");
//     var response = await http.get(Uri.parse(url));
//     if (_connection){
//       try{
//         if(response.statusCode==200){
//           return compute(placeholderdbFromMap,response.body);
//         }
//       }catch(e){
//         print(e);
//       }
//     }
//     return userid;
//   }
//
// }
// Future<Placeholderdb> get getplaceholderDb async{
//   bool _connection = await DataConnectionChecker().hasConnection;
//   final url = "https://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&api_key=3846dbafdb8289d63078a965e3e883f7";
//   //http.Response response = await http.get(url);
//   http.Response response = await http.get(Uri.parse(url));
//   if(_connection){
//     try{
//       if(response.statusCode==200){
//         return compute(placeholderdbFromMap,response.body);
//       }
//     }catch(e){
//
//     }
//   }
// }
// class MoveOrderController {
//   static Future<int> getMoveOrder(
//       String ip, int fromTbId, int toTableId, int orderId) async {
//     bool _connection = await DataConnectionChecker().hasConnection;
//     var _pref = await SharedPreferences.getInstance();
//     var token = _pref.getString("token");
//     var url =
//         ip + Config.moveOrder + "/$fromTbId" + "/$toTableId" + "/$orderId";
//     print("url : $url");
//     var respone = await http.post(Uri.parse(url), headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//       'Authorization': token
//     });
//     if (_connection) {
//       try {
//         if (respone.statusCode == 200) {
//           return orderId;
//         }
//       } catch (e) {
//         print(e);
//       }
//     }
//     return orderId;
//   }
// }