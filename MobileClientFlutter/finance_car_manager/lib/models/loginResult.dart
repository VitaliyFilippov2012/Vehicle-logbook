import 'dart:convert';

class LoginResult {
  String accessToken;

  String get getAccessToken => accessToken;
  set setAccessToken(String accessToken) => this.accessToken = accessToken;
  LoginResult({
    this.accessToken,
  });

  Map<String, dynamic> toMap() {
    return {
      'accessToken': accessToken,
    };
  }

  static LoginResult fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return LoginResult(
      accessToken: map['accessToken'],
    );
  }

  String toJson() => json.encode(toMap());

  static LoginResult fromJson(String source) => fromMap(json.decode(source));
}
