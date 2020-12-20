import 'dart:convert';
import 'package:finance_car_manager/models/UserInfo.dart';
import 'package:finance_car_manager/models/car.dart';
import 'package:finance_car_manager/models/details.dart';
import 'package:finance_car_manager/models/event.dart';
import 'package:finance_car_manager/models/eventService.dart';
import 'package:finance_car_manager/models/fuel.dart';
import 'package:finance_car_manager/models/graphInfo.dart';
import 'package:finance_car_manager/models/circleGraphInfo.dart';
import 'package:finance_car_manager/synchronization/syncEntity.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import 'package:finance_car_manager/models/type.dart';
import 'dart:async';

class DbProvider {
  static final DbProvider _instance = DbProvider.internal();

  factory DbProvider() => _instance;
  static Database _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDB();
    }
    return _db;
  }

  DbProvider.internal();
  _initDB() async {
    String documentsDirectory = await getDatabasesPath();
    final path = join(documentsDirectory, "carFinanceManagerdb.db");
    var db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database newDb, int version) {
        newDb.execute("CREATE TABLE Users( " +
            "userId TEXT PRIMARY KEY, " +
            "sex TEXT check (Sex in ('m','f')) not null, " +
            "birthday TEXT not null, " +
            "name TEXT not null, " +
            "lastname TEXT not null, " +
            "patronymic TEXT not null, " +
            "address TEXT not null, " +
            "phone TEXT, " +
            "city TEXT not null, " +
            "photo TEXT); ");
        newDb.execute("CREATE TABLE Cars( " +
            "carId TEXT PRIMARY KEY, " +
            "typeFuel TEXT not null, " +
            "typeTransmission TEXT not null, " +
            "mark TEXT not null, " +
            "model TEXT not null, " +
            "volumeEngine INTEGER not null, " +
            "power INTEGER not null, " +
            "active NUMERIC default(1) not null, " +
            "vin NUMERIC unique not null, " +
            "comment TEXT, " +
            "photo TEXT, " +
            "yearIssue INTEGER TEXT not null) ");
        newDb.execute("CREATE TABLE TypeEvents( " +
            "typeEventId TEXT PRIMARY KEY, " +
            "TypeName TEXT unique not null) ");
        newDb.execute("CREATE TABLE CarEvents( " +
            "eventId TEXT PRIMARY KEY, " +
            "idTypeEvents TEXT not null, " +
            "idUser TEXT not null, " +
            "idCar TEXT not null, " +
            "date TEXT not null, " +
            "costs NUMERIC not null, " +
            "unitPrice NUMERIC, " +
            "comment TEXT, " +
            "mileage NUMERIC, " +
            "addressStation TEXT, " +
            "photo TEXT, " +
            "FOREIGN KEY(idTypeEvents) REFERENCES TypeEvents(typeEventId), " +
            "FOREIGN KEY(idUser) REFERENCES Users(userId), " +
            "FOREIGN KEY(idCar) REFERENCES Cars(carId)) ");
        newDb.execute("CREATE TABLE Fuels( " +
            "fuelId TEXT PRIMARY KEY, " +
            "idEvent TEXT not null, " +
            "volume NUMERIC not null, " +
            "FOREIGN KEY(idEvent) REFERENCES CarEvents(eventId) ON DELETE CASCADE) ");
        newDb.execute("CREATE TABLE TypeServices( " +
            "typeServiceId TEXT PRIMARY KEY, " +
            "TypeName TEXT unique not null) ");
        newDb.execute("CREATE TABLE CarServices( " +
            "serviceId TEXT PRIMARY KEY, " +
            "idEvent TEXT not null, " +
            "idTypeService TEXT not null, " +
            "name TEXT, " +
            "FOREIGN KEY(idEvent) REFERENCES CarEvents(eventId) ON DELETE CASCADE, " +
            "FOREIGN KEY(idTypeService) REFERENCES TypeServices(typeServiceId)) ");
        newDb.execute("CREATE TABLE Details( " +
            "detailId TEXT PRIMARY KEY, " +
            "idCar TEXT not null, " +
            "idService TEXT not null, " +
            "name TEXT, " +
            "type TEXT, " +
            "FOREIGN KEY(idCar) REFERENCES Cars(carId), " +
            "FOREIGN KEY(idService) REFERENCES CarServices(serviceId) ON DELETE CASCADE); ");
        newDb.execute("CREATE TABLE ActionAudit( " +
            "entity TEXT not null, " +
            "entityId TEXT not null, " +
            "idUser TEXT DEFAULT (datetime('now')), " +
            "action TEXT, " +
            "dateUpdate TEXT DEFAULT (datetime('now')), " +
            "PRIMARY KEY (entity, dateUpdate, entityId)); ");
        newDb.execute("CREATE VIEW MILEAGE_CARS_FOREVERYDAY AS " +
            "WITH RECURSIVE dates(DAY) AS ( " +
            "SELECT date('now','start of month') " +
            "UNION ALL " +
            "SELECT date(DAY,'+1 day') FROM dates " +
            "WHERE DAY < date('now')) " +
            "SELECT * FROM (SELECT D.DAY as DAY, C.carId AS CarId FROM dates as D " +
            "CROSS JOIN (SELECT carId from Cars) as C) AS DC " +
            "LEFT JOIN (SELECT CE1.date, CE.idCar, max(CE1.MILEAGE) - max(CE.MILEAGE) AS mileage " +
            "FROM CarEvents AS CE " +
            "INNER JOIN CarEvents AS CE1 " +
            "ON CE.idCar = CE1.idCar " +
            "WHERE CE.date = (SELECT E.date FROM CarEvents AS E WHERE E.idCar = CE.idCar AND E.DATE < CE1.date ORDER BY E.date DESC LIMIT 1) " +
            "GROUP BY CE.date, CE1.date, CE.idCar) AS MD " +
            "ON MD.date = DC.DAY AND DC.carId = MD.idCar ");
        newDb.execute("CREATE VIEW COSTS_GROUPBYDATE AS " +
            "WITH RECURSIVE dates(DAY) AS (  " +
            "SELECT date('now','start of month')  " +
            "UNION ALL  " +
            "SELECT date(DAY,'+1 day') FROM dates  " +
            "WHERE DAY < date('now'))  " +
            "SELECT DC.DAY, DC.carId, E.COSTS_FOR_DAY  " +
            "FROM (SELECT D.DAY as DAY, C.carId AS CarId FROM dates as D  " +
            "CROSS JOIN (SELECT carId from Cars) as C) AS DC  " +
            "LEFT JOIN (SELECT date, idCar, sum(costs) AS COSTS_FOR_DAY  " +
            "FROM CarEvents GROUP BY date, idCar) AS E  " +
            "ON DC.DAY = E.DATE AND DC.carId = E.idCar ");
        newDb.execute("CREATE VIEW COSTS_BY_TYPE_FOR_DAY AS " +
            "SELECT CE.date as day, CE.idCar as idCar, sum(CE.costs) as costs, T.TypeName as name " +
            "FROM CarEvents AS CE " +
            "INNER JOIN TypeEvents AS T " +
            "ON T.typeEventId = CE.idTypeEvents "+
            "GROUP BY date, idCar, idTypeEvents ");
        newDb.execute("CREATE VIEW COSTS_BY_TYPE_GROUPBYTYPE AS " +
            "SELECT CE.date as day, CE.idCar as idCar, sum(CE.costs) as costs, T.TypeName as name " +
            "FROM CarEvents AS CE " +
            "INNER JOIN TypeEvents AS T " +
            "ON T.typeEventId = CE.idTypeEvents "+
            "GROUP BY idCar, idTypeEvents ");
        newDb.execute("CREATE VIEW COSTS_FUEL_FOR_DAY_WITH_VOLUME AS " +
            "SELECT CE.date as day, CE.idCar as idCar, sum(CE.costs) as costs, SUM(F.VOLUME) AS volume " +
            "FROM CarEvents AS CE " +
            "INNER JOIN Fuels AS F " +
            "ON F.idEvent = CE.eventId "+
            "GROUP BY date, idCar ");
        newDb.execute("CREATE VIEW COSTS_VOLUME_FOR_DAY AS " +
            "SELECT CE.date as DAY, avg(CE.unitPrice) as COSTS_FOR_DAY, CE.idCar as CarId " +
            "FROM Fuels AS F " +
            "INNER JOIN CarEvents AS CE " +
            "ON CE.eventId = F.idEvent "+
            "GROUP BY date, idCar ");
        createTriggers(newDb);
      },
    );
    return db;
  }

  void createTriggers(Database newDb) {
    newDb.execute("CREATE TRIGGER AuditTriggerUsers AFTER UPDATE ON USERS " +
        "BEGIN " +
        "INSERT INTO ActionAudit ([Entity], [EntityId] ,[IdUser] ,[Action] ,[DateUpdate]) " +
        "VALUES ('USERS', NEW.userId, NEW.userId , 'PUT', (SELECT datetime('now', 'localtime'))); " +
        "END");
    newDb.execute("CREATE TRIGGER AuditTrigger_Cars AFTER UPDATE ON CARS " +
        "BEGIN " +
        "INSERT INTO [ActionAudit] ([Entity], [EntityId] ,[IdUser] ,[Action] ,[DateUpdate]) " +
        "VALUES ('CARS', NEW.carId , (SELECT userId FROM Users) , 'PUT', (SELECT datetime('now', 'localtime'))); " +
        "END");
    newDb.execute("CREATE TRIGGER AuditTrigger_DelCars AFTER DELETE ON CARS " +
        "BEGIN INSERT INTO [ActionAudit] ([Entity], [EntityId] ,[IdUser] ,[Action] ,[DateUpdate]) " +
        "VALUES ('CARS', OLD.carId , (SELECT userId FROM Users) , 'DELETE', (SELECT datetime('now', 'localtime'))); END ");
    newDb.execute("CREATE TRIGGER AuditTrigger_AddCar AFTER INSERT ON CARS " +
        "BEGIN INSERT INTO [ActionAudit] ([Entity], [EntityId] ,[IdUser] ,[Action] ,[DateUpdate]) " +
        "VALUES ('CARS', NEW.carId , (SELECT userId FROM Users) , 'POST', (SELECT datetime('now', 'localtime'))); END ");
    newDb.execute(
        "CREATE TRIGGER AuditTrigger_CarServices AFTER Update ON CarServices " +
            "BEGIN " +
            "INSERT INTO [ActionAudit] ([Entity], [EntityId] ,[IdUser] ,[Action] ,[DateUpdate]) " +
            "VALUES ('CarServices', NEW.idEvent, (SELECT userId FROM Users), 'PUT', (SELECT datetime('now', 'localtime'))); " +
            "END");
    newDb.execute("CREATE TRIGGER AuditTrigger_Fuels AFTER Update ON Fuels " +
        "BEGIN " +
        "INSERT INTO [ActionAudit] ([Entity], [EntityId] ,[IdUser] ,[Action] ,[DateUpdate]) " +
        "VALUES ('Fuels', NEW.idEvent, (SELECT userId FROM Users), 'PUT', (SELECT datetime('now', 'localtime'))); " +
        "END");
    newDb.execute(
        "CREATE TRIGGER AuditTrigger_DetailsSetCar AFTER INSERT ON Details " +
            "BEGIN " +
            "UPDATE Details " +
            "SET idCar = (SELECT idCar FROM CarEvents WHERE eventId IN (SELECT idEvent FROM CarServices WHERE serviceId = NEW.idService )) " +
            "where detailId = NEW.detailId; " +
            "END");
    newDb.execute(
        "CREATE TRIGGER AuditTrigger_CarEventsInsert AFTER INSERT ON CarEvents " +
            "BEGIN " +
            "INSERT INTO [ActionAudit] ([Entity], [EntityId] ,[IdUser] ,[Action] ,[DateUpdate]) " +
            "VALUES ('EVENTS', NEW.eventId , (SELECT userId FROM Users), 'POST', (SELECT datetime('now', 'localtime'))); " +
            "END");
    newDb.execute(
        "CREATE TRIGGER AuditTrigger_CarEventsUpdate AFTER UPDATE ON CarEvents " +
            "BEGIN " +
            "INSERT INTO [ActionAudit] ([Entity], [EntityId] ,[IdUser] ,[Action] ,[DateUpdate]) " +
            "VALUES ('EVENTS', NEW.eventId , (SELECT userId FROM Users), 'PUT', (SELECT datetime('now', 'localtime'))); " +
            "END");
    newDb.execute(
        "CREATE TRIGGER AuditTrigger_CarEventsDelete AFTER DELETE ON CarEvents " +
            "BEGIN " +
            "INSERT INTO [ActionAudit] ([Entity], [EntityId] ,[IdUser] ,[Action] ,[DateUpdate]) " +
            "VALUES ('EVENTS', OLD.eventId , (SELECT userId FROM Users), 'DELETE', (SELECT datetime('now', 'localtime'))); " +
            "END");
  }

  void dropTriggers(Database newDb) {
    newDb.execute("DROP TRIGGER AuditTriggerUsers ");
    newDb.execute("DROP TRIGGER AuditTrigger_Cars ");
    newDb.execute("DROP TRIGGER AuditTrigger_CarServices ");
    newDb.execute("DROP TRIGGER AuditTrigger_Fuels ");
    newDb.execute("DROP TRIGGER AuditTrigger_DelCars ");
    newDb.execute("DROP TRIGGER AuditTrigger_AddCar ");
    newDb.execute("DROP TRIGGER AuditTrigger_DetailsSetCar ");
    newDb.execute("DROP TRIGGER AuditTrigger_CarEventsInsert ");
    newDb.execute("DROP TRIGGER AuditTrigger_CarEventsUpdate ");
    newDb.execute("DROP TRIGGER AuditTrigger_CarEventsDelete ");
  }

  void clearAllTable(Database newDb) {
    dropTriggers(newDb);
    newDb.execute("DELETE FROM ActionAudit ");
    newDb.execute("DELETE FROM CarEvents ");
    newDb.execute("DELETE FROM Cars ");
    newDb.execute("DELETE FROM Users ");
    newDb.execute("DELETE FROM ActionAudit ");
    newDb.execute("DELETE FROM TypeServices ");
    newDb.execute("DELETE FROM TypeEvents ");
  }

  Future<List<Car>> getAllCars() async {
    var dbClient = await db;
    var res = await dbClient.rawQuery('SELECT * FROM Cars');
    List<Car> cars = new List<Car>();
    for (var car in res) {
      cars.add(Car.fromMap(car));
    }
    return cars;
  }

  Future<Car> getCarById(String id) async {
    var dbClient = await db;
    final maps = await dbClient
        .query("Cars", columns: null, where: "carId = ?", whereArgs: [id]);

    if (maps.length > 0) {
      return Car.fromMap(maps.first);
    }

    return null;
  }

  Future<int> addCar(Car car) async {
    var dbClient = await db;
    return dbClient.insert("Cars", car.toMap());
  }

  Future<int> updateCar(Car car) async {
    var dbClient = await db;
    return dbClient.update("Cars", car.toUpdateMap(),
        where: "carId = ?", whereArgs: [car.carId]);
  }

  Future<int> saveCar(Car car) async {
    var dbClient = await db;
    return dbClient.insert("Cars", car.toMap());
  }

  Future<UserInfo> getUserInfo() async {
    var dbClient = await db;
    final maps = await dbClient.rawQuery('SELECT * FROM Users');

    if (maps.length > 0) {
      return UserInfo.fromMap(maps.first);
    }

    return null;
  }

  Future<List<CircleGraphInfo>> getCostsByTypeByCarId(String idCar) async {
    var dbClient = await db;
    final res = await dbClient.rawQuery("SELECT * FROM COSTS_BY_TYPE_FOR_DAY WHERE idCar = '$idCar'");

    var graphInfo = new List<CircleGraphInfo>();
    for (var car in res) {
      graphInfo.add(CircleGraphInfo.fromMap(car));
    }
    return graphInfo;
  }

  Future<List<GraphInfo>> getCostsFuelVolumeForDayByCarId(String idCar) async {
    var dbClient = await db;
    final res = await dbClient.rawQuery("SELECT * FROM COSTS_VOLUME_FOR_DAY WHERE CarId = '$idCar'");

    var graphInfo = new List<GraphInfo>();
    for (var car in res) {
      graphInfo.add(GraphInfo.fromMap(car));
    }
    return graphInfo;
  }

  Future<List<CircleGraphInfo>> getFuelCostsByCarId(String idCar) async {
    var dbClient = await db;
    final res = await dbClient.rawQuery("SELECT * FROM COSTS_FUEL_FOR_DAY_WITH_VOLUME WHERE idCar = '$idCar'");

    var graphInfo = new List<CircleGraphInfo>();
    for (var car in res) {
      graphInfo.add(CircleGraphInfo.fromFuelMap(car));
    }
    return graphInfo;
  }

  Future<List<GraphInfo>> getSumPouredVolumeForDayByCarId(String idCar) async {
    var dbClient = await db;
    final res = await dbClient.rawQuery("SELECT * FROM COSTS_FUEL_FOR_DAY_WITH_VOLUME WHERE idCar = '$idCar'");

    var graphInfo = new List<GraphInfo>();
    for (var car in res) {
      graphInfo.add(GraphInfo.fromFuelMap(car));
    }
    return graphInfo;
  }

  Future<List<CircleGraphInfo>> getCostsByGroupTypeByCarId(String idCar) async {
    var dbClient = await db;
    final res = await dbClient.rawQuery("SELECT * FROM COSTS_BY_TYPE_GROUPBYTYPE WHERE idCar = '$idCar'");

    var graphInfo = new List<CircleGraphInfo>();
    for (var car in res) {
      graphInfo.add(CircleGraphInfo.fromMap(car));
    }
    return graphInfo;
  }

  Future<List<GraphInfo>> getMileagesForEveryDayByCarId(String carId) async {
    var dbClient = await db;
    final res = await dbClient.rawQuery("SELECT * FROM MILEAGE_CARS_FOREVERYDAY WHERE carId = '$carId'");

    List<GraphInfo> graphInfo = new List<GraphInfo>();
    for (var car in res) {
      graphInfo.add(GraphInfo.fromMap(car));
    }
    return graphInfo;
  }

  Future<List<GraphInfo>> getTotalMileagesByCarId(String carId) async {
    var dbClient = await db;
    final res = await dbClient.rawQuery("SELECT * FROM MILEAGE_CARS_FOREVERYDAY WHERE carId = '$carId' AND mileage is NOT NULL");

    List<GraphInfo> graphInfo = new List<GraphInfo>();
    for (var car in res) {
      graphInfo.add(GraphInfo.fromMap(car));
    }
    return graphInfo;
  }

  Future<List<GraphInfo>> getCostsForEveryDayByCarId(String carId) async {
    var dbClient = await db;
    final res = await dbClient.rawQuery("SELECT * FROM COSTS_GROUPBYDATE WHERE carId = '$carId'");

    List<GraphInfo> graphInfo = new List<GraphInfo>();
    for (var car in res) {
      graphInfo.add(GraphInfo.fromMap(car));
    }
    return graphInfo;
  }

  Future clearDatabase() async {
    var dbClient = await db;
    clearAllTable(dbClient);
    return;
  }

  Future clearTriggers() async {
    var dbClient = await db;
    dropTriggers(dbClient);
  }

  Future addTriggers() async {
    var dbClient = await db;
    createTriggers(dbClient);
  }

  Future<int> addUserInfo(UserInfo user) async {
    var dbClient = await db;
    return dbClient.insert("Users", user.toMap());
  }

  Future<void> addEventTypes(List<Type> eventTypes) async {
    var dbClient = await db;
    for (var t in eventTypes) {
      await dbClient.insert("TypeEvents", t.toEventTypeMap());
    }
  }

  Future<void> addServiceTypes(List<Type> serviceTypes) async {
    var dbClient = await db;
    for (var t in serviceTypes) {
      await dbClient.insert("TypeServices", t.toServiceTypeMap());
    }
  }

  Future<int> updateUser(UserInfo user) async {
    var dbClient = await db;
    return dbClient.update("Users", user.toMap());
  }

  Future<List<Event>> getAllEventsForCar(String carId) async {
    var dbClient = await db;
    final res = await dbClient.query("CarEvents",
        columns: null, where: "idCar = ?", whereArgs: [carId]);
    List<Event> events = new List<Event>();
    for (var e in res) {
      events.add(Event.fromMap(e));
    }
    return events;
  }

  Future<List<SyncEntity>> getAllSyncEntities(String dateSync) async {
    var dbClient = await db;
    final res = await dbClient.rawQuery("SELECT * FROM ActionAudit ");
    List<SyncEntity> events = new List<SyncEntity>();
    for (var e in res) {
      events.add(SyncEntity.fromMap(e));
    }
    return events.where((x) => x.actionDate.compareTo(dateSync) == 1).toList();
  }

  Future<List<SyncEntity>> deleteSyncEntities(String dateTime) async {
    var dbClient = await db;
    try {
      await dbClient
          .rawQuery("DELETE FROM ActionAudit WHERE dateUpdate  < '$dateTime'");
    } catch (E) {}
  }

  Future<void> deleteCar(String carId) async {
    var dbClient = await db;
    await dbClient
        .execute("UPDATE Cars SET active = 0 WHERE carId = '$carId' ");
  }

  Future<void> deleteCarFromUser(String carId) async {
    var dbClient = await db;
    await dbClient.execute("DELETE FROM Cars WHERE carId = '$carId' ");
  }

  Future<int> getMaxMileageInCar(String carId) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery(
        "SELECT max(MILEAGE) as maxMileage FROM CarEvents WHERE idCar = '$carId'");
    if (res.length > 0) {
      var jsonValue = jsonEncode(res.first['maxMileage']);
      var mileage = jsonValue == 'null' ? 0 : int.parse(jsonValue);
      return mileage;
    }
    return 0;
  }

  Future<void> deleteEvent(String eventId) async {
    var dbClient = await db;
    return await dbClient
        .execute("DELETE FROM CarEvents WHERE eventId = '$eventId' ");
  }

  Future<List<Event>> getAllEventsByTypeIdForCar(
      String carId, String typeId) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery('SELECT * FROM CarEvents ' +
        "Where idCar = '$carId' AND idTypeEvents = '$typeId' ");
    List<Event> events = new List<Event>();
    for (var e in res) {
      events.add(Event.fromMap(e));
    }
    return events;
  }

  Future<Event> getEventById(String id) async {
    var dbClient = await db;
    final maps = await dbClient
        .rawQuery("SELECT * FROM CarEvents Where eventId = '$id' ");

    if (maps.length > 0) {
      return Event.fromMap(maps.first);
    }
    return null;
  }

  Future<List<EventService>> getAllServiceEventsForCar(String carId) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery('SELECT * FROM CarServices as s ' +
        'INNER JOIN CarEvents as e ' +
        'on e.eventId = s.idEvent ' +
        "Where e.idCar = '$carId' ");
    List<EventService> events = new List<EventService>();
    for (var e in res) {
      var service = EventService.fromEventMap(e);
      var id = service.serviceId;
      var sqlDetails = 'SELECT * FROM Details ' + "WHERE idService = '$id' ";
      final detailsRes = await dbClient.rawQuery(sqlDetails);
      for (var d in detailsRes) {
        service.details.add(Details.fromMap(d));
      }
      events.add(service);
    }
    return events;
  }

  Future<EventService> getServiceEventById(String id) async {
    var dbClient = await db;
    var sql = 'Select * FROM (SELECT * FROM CarServices ' +
        "Where idEvent = '$id') as f " +
        'INNER JOIN CarEvents as e ' +
        'on e.eventId = f.idEvent ';
    final maps = await dbClient.rawQuery(sql);

    if (maps.length > 0) {
      var event = EventService.fromEventMap(maps.first);
      var id = event.serviceId;
      var sqlDetails = "SELECT * FROM Details WHERE idService = '$id'";
      final res = await dbClient.rawQuery(sqlDetails);
      for (var e in res) {
        try {
          var d = Details.fromMap(e);
          event.details.add(d);
        } catch (E) {}
      }
      return event;
    }
    return null;
  }

  Future<int> updateEvent(Event event) async {
    var dbClient = await db;
    return dbClient.update("CarEvents", event.toUpdateMap(),
        where: "eventId = ?", whereArgs: [event.eventId]);
  }

  Future<int> updateFuelEvent(Fuel event) async {
    var isUpdateEvent = await updateEvent(event);
    if (isUpdateEvent == -1) return -1;
    var dbClient = await db;
    return dbClient.update("Fuels", event.toFuelUpdateMap(),
        where: "idEvent = ?", whereArgs: [event.eventId]);
  }

  Future<int> updateServiceEvent(EventService event) async {
    var isUpdateEvent = await updateEvent(event);
    if (isUpdateEvent == -1) return -1;
    var dbClient = await db;
    var isUpdateServiceEvent = await dbClient.update(
        "CarServices", event.toServiceUpdateMap(),
        where: "serviceId = ?", whereArgs: [event.serviceId]);
    if (isUpdateServiceEvent == -1) return -1;
    for (var details in event.details) {
      dbClient.update("Details", details.toUpdateMap(),
          where: "detailId = ?", whereArgs: [details.detailsId]);
    }
    return 1;
  }

  Future<List<Fuel>> getAllFuelEventsForCar(String carId) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery('SELECT * FROM CarEvents as e ' +
        'INNER JOIN Fuels as f ' +
        'on f.idEvent = e.eventId ' +
        "Where idCar = '$carId'");
    List<Fuel> events = new List<Fuel>();
    for (var e in res) {
      events.add(Fuel.fromEventMap(e));
    }
    return events;
  }

  Future<Fuel> getFuelEventById(String id) async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps;
    try {
      maps = await dbClient.rawQuery('SELECT * FROM CarEvents as e ' +
          'INNER JOIN Fuels as f ' +
          'on e.eventId = f.idEvent ' +
          "WHERE idEvent = '$id' ");
    } catch (E) {}

    if (maps.length > 0) {
      return Fuel.fromEventMap(maps.first);
    }
    return null;
  }

  Future<int> addFuelEvent(Event event) async {
    var dbClient = await db;
    return dbClient.insert("Events", event.toMap());
  }

  Future<int> saveEvent(Event event) async {
    var dbClient = await db;
    return dbClient.insert("CarEvents", event.toMap());
  }

  Future<List<Type>> getTypeService() async {
    var dbClient = await db;
    var res = await dbClient.rawQuery('SELECT * FROM TypeServices ');
    List<Type> type = new List<Type>();
    for (var e in res) {
      var t = Type.fromMap(e);
      type.add(t);
    }
    return type;
  }

  Future<int> saveFuelEvent(Fuel event) async {
    var isUpdateEvent = await saveEvent(event);
    if (isUpdateEvent == -1) return -1;
    var dbClient = await db;
    return dbClient.insert("Fuels", event.toFuelMap());
  }

  Future<int> saveServiceEvent(EventService event) async {
    var isUpdateEvent = await saveEvent(event);
    if (isUpdateEvent == -1) return -1;
    var dbClient = await db;
    var isUpdateServiceEvent =
        await dbClient.insert("CarServices", event.toServiceMap());
    if (isUpdateServiceEvent == -1) return -1;
    for (var details in event.details) {
      dbClient.insert(
          "Details",
          details.toSaveMap(event.idCar, event.serviceId,
              Uuid().v4().toString().toUpperCase()));
    }
    return 1;
  }
}