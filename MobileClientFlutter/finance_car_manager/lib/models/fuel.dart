import 'dart:convert';
import 'package:finance_car_manager/models/event.dart';

class Fuel extends Event {
  String fuelId;
  double volume;
  double get getVolume => volume;

  set setVolume(double volume) => this.volume = volume;
  Fuel.fuel({
    this.fuelId,
    this.volume,
  });

  Fuel.toEvent(
    this.fuelId,
    this.volume,
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
  ) : super.events(eventId, idTypeEvents, idUser, idCar, date, costs, unitPrice,
            comment, mileage, photo, addressStation);

  Map<String, dynamic> toFuelMap() {
    return {'fuelId': fuelId, 'volume': volume, 'idEvent': eventId};
  }

  Map<String, dynamic> toFuelUpdateMap() {
    return {'volume': volume};
  }

  Map<String, dynamic> toFullEventMap() {
    return {
      'fuelId': fuelId,
      'volume': volume,
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

  static Fuel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Fuel.fuel(
      fuelId: map['fuelId'],
      volume: map['volume'],
    );
  }

  static Fuel fromEventMap(Map<String, dynamic> map) {
    if (map == null) return null;
    var jsonValue = jsonEncode(map['costs']);
    var costs = double.parse(jsonValue);
    jsonValue = jsonEncode(map['unitPrice']);
    var unitPrice = double.parse(jsonValue);
    jsonValue = jsonEncode(map['mileage']);
    var mileage = int.parse(jsonValue);
    jsonValue = jsonEncode(map['volume']);
    var volume = double.parse(jsonValue);
    var date = jsonEncode(map['date']).substring(1,11);
    return Fuel.toEvent(
      map['fuelId'],
      volume,
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

  String toJson() => json.encode(toFullEventMap());

  static Fuel fromJson(String source) => fromMap(json.decode(source));
}
