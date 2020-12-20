import 'dart:convert';

class GraphInfo{
  String carId;
  double value;
  DateTime day;
  GraphInfo({
    this.carId,
    this.value,
    this.day,
  });

  static GraphInfo fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    var jsonValue = jsonEncode(map['COSTS_FOR_DAY']);
    if(jsonValue == 'null')
      jsonValue = jsonEncode(map['mileage']);
    if(jsonValue == 'null')
      jsonValue = '0';
    var value = double.parse(jsonValue);
    var date = DateTime.parse(map['DAY']);
    return GraphInfo(
      carId: map['CarId'],
      value: value,
      day: date,
    );
  }

  static GraphInfo fromFuelMap(Map<String, dynamic> map) {
    if (map == null) return null;
    var jsonValue = jsonEncode(map['volume']);
    var value = double.parse(jsonValue);
    var date = DateTime.parse(map['day']);
    return GraphInfo(
      carId: map['idCar'],
      value: value,
      day: date,
    );
  }

  static GraphInfo fromJson(String source) => fromMap(json.decode(source));
}
