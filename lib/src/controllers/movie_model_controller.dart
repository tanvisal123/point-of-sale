
//import 'package:api1_project/Model/MovieDB.dart';
//import 'package:apitesting3_project/Model/MovieDB.dart';
//import 'package:apitesting/Model/MovieDB.dart';
//import  'package:apitesting5_project/Model/MovieDB.dart';
import 'package:point_of_sale/src/models/movie_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart'as http;
import 'package:http/http.dart';

Future<VisalDb> get getMovieDb async{
  final url = "https://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&api_key=3846dbafdb8289d63078a965e3e883f7";
  //http.Response response = await http.get(url);
  http.Response response = await http.get(Uri.parse(url));
  if (response.statusCode == 200){
    return compute(visalDbFromMap,response.body);
  } else {
    throw Exception("Error Code: ${response.statusCode}");
  }
}