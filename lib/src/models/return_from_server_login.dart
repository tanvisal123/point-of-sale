// class ReturnFromServerLogin {
//   int userid;
//   String userName;
//   String accessToken;
//   String refreshToken;

//   ReturnFromServerLogin({
//     this.userid,
//     this.userName,
//     this.accessToken,
//     this.refreshToken,
//   });

//   factory ReturnFromServerLogin.fromJson(Map<String, dynamic> json) {
//     return ReturnFromServerLogin(
//       userid: json["ID"],
//       userName: json["Username"],
//       accessToken: json["AccessToken"],
//       refreshToken: json["RefreshToken"],
//     );
//   }

//   Map<String, dynamic> toMap() => {
//         'ID': userid,
//         'Username': userName,
//         'AccessToken': accessToken,
//         'RefreshToken': refreshToken,
//       };
// }

import 'dart:convert';

ReturnFromServerLogin returnFromServersLoginFromJson(String str) =>
    ReturnFromServerLogin.fromJson(json.decode(str));

String returnFromServersLoginToJson(ReturnFromServerLogin data) =>
    json.encode(data.toJson());

class ReturnFromServerLogin {
  ReturnFromServerLogin({
    this.id,
    this.username,
    this.accessToken,
    this.refreshToken,
    this.statusCode,
    this.message,
  });

  int id;
  String username;
  String accessToken;
  String refreshToken;
  int statusCode;
  String message;

  factory ReturnFromServerLogin.fromJson(Map<String, dynamic> json) =>
      ReturnFromServerLogin(
        id: json["ID"],
        username: json["Username"],
        accessToken: json["AccessToken"],
        refreshToken: json["RefreshToken"],
        statusCode: json["StatusCode"],
        message: json["Message"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Username": username,
        "AccessToken": accessToken,
        "RefreshToken": refreshToken,
        "StatusCode": statusCode,
        "Message": message,
      };
}
