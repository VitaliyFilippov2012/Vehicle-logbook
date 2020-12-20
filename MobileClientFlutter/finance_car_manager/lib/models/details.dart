import 'dart:convert';

class Details {
  String detailsId;
  String idCar;
  String idService;
  String name;
  String type;
  String get getDetailsId => detailsId;

  set setDetailsId(String detailsId) => this.detailsId = detailsId;

  String get getIdCar => idCar;

  set setIdCar(String idCar) => this.idCar = idCar;

  String get getIdService => idService;

  set setIdService(String idService) => this.idService = idService;

  String get getName => name;

  set setName(String name) => this.name = name;

  String get getType => type;

  set setType(String type) => this.type = type;
  Details({
    this.detailsId,
    this.idCar,
    this.idService,
    this.name,
    this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'detailId': detailsId,
      'idCar': idCar,
      'idService': idService,
      'name': name,
      'type': type,
    };
  }

  Map<String, dynamic> toSaveMap(String carId, String serviceId, String idDetails) {
    return {
      'detailId': idDetails,
      'idCar': carId,
      'idService': serviceId,
      'name': name,
      'type': type,
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      'name': name,
      'type': type,
    };
  }

  static Details fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Details(
      detailsId: map['detailId'],
      idCar: map['idCar'],
      idService: map['idService'],
      name: map['name'],
      type: map['type'],
    );
  }

  String toJson() => json.encode(toMap());

  static Details fromJson(String source) => fromMap(json.decode(source));
}
