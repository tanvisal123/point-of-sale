class AccountLogin {
  String userName;
  String password;

  AccountLogin({this.userName, this.password});

  factory AccountLogin.fromJson(Map<String, dynamic> json) => AccountLogin(
        userName: json["Username"] as String,
        password: json["Password"] as String,
      );

  Map<String, dynamic> toJson() => {"Username": userName, "Password": password};
}
