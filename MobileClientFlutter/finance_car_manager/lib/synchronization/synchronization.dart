import 'dart:convert';
import 'package:finance_car_manager/blocs/carsBloc.dart';
import 'package:finance_car_manager/db_context/auditRepository.dart';
import 'package:finance_car_manager/models/UserInfo.dart';
import 'package:finance_car_manager/models/category.dart';
import 'package:finance_car_manager/models/event.dart';
import 'package:finance_car_manager/models/eventService.dart';
import 'package:finance_car_manager/models/fuel.dart';
import 'package:finance_car_manager/synchronization/syncEntity.dart';
import 'package:intl/intl.dart';
import 'package:synchronized/synchronized.dart';
import 'package:xml/xml.dart' as xml;
import 'package:finance_car_manager/blocs/userInfoBloc.dart';
import 'package:finance_car_manager/db_context/carsRepository.dart';
import 'package:finance_car_manager/db_context/eventsRepository.dart';
import 'package:finance_car_manager/models/car.dart';
import 'package:finance_car_manager/models/eventsWrapper.dart';
import 'package:finance_car_manager/models/staticDataWrapper.dart';
import 'package:finance_car_manager/db_context/sharedPreferencesRepository.dart';
import 'package:finance_car_manager/db_context/userRepository.dart';
import 'package:finance_car_manager/models/myApi.dart';
import 'package:finance_car_manager/synchronization/synchronisationDataContract.dart';
import 'package:finance_car_manager/utils/crypt.dart';
import 'package:http/http.dart' as http;

class Synchronization {

  Synchronization._privateConstructor();

  static final Synchronization _instance = Synchronization._privateConstructor();

  factory Synchronization() {
    return _instance;
  }

  SharedPreferencesRepository sharedPreferences =
      new SharedPreferencesRepository();
  UserRepository userRepository = new UserRepository();
  CarsRepository carsRepository = new CarsRepository();
  EventsRepository eventsRepository = new EventsRepository();
  AuditRepository auditRepository = new AuditRepository();
  String _token;
  Lock lock = new Lock();

  Future<void> saveSyncDate() async {
    await sharedPreferences.saveTimeSyncWithRemoteDB(_getDateSyncWithDb());
  }

  Future<void> refreshToken() async {
    var userCredentials =
        await sharedPreferences.getCredentialsFromSharedPreferences();
    var encrypter = Crypt.initialize();
    userCredentials.password = encrypter.encrypt(userCredentials.password);
    var loginResult = await MyApi.getTokenFromServer(userCredentials);
    _token = loginResult?.accessToken;
  }

  Future<String> get accsessToken async {
    if (_token == null) {
      _token = await sharedPreferences.getTokenFromSharedPreferences();
    }
    return _token;
  }

  Future<EventService> loadServiceEventFromServer(String eventId) async {
    var token = await accsessToken;
    http.Response res = await http.get(MyApi.getEventServiceByIdGET(eventId),
        headers: {'Content-type': 'application/json', 'Token': token});
    if (res.statusCode == 401) {
      await refreshToken();
      return await loadServiceEventFromServer(eventId);
    }
    return EventService.fromEventMap(json.decode(res.body));
  }

  Future<void> putServiceEventToServer(String eventId) async {
    var event = await eventsRepository.getServiceEventById(eventId);
    if (event == null) return;
    var token = await accsessToken;
    http.Response res = await http.put(MyApi.updateEventServicePUT,
        body: event.toJson(),
        headers: {'Content-type': 'application/json', 'Token': token});
    if (res.statusCode == 401) {
      await refreshToken();
      return await putServiceEventToServer(eventId);
    }
  }

  Future<void> updateServiceEventByIdFromServer(String eventId) async {
    var event = await loadServiceEventFromServer(eventId);
    if (event == null) return;
    await eventsRepository.updateServiceEvent(event);
  }

  Future<void> loadUserDataWithStaticInfo() async {
    var token = await accsessToken;
    http.Response res = await http.get(MyApi.getStaticInfoGET,
        headers: {'Content-type': 'application/json', 'Token': token});
    if (res.statusCode == 401) {
      await refreshToken();
      await loadUserDataWithStaticInfo();
      return;
    }
    StaticDataWrapper wrapper =
        StaticDataWrapper.fromMap(json.decode(res.body));
    if (wrapper?.userInfo != null) {
      await userRepository.addUser(wrapper.userInfo);
      userInfoBloc.setUserToStream(wrapper.userInfo);
    }
    if (wrapper?.typeServices != null) {
      await eventsRepository.addServiceTypes(wrapper.typeServices);
    }
    if (wrapper?.typeEvents != null) {
      await eventsRepository.addEventTypes(wrapper.typeEvents);
    }
  }

  Future<void> loadUserCars() async {
    var token = await accsessToken;
    http.Response res = await http.get(MyApi.getCarsByUserIdGET,
        headers: {'Content-type': 'application/json', 'Token': token});
    if (res.statusCode == 401) {
      await refreshToken();
      await loadUserCars();
      return;
    }
    var cars =
        List<Car>.from(json.decode(res.body)?.map((x) => Car.fromServerMap(x)));
    for (var car in cars) await carsRepository.addCar(car);
  }

  Future<Event> loadEventFromServer(String eventId) async {
    var token = await accsessToken;
    http.Response res = await http.get(MyApi.getEventByIdGET(eventId),
        headers: {'Content-type': 'application/json', 'Token': token});
    if (res.statusCode == 401) {
      await refreshToken();
      return await loadEventFromServer(eventId);
    }
    return Event.fromMap(json.decode(res.body));
  }

  Future<void> postEventToServer(String eventId) async {
    var event = await eventsRepository.getEventById(eventId);
    if (event == null) return;
    var token = await accsessToken;
    if (event.idTypeEvents == categories[2].categoryId) {
      var fuel = await eventsRepository.getFuelEventById(eventId);
      http.Response res = await http.post(MyApi.createEventFuelPOST,
          body: fuel.toJson(),
          headers: {'Content-type': 'application/json', 'Token': token});
      if (res.statusCode == 401) {
        await refreshToken();
        return await postEventToServer(eventId);
      }
      return;
    } else if (event.idTypeEvents == categories[3].categoryId) {
      var service = await eventsRepository.getServiceEventById(eventId);
      http.Response res = await http.post(MyApi.createEventServicePOST,
          body: service.toJson(),
          headers: {'Content-type': 'application/json', 'Token': token});
      if (res.statusCode == 401) {
        await refreshToken();
        return await postEventToServer(eventId);
      }
      return;
    }
    http.Response res = await http.post(MyApi.createEventPOST,
        body: event.toJson(),
        headers: {'Content-type': 'application/json', 'Token': token});
    if (res.statusCode == 401) {
      await refreshToken();
      return await postEventToServer(eventId);
    }
  }

  Future<void> saveEventFromServer(String eventId) async {
    var event = await loadEventFromServer(eventId);
    if (event == null) return;
    if (event.idTypeEvents == categories[2].categoryId) {
      var fuel = await loadFuelFromServer(eventId);
      if (fuel == null) return;
      await eventsRepository.saveFuelEvent(fuel);
      return;
    } else if (event.idTypeEvents == categories[3].categoryId) {
      var service = await loadServiceEventFromServer(eventId);
      if (service == null) return;
      await eventsRepository.saveServiceEvent(service);
    }
    await eventsRepository.saveEvent(event);
  }

  Future<UserInfo> loadUserInfoFromServer() async {
    var token = await accsessToken;
    http.Response res = await http.get(MyApi.getStaticInfoGET,
        headers: {'Content-type': 'application/json', 'Token': token});
    if (res.statusCode == 401) {
      await refreshToken();
      return await loadUserInfoFromServer();
    }
    StaticDataWrapper wrapper =
        StaticDataWrapper.fromMap(json.decode(res.body));
    return wrapper.userInfo;
  }

  Future<void> putUserInfoToServer() async {
    var user = await userRepository.getUser();
    if (user == null) return;
    var token = await accsessToken;
    http.Response res = await http.put(MyApi.updateUserPUT,
        body: user.toJson(),
        headers: {'Content-type': 'application/json', 'Token': token});
    if (res.statusCode == 401) {
      await refreshToken();
      return await putUserInfoToServer();
    }
  }

  Future<void> updateUserInfoByIdFromServer() async {
    var user = await loadUserInfoFromServer();
    if (user == null) return;
    await userRepository.updateUser(user);
    userInfoBloc.setUserToStream(user);
  }

  Future<Fuel> loadFuelFromServer(String eventId) async {
    var token = await accsessToken;
    http.Response res = await http.get(MyApi.getEventFuelByIdGET(eventId),
        headers: {'Content-type': 'application/json', 'Token': token});
    if (res.statusCode == 401) {
      await refreshToken();
      return await loadFuelFromServer(eventId);
    }
    return Fuel.fromEventMap(json.decode(res.body));
  }

  Future<void> putFuelEventToServer(String eventId) async {
    var event = await eventsRepository.getFuelEventById(eventId);
    if (event == null) return;
    var token = await accsessToken;
    http.Response res = await http.put(MyApi.updateEventFuelPUT,
        body: event.toJson(),
        headers: {'Content-type': 'application/json', 'Token': token});
    if (res.statusCode == 401) {
      await refreshToken();
      return await putFuelEventToServer(eventId);
    }
  }

  Future<void> updateFuelEventByIdFromServer(String eventId) async {
    var event = await loadFuelFromServer(eventId);
    if (event == null) return;
    await eventsRepository.updateFuelEvent(event);
  }

  Future<void> putEventToServer(String eventId) async {
    var event = await eventsRepository.getEventById(eventId);
    if (event == null) return;
    var token = await accsessToken;
    http.Response res = await http.put(MyApi.updateEventPUT,
        body: event.toJson(),
        headers: {'Content-type': 'application/json', 'Token': token});
    if (res.statusCode == 401) {
      await refreshToken();
      return await putEventToServer(eventId);
    }
  }

  Future<void> updateEventByIdFromServer(String eventId) async {
    var event = await loadEventFromServer(eventId);
    if (event == null) return;
    await eventsRepository.updateEvent(event);
  }

  Future<http.Response> getCarByIdFromServer(String carId) async {
    var token = await accsessToken;
    http.Response res = await http.get(MyApi.getCarByIdGET(carId),
        headers: {'Content-type': 'application/json', 'Token': token});
    if (res.statusCode == 401) {
      await refreshToken();
      return await getCarByIdFromServer(carId);
    }
    return res;
  }

  Future<void> loadUserCarById(String carId) async {
    var res = await getCarByIdFromServer(carId);
    var car = Car.fromServerMap(json.decode(res.body));
    if (car == null) return;
    await carsRepository.addCar(car);
    await carsBloc.getSelectedCarOrSetIfNotExistsInShared();
  }

  Future<void> updateUserCarByIdFromServer(String carId) async {
    var res = await getCarByIdFromServer(carId);
    var car = Car.fromServerMap(json.decode(res.body));
    if (car == null) return;
    await carsRepository.updateCar(car);
    await carsBloc.getAllCars();
  }

  Future<void> postUserCarById(String carId) async {
    var car = await carsRepository.getCarById(carId);
    if (car == null) return;
    var token = await accsessToken;
    http.Response res = await http.post(MyApi.createCarPOST,
        body: car.toJson(),
        headers: {'Content-type': 'application/json', 'Token': token});
    if (res.statusCode == 401) {
      await refreshToken();
      await postUserCarById(carId);
      return;
    }
  }

  Future<void> putUserCarById(String carId) async {
    var car = await carsRepository.getCarById(carId);
    if (car == null) return;
    var token = await accsessToken;
    http.Response res = await http.put(MyApi.createCarPOST,
        body: car.toJson(),
        headers: {'Content-type': 'application/json', 'Token': token});
    if (res.statusCode == 401) {
      await refreshToken();
      await putUserCarById(carId);
      return;
    }
  }

  Future<void> loadCarsEvents() async {
    await refreshToken();
    var cars = await carsRepository.getAllCars();
    var token = await accsessToken;
    for (var car in cars) {
      http.Response res = await http.get(
          MyApi.getAllEventsByCarIdGET(car.carId),
          headers: {'Content-type': 'application/json', 'Token': token});
      var carEvents = EventsWrapper.fromJson(res.body);
      await eventsRepository.saveEvents(carEvents.events);
      await eventsRepository.saveFuelEvents(carEvents.fuels);
      await eventsRepository.saveServiceEvents(carEvents.eventServices);
    }
  }

  Future<String> _getLastDateSynchronizedIfPossible() async {
    var status = await sharedPreferences.getStatusFromSharedPreferences();
    if (status == 'Offline') return null;
    var dateUpdate = await sharedPreferences.getTimeSyncWithRemoteDB();
    final difference =
        DateTime.now().difference(DateTime.parse(dateUpdate)).inSeconds;
    if (difference < 5) return null;
    return dateUpdate;
  }

  String _getDateSyncWithDb(){
    var dateTimeNow = DateTime.now();
    dateTimeNow.add(Duration(hours: 3 - dateTimeNow.timeZoneOffset.inHours));
    var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(dateTimeNow);
  }

  Future<void> synchronizeProcess() async {
      var lastDateSync = await _getLastDateSynchronizedIfPossible();
      if (lastDateSync == null) return;
      var user = await userRepository.getUser();
      var listSyncEntities =
          await auditRepository.getAllSyncEntities(lastDateSync);
      var syncContract = new SynchronisationDataContract(
          delete:
              listSyncEntities.where((x) => x.actionType == 'DELETE').toList(),
          post: listSyncEntities.where((x) => x.actionType == 'POST').toList(),
          put: listSyncEntities.where((x) => x.actionType == 'PUT').toList());
      var soapBody = buildSoapBodyXml(user.userId, lastDateSync, syncContract);
      var str = await MyApi.getSynchronisationDataContractPOST(soapBody);
      var list = parseSoapBody(str);
      if (list == null || list.isEmpty)
        return;
      await _synchonizeData(list);
      var dateTime = _getDateSyncWithDb();
      await sharedPreferences.saveTimeSyncWithRemoteDB(dateTime);
      await auditRepository.deleteSyncEntities(dateTime);
  }

  Future<void> _synchonizeData(List<SyncEntity> list) async {
    for (var el in list) {
      try {
        if (el.actionType == "DELETE") {
          if (el.entityName == "CARS") {
            if (el.actionSide == 'Server') {
              await carsRepository.deleteCarFromUser(el.entityId);
            }
          } else if (el.entityName == "EVENTS") {
            if (el.actionSide == 'Server') {
              await eventsRepository.deleteEvent(el.entityId);
            }
          }
        } else if (el.actionType == "POST") {
          if (el.entityName == "CARS") {
            if (el.actionSide == 'Client') {
              await postUserCarById(el.entityId);
            }
            if (el.actionSide == 'Server') {
              await loadUserCarById(el.entityId);
            }
          } else if (el.entityName == "EVENTS") {
            if (el.actionSide == 'Client') {
              await postEventToServer(el.entityId);
            }
            if (el.actionSide == 'Server') {
              await saveEventFromServer(el.entityId);
            }
          }
        } else if (el.actionType == "PUT") {
          if (el.entityName == "CARS") {
            if (el.actionSide == 'Client') {
              await putUserCarById(el.entityId);
            }
            if (el.actionSide == 'Server') {
              await updateUserCarByIdFromServer(el.entityId);
            }
          } else if (el.entityName == "USERS") {
            if (el.actionSide == 'Client') {
              await putUserInfoToServer();
            }
            if (el.actionSide == 'Server') {
              await updateUserInfoByIdFromServer();
            }
          } else if (el.entityName == "CarServices") {
            if (el.actionSide == 'Client') {
              await putServiceEventToServer(el.entityId);
            }
            if (el.actionSide == 'Server') {
              await updateServiceEventByIdFromServer(el.entityId);
            }
          } else if (el.entityName == "Fuels") {
            if (el.actionSide == 'Client') {
              await putFuelEventToServer(el.entityId);
            }
            if (el.actionSide == 'Server') {
              await updateFuelEventByIdFromServer(el.entityId);
            }
          } else if (el.entityName == "EVENTS") {
            if (el.actionSide == 'Client') {
              await putEventToServer(el.entityId);
            }
            if (el.actionSide == 'Server') {
              await updateEventByIdFromServer(el.entityId);
            }
          }
        }
      } catch (E) {}
    }
  }

  String buildSoapBodyXml(String userId, String lastDateSync,
      SynchronisationDataContract syncContract) {
    var xml = '<?xml version="1.0" encoding="utf-8"?> ' +
        '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"> ' +
        '<soap:Body> ' +
        '<GetSynchronizationContract xmlns="http://tempuri.org/"> ' +
        '<userId>$userId</userId> ' +
        '<clientSynchronizationDataContract> ' +
        '<LastSyncDate>$lastDateSync</LastSyncDate> ';
    if (syncContract.delete.isEmpty)
      xml += '<Delete /> ';
    else {
      xml += '<Delete> ';
      for (var m in syncContract.delete) {
        var entityName = m.entityName;
        var entityId = m.entityId;
        var actionSide = "Client";
        var actionDate = m.actionDate;
        xml += '<SyncEntity> ' +
            '<EntityName>$entityName</EntityName> ' +
            '<EntityId>$entityId</EntityId> ' +
            '<ActionDate>$actionDate</ActionDate> ' +
            '<ActionSide>$actionSide</ActionSide> ' +
            '</SyncEntity> ';
      }
      xml += '</Delete> ';
    }
    if (syncContract.post.isEmpty)
      xml += '<Post /> ';
    else {
      xml += '<Post> ';
      for (var m in syncContract.post) {
        var entityName = m.entityName;
        var entityId = m.entityId;
        var actionSide = "Client";
        var actionDate = m.actionDate;
        xml += '<SyncEntity> ' +
            '<EntityName>$entityName</EntityName> ' +
            '<EntityId>$entityId</EntityId> ' +
            '<ActionDate>$actionDate</ActionDate> ' +
            '<ActionSide>$actionSide</ActionSide> ' +
            '</SyncEntity> ';
      }
      xml += '</Post> ';
    }
    if (syncContract.put.isEmpty)
      xml += '<Put /> ';
    else {
      xml += '<Put> ';
      for (var m in syncContract.put) {
        var entityName = m.entityName;
        var entityId = m.entityId;
        var actionSide = "Client";
        var actionDate = m.actionDate;
        xml += '<SyncEntity> ' +
            '<EntityName>$entityName</EntityName> ' +
            '<EntityId>$entityId</EntityId> ' +
            '<ActionDate>$actionDate</ActionDate> ' +
            '<ActionSide>$actionSide</ActionSide> ' +
            '</SyncEntity> ';
      }
      xml += '</Put> ';
    }
    xml += '</clientSynchronizationDataContract> ' +
        '</GetSynchronizationContract> ' +
        '</soap:Body> ' +
        '</soap:Envelope>';
    return xml;
  }

  List<SyncEntity> parseSoapBody(String xmlBody) {
    final document = xml.parse(xmlBody);
    var elements =
        document.findAllElements("SynchronizationDataMember").toList();
    if (elements == null) return null;
    var listWithSyncEntities = new List<SyncEntity>();
    for (var el in elements) {
      var entity = new SyncEntity(
          actionDate: el.findAllElements("ActionDate").first.nodes.first.text,
          actionSide: el.findAllElements("ActionSide").first.nodes.first.text,
          actionType: el.findAllElements("ActionType").first.nodes.first.text,
          entityName: el.findAllElements("Entity").first.nodes.first.text,
          entityId: el.findAllElements("EntityId").first.nodes.first.text);
      listWithSyncEntities.add(entity);
    }
    return listWithSyncEntities;
  }
}
