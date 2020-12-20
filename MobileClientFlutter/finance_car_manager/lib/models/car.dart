import 'dart:convert';

class Car {
  String carId;
  String typeFuel;
  String typeTransmission;
  String mark;
  String model;
  int volumeEngine;
  int power;
  bool active;
  int vin;
  String comment;
  String photo;

  String get getPhoto => photo;

  set setPhoto(String photo) => this.photo = photo;
  int yearIssue;
  String get getTypeFuel => typeFuel;

  set setTypeFuel(String typeFuel) => this.typeFuel = typeFuel;

  String get getTypeTransmission => typeTransmission;

  set setTypeTransmission(String typeTransmission) =>
      this.typeTransmission = typeTransmission;

  String get getMark => mark;

  set setMark(String mark) => this.mark = mark;

  String get getModel => model;

  set setModel(String model) => this.model = model;

  int get getVolumeEngine => volumeEngine;

  set setVolumeEngine(int volumeEngine) => this.volumeEngine = volumeEngine;

  int get getPower => power;

  set setPower(int power) => this.power = power;

  bool get getActive => active;

  set setActive(bool active) => this.active = active;

  int get getVin => vin;

  set setVin(int vin) => this.vin = vin;

  String get getComment => comment;

  set setComment(String comment) => this.comment = comment;

  int get getYearIssue => yearIssue;

  set setYearIssue(int yearIssue) => this.yearIssue = yearIssue;

  String get getCarId => carId;

  set setCarId(String carId) => this.carId = carId;

  Car(
      {this.carId,
      this.typeFuel,
      this.typeTransmission,
      this.mark,
      this.model,
      this.volumeEngine,
      this.power,
      this.active,
      this.vin,
      this.comment,
      this.photo,
      this.yearIssue});

  static List<Car> fromData(List<Map<String, dynamic>> data) {
    return data.map((car) => Car.fromMap(car)).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'carId': carId,
      'typeFuel': typeFuel,
      'typeTransmission': typeTransmission,
      'mark': mark,
      'model': model,
      'power': power,
      'active': active,
      'vin': vin,
      'comment': comment,
      'photo': photo,
      'yearIssue': yearIssue,
      'volumeEngine': volumeEngine,
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      'typeFuel': typeFuel,
      'typeTransmission': typeTransmission,
      'mark': mark,
      'model': model,
      'power': power,
      'active': active,
      'vin': vin,
      'comment': comment,
      'photo': photo,
      'yearIssue': yearIssue,
      'volumeEngine': volumeEngine,
    };
  }

  static Car fromServerMap(Map<String, dynamic> map) {
    if (map == null) return null;
    var jsonValue = jsonEncode(map['power']);
    var power = int.parse(jsonValue);
    jsonValue = jsonEncode(map['yearIssue']);
    var yearIssue = int.parse(jsonValue);
    var active = jsonEncode(map['active']);
    jsonValue = jsonEncode(map['volumeEngine']);
    var volumeEngine = int.parse(jsonValue);
    return Car(
      carId: map["carId"],
      typeFuel: map["typeFuel"],
      typeTransmission: map["typeTransmission"],
      mark: map["mark"],
      model: map["model"],
      power: power,
      active: active == 'true' || active == '1' ? true : false,
      vin: int.parse(map['vin']),
      comment: map["comment"],
      photo: map["photo"],
      yearIssue: yearIssue,
      volumeEngine: volumeEngine,
    );
  }

static Car fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    return Car(
      carId: map["carId"],
      typeFuel: map["typeFuel"],
      typeTransmission: map["typeTransmission"],
      mark: map["mark"],
      model: map["model"],
      power: map["power"],
      active: map["active"] == 1 ? true : false,
      vin: map['vin'],
      comment: map["comment"],
      photo: map["photo"],
      yearIssue: map["yearIssue"],
      volumeEngine: map["volumeEngine"],
    );
  }
  String toJson() => json.encode(toMap());

  static Car fromJson(String source) => fromMap(json.decode(source));
}
