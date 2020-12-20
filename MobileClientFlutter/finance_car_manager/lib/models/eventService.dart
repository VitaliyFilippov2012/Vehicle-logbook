import 'dart:convert';
import 'package:finance_car_manager/models/details.dart';
import 'package:finance_car_manager/models/event.dart';

class EventService extends Event {
  String serviceId;
  String idTypeService;
  String name;
  List<Details> details;

  String get getServiceId => serviceId;

  set setServiceId(String serviceId) => this.serviceId = serviceId;

  String get getIdTypeService => idTypeService;

  set setIdTypeService(String idTypeService) =>
      this.idTypeService = idTypeService;

  String get getName => name;

  set setName(String name) => this.name = name;

  List get getDetails => details;

  set setDetails(List details) => this.details = details;

  EventService.service(
    this.serviceId,
    this.idTypeService,
    this.name,
    this.details,
  );

  EventService.toEvent(
    eventId,
    idTypeEvents,
    idUser,
    idCar,
    date,
    costs,
    unitPrice,
    comment,
    mileage,
    photo,
    addressStation,
    this.serviceId,
    this.idTypeService,
    this.name,
    this.details,
  ) : super.events(eventId, idTypeEvents, idUser, idCar, date, costs, unitPrice,
            comment, mileage, photo, addressStation);

  Map<String, dynamic> toServiceMap() {
    return {
      'serviceId': serviceId,
      'idTypeService': idTypeService,
      'name': name,
      'idEvent': eventId
    };
  }

  Map<String, dynamic> toServiceWithDetailsMap() {
    return {
      'serviceId': serviceId,
      'idTypeService': idTypeService,
      'name': name,
      'idEvent': eventId,
      'details': details?.map((x) => x?.toMap())?.toList(),
    };
  }

  Map<String, dynamic> toServiceUpdateMap() {
    return {
      'idTypeService': idTypeService,
      'name': name,
    };
  }

  Map<String, dynamic> toFullEventMap() {
    return {
      'serviceId': serviceId,
      'idTypeService': idTypeService,
      'name': name,
      'details': details?.map((x) => x?.toMap())?.toList(),
      'eventId': eventId,
      'idTypeEvents': idTypeEvents,
      'idUser': idUser,
      'idCar': idCar,
      'date': date,
      'costs': costs,
      'unitPrice': unitPrice,
      'comment': comment,
      'mileage': mileage,
      'photo': photo,
      'addressStation': addressStation,
    };
  }

  static EventService fromMap(Map<String, dynamic> map) {
    return EventService.service(
      map['serviceId'],
      map['idTypeService'],
      map['name'],
      List<Details>.from(map['details']?.map((x) => Details.fromMap(x))),
    );
  }

  static EventService fromEventMap(Map<String, dynamic> map) {
    if (map == null) return null;
    var jsonValue = jsonEncode(map['costs']);
    var costs = double.parse(jsonValue);
    jsonValue = jsonEncode(map['unitPrice']);
    var unitPrice = double.parse(jsonValue);
    jsonValue = jsonEncode(map['mileage']);
    var mileage = int.parse(jsonValue);
    var date = jsonEncode(map['date']).substring(1,11);
    return EventService.toEvent(
      map['eventId'],
      map['idTypeEvents'],
      map['idUser'],
      map['idCar'],
      date,
      costs,
      unitPrice,
      map['comment'],
      mileage,
      map['photo'],
      map['addressStation'],
      map['serviceId'],
      map['idTypeService'],
      map['name'],
      map.containsKey('details') ? List<Details>.from(map['details']?.map((x) => Details.fromMap(x))) : new List<Details>(),
    );
  }

  String toJson() => json.encode(toFullEventMap());

  static EventService fromJson(String source) => fromMap(json.decode(source));
}
