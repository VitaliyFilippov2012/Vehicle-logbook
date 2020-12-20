import 'package:finance_car_manager/models/userCredentials.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesRepository{
    Future<bool> saveTokenInSharedPreferences(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String> getTokenFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? null;
  }

  Future<bool> saveStatusInSharedPreferences(String status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('status', status);
  }

  Future<String> getStatusFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('status') ?? null;
  }

  Future<bool> saveCredentialsInSharedPreferences(
    UserCredentials credentials) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('login', credentials.getLogin);
    await prefs.setString('password', credentials.getPassword);
  }

  Future<bool> clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('login', "");
    await prefs.setString('password', "");
    await prefs.setString('token', "");
    await prefs.setString('timeSync', "");
    await prefs.setString('selectedCar', "");
  }

  Future<UserCredentials> getCredentialsFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var credentials = new UserCredentials();
    credentials.setLogin = prefs.getString('login') ?? null;
    credentials.setPassword = prefs.getString('password') ?? null;
    if (credentials.getLogin == null || credentials.getPassword == null)
      return null;
    return credentials;
  }

  Future<bool> saveTimeSyncWithRemoteDB(String dateTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('timeSync', dateTime);
  }

  Future<bool> saveSelectedCar(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedCar', id);
  }

  Future<String> getSelectedCar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('selectedCar') ?? null;
  }

  Future<String> getTimeSyncWithRemoteDB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('timeSync') ?? null;
  }
}