import 'dart:convert';

class CircleGraphInfo {
  String carId;
  double value;
  double volume;
  String name;
  DateTime day;
  CircleGraphInfo({
    this.carId,
    this.value,
    this.volume,
    this.name,
    this.day,
  });

  static CircleGraphInfo fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    var jsonValue = jsonEncode(map['costs']);
    if(jsonValue == 'null')
      jsonValue = jsonEncode(map['volume']);
    if(jsonValue == 'null')
      jsonValue = '0';
    var value = double.parse(jsonValue);
    var date = DateTime.parse(map['day']);
    return CircleGraphInfo(
      carId: map['idCar'],
      name: map['name'],
      value: value,
      day: date,
    );
  }

  static CircleGraphInfo fromFuelMap(Map<String, dynamic> map) {
    if (map == null) return null;
    var jsonValue = jsonEncode(map['costs']);
    var value = double.parse(jsonValue);
    jsonValue = jsonEncode(map['volume']);
    var volume = double.parse(jsonValue);
    var date = DateTime.parse(map['day']);
    return CircleGraphInfo(
      carId: map['idCar'],
      volume: volume,
      value: value,
      day: date,
    );
  }

  static CircleGraphInfo fromJson(String source) => fromMap(json.decode(source));
}
