import 'dart:convert';

class UserCredentials {
  String password;
  String login;

  String get getPassword => password;

  set setPassword(String password) => this.password = password;

  String get getLogin => login;

  set setLogin(String login) => this.login = login;

  UserCredentials({
    this.password,
    this.login,
  });

  Map<String, dynamic> toMap() {
    return {
      'password': password,
      'login': login,
    };
  }

  static UserCredentials fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return UserCredentials(
      password: map['password'],
      login: map['login'],
    );
  }

  String toJson() => json.encode(toMap());

  static UserCredentials fromJson(String source) =>
      fromMap(json.decode(source));
}
