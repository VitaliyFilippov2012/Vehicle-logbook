import 'dart:async';
import 'dart:math';
import 'package:finance_car_manager/db_context/db_provaider.dart';
import 'package:finance_car_manager/db_context/sharedPreferencesRepository.dart';
import 'package:finance_car_manager/models/UserInfo.dart';
import 'package:finance_car_manager/models/myApi.dart';
import 'package:finance_car_manager/models/userCredentials.dart';
import 'package:finance_car_manager/utils/crypt.dart';

class UserRepository {
  SharedPreferencesRepository sharedPreferences = new SharedPreferencesRepository();

  Future<UserInfo> getUser() async {
    return await DbProvider().getUserInfo();
  }

  Future<int> updateUser(UserInfo user) async {
    return await DbProvider().updateUser(user);
  }

  Future<int> addUser(UserInfo user) async {
    DbProvider().clearDatabase();
    return await DbProvider().addUserInfo(user);
  }

  Future<UserCredentials> checkKeepCredentials() async {
    try {
      return sharedPreferences.getCredentialsFromSharedPreferences();
    } catch (E) {
      return Future<UserCredentials>.value(null);
    }
  }

  Future<bool> updateForgotCredentialsInRemoteDB(
      String password, String login) async {
    if (login.length < 6) return false;
    String password = getRandomString();
    var crypt = new Crypt.initialize();
    var encryptedPassw = crypt.encrypt(password);
    var credentials = UserCredentials(
        login: login,
        password: encryptedPassw + "vitaliyCarFinanceManager" + password);
    return await updateCredentialsInRemoteDB(credentials);
  }

  Future<bool> updateCredentialsInRemoteDB(UserCredentials credentials) async {
    try {
      if (await MyApi.updateUserPassword(credentials) == "true"){
          await sharedPreferences.clearSharedPreferences();
         return true;
      }
      return false;
    } catch (E) {
      return Future<bool>.value(false);
    }
  }

  String getRandomString() {
    var secureRandom = Random.secure();
    var randomNumber = secureRandom.nextInt(13);
    var chars = "0123456789abcdefghijklmnopqrstuvwxyz";
    var password = "";
    for (int i = 0; i < randomNumber; ++i)
      password += chars[secureRandom.nextInt(chars.length)];
    return password + "SupFcm";
  }

  Future<bool> authUser(String password, String login) async {
    try {
      if (password == null || login == null) return Future<bool>.value(false);
      var crypt = new Crypt.initialize();
      var encryptedPassw = crypt.encrypt(password);
      var credentials = UserCredentials(login: login, password: encryptedPassw);
      var token = await MyApi.getTokenFromServer(credentials);
      if (token.accessToken == null) {
        await sharedPreferences.clearSharedPreferences();
        return Future<bool>.value(false);
      }
      await sharedPreferences.saveTokenInSharedPreferences(token.accessToken);
      var oldCred = await sharedPreferences.getCredentialsFromSharedPreferences();
      if(oldCred?.login != credentials.login){
        DbProvider().clearDatabase();
        DbProvider().addTriggers();
      }
      credentials.setPassword = password;
      await sharedPreferences.saveCredentialsInSharedPreferences(credentials);
      await sharedPreferences.saveStatusInSharedPreferences("Online");
    } catch (e) {
        await sharedPreferences.saveStatusInSharedPreferences("Offline");
        var prevCredentials = await sharedPreferences.getCredentialsFromSharedPreferences();
        if (prevCredentials.getLogin == login &&
            prevCredentials.getPassword == password) {
          return Future<bool>.value(true);
      }
    }
    return Future<bool>.value(true);
  }

  Future<bool> registerUser(
      String password, String login, String secondPassword) async {
    try {
      if (secondPassword != password ||
          secondPassword == null ||
          password == null ||
          login == null) return Future<bool>.value(false);
      var crypt = new Crypt.initialize();
      var encryptedPassw = crypt.encrypt(password);
      var credentials = UserCredentials(login: login, password: encryptedPassw);
      var result = await MyApi.registrateUserInServer(credentials);
      if (result != "OK") {
        return Future<bool>.value(false);
      }
      await sharedPreferences.clearSharedPreferences();
      DbProvider().clearDatabase();
      DbProvider().addTriggers();
    } catch (E) {
      return Future<bool>.value(false);
    }
    return Future<bool>.value(true);
  }
}
