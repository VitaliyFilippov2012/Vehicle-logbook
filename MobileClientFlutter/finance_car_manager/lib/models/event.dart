import 'dart:convert';
import 'package:finance_car_manager/models/category.dart';

class Event {
  String eventId;
  String idTypeEvents;
  String idUser;
  String idCar;
  String date;
  double costs;
  double unitPrice;
  String comment;
  int mileage;
  String photo;

  String get getPhoto => photo;
  set setPhoto(String photo) => this.photo = photo;
  String addressStation;
  String get getEventId => eventId;

  set setEventId(String eventId) => this.eventId = eventId;

  String get getIdTypeEvents => idTypeEvents;

  set setIdTypeEvents(String idTypeEvents) => this.idTypeEvents = idTypeEvents;

  String get getIdUser => idUser;

  set setIdUser(String idUser) => this.idUser = idUser;

  String get getIdCar => idCar;

  set setIdCar(String idCar) => this.idCar = idCar;

  String get getComment => comment;

  set setComment(String comment) => this.comment = comment;

  String get getAddressStation => addressStation;

  set setAddressStation(String addressStation) =>
      this.addressStation = addressStation;

  Event(
  );

  Event.events(
    this.eventId,
    this.idTypeEvents,
    this.idUser,
    this.idCar,
    this.date,
    this.costs,
    this.unitPrice,
    this.comment,
    this.mileage,
    this.photo,
    this.addressStation,
  );

  Map<String, dynamic> toMap() {
    return {
      'eventId': eventId,
      'idTypeEvents': idTypeEvents,
      'idUser': idUser,
      'idCar': idCar,
      'date': date,
      'costs': costs,
      'unitPrice': unitPrice ?? 0.0,
      'comment': comment,
      'mileage': mileage,
      'photo': photo,
      'addressStation': addressStation,
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return {
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

  static Event fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    var jsonValue = jsonEncode(map['costs']);
    var costs = double.parse(jsonValue);
    jsonValue = jsonEncode(map['unitPrice']);
    var unitPrice = jsonValue == 'null' ? 0.0 : double.parse(jsonValue);
    jsonValue = jsonEncode(map['mileage']);
    var mileage = jsonValue == 'null' ? 0 : int.parse(jsonValue);
    var date = jsonEncode(map['date']).substring(1,11);
    return Event.events(
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
    );
  }

  String toJson() => json.encode(toMap());

  static Event fromJson(String source) => fromMap(json.decode(source));

  String getDefaultImagePathByType(){
    if(this.idTypeEvents == categories[2].categoryId)
      return "assets/images/default-photo-fuel.jpg";
    else if(this.idTypeEvents == categories[3].categoryId)
      return "assets/images/default-photo-service.jpg";
    else
      return "assets/images/default-photo-event.jpg";
  }
}
