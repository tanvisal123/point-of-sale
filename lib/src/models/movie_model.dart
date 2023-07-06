// To parse this JSON data, do
//
//     final visalDb = visalDbFromMap(jsonString);

import 'dart:convert';

//import 'package:api1_project/main.dart';
//import 'package:apitesting3_project/main.dart';
//import 'package:apitesting/main.dart';
import 'package:point_of_sale/main.dart';
import 'package:flutter/cupertino.dart';

VisalDb visalDbFromMap(String str) => VisalDb.fromMap(json.decode(str));

String visalDbToMap(VisalDb data) => json.encode(data.toMap());

class VisalDb {
  VisalDb({
    this.page=0,
    this.results,
    this.totalPages=0,
    this.totalResults=0,
  });

  final int page;
  final List<Result> results;
  final int totalPages;
  final int totalResults;

  factory VisalDb.fromMap(Map<String, dynamic> json) => VisalDb(
    page: json["page"],
    results: List<Result>.from(json["results"].map((x) => Result.fromMap(x))),
    totalPages: json["total_pages"],
    totalResults: json["total_results"],
  );

  Map<String, dynamic> toMap() => {
    "page": page,
    "results": List<dynamic>.from(results.map((x) => x.toMap())),
    "total_pages": totalPages,
    "total_results": totalResults,
  };
}

class Result {
  Result({
    this.adult=false,
    this.backdropPath='abc',
    //this.genreIds='',
    this.id=0,
    //this.originalLanguage='abc',
    this.originalTitle='abc',
    this.overview='abc',
    this.popularity=0,
    this.posterPath='abc',
    //this.releaseDate='DD,YY,MM',
    this.title='abc',
    this.video=false,
    this.voteAverage=0,
    this.voteCount=0,
  });

  final bool adult;
  final String backdropPath;
  //final List<int>? genreIds;
  final int id;
  //final OriginalLanguage originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String posterPath;
  //final DateTime releaseDate;
  final String title;
  final bool video;
  final double voteAverage;
  final int voteCount;

  factory Result.fromMap(Map<String, dynamic> json) => Result(
    adult: json["adult"],
    backdropPath: json["backdrop_path"],
    //genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
    id: json["id"],
    // originalLanguage: originalLanguageValues.map[json["original_language"]],
    originalTitle: json["original_title"],
    overview: json["overview"],
    popularity: json["popularity"].toDouble(),
    posterPath: json["poster_path"],
    //releaseDate: DateTime.parse(json["release_date"]),
    title: json["title"],
    video: json["video"],
    voteAverage: json["vote_average"].toDouble(),
    voteCount: json["vote_count"],
  );

  Map<String, dynamic> toMap() => {
    "adult": adult,
    "backdrop_path": backdropPath,
    //"genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
    "id": id,
    // "original_language": originalLanguageValues.reverse[originalLanguage],
    "original_title": originalTitle,
    "overview": overview,
    "popularity": popularity,
    "poster_path": posterPath,
    //"release_date": "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
    "title": title,
    "video": video,
    "vote_average": voteAverage,
    "vote_count": voteCount,
  };
}


