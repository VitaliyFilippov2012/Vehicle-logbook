import 'package:finance_car_manager/db_context/sharedPreferencesRepository.dart';
import 'package:finance_car_manager/models/loginResult.dart';
import 'package:finance_car_manager/models/userCredentials.dart';
import 'package:http/http.dart' as http;

const String serverUri = "https://8f790b7c.ngrok.io";

class MyApi{
  static const String registerPOST = serverUri + "/auth/user";
  static const String authPOST = serverUri + "/auth/login";
  static const String updatePasswPUT = serverUri + "/auth/updatePassw";
  static const String getStaticInfoGET = serverUri + "/data/getStaticInfo";
  static const String getCarsByUserIdGET = serverUri + "/cars/userId";
  static String getCarByIdGET(String carId) => serverUri + "/car/$carId";
  static String getAllEventsByCarIdGET(String carId) => serverUri + "/events/carId/$carId";
  static const String createCarPOST = serverUri + "/car";
  static String shareCarWithOtherUserPOST(String carId, String email) => serverUri + "/car/shareCar/$carId&$email";
  static const String updateCarPUT = serverUri + "/car";
  static const String updateUserPUT = serverUri + "/user";
  static String deleteShareCarByIdDELETE(String carId) => serverUri + "/fcm/deleteShareCar/$carId";
  static String deleteEventByIdDELETE(String eventId) => serverUri + "/event/$eventId";
  static String getEventByIdGET(String eventId) => serverUri + "/event/$eventId";
  static String getEventFuelByIdGET(String eventId) => serverUri + "/fuel/$eventId";
  static String getEventServiceByIdGET(String eventId) => serverUri + "/service/$eventId";
  static const String createEventPOST = serverUri + "/create/event";
  static const String createEventFuelPOST = serverUri + "/create/fuel";
  static const String createEventServicePOST = serverUri + "/create/service";
  static const String updateEventPUT = serverUri + "/update/event";
  static const String updateEventFuelPUT = serverUri + "/update/fuel";
  static const String updateEventServicePUT = serverUri + "/update/service";
  static const String getSynchronisationContractPOST = serverUri + "/Service.asmx";

  static Future<LoginResult> getTokenFromServer(UserCredentials credentials) async {
    http.Response res = await http.post(MyApi.authPOST, body: credentials.toJson(), headers: {'Content-type': 'application/json'});
    return LoginResult.fromJson(res.body);
  }

  static Future<String> registrateUserInServer(UserCredentials credentials) async {
    http.Response res = await http.post(MyApi.registerPOST, body: credentials.toJson(), headers: {'Content-type': 'application/json'});
    return res.body;
  }

  static Future<String> updateUserPassword(UserCredentials credentials) async {
    http.Response res = await http.put(MyApi.updatePasswPUT, body: credentials.toJson(), headers: {'Content-type': 'application/json'});
    return res.body;
  }

  static Future<String> getSynchronisationDataContractPOST(String body) async {
    http.Response res = await http.post(MyApi.getSynchronisationContractPOST, body: body, headers: {'Content-type': 'text/xml'});
    return res.body;
  }

  static Future<String> sendShareCarWithOtherUserPOST(String carId, String email) async {
    var shared = new SharedPreferencesRepository();
    var token = await shared.getTokenFromSharedPreferences();
    http.Response res = await http.post(MyApi.shareCarWithOtherUserPOST(carId, email), headers: {'Content-type': 'text/xml', 'Token': token});
    return res.body;
  }
}