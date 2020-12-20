import 'dart:convert';

import 'package:finance_car_manager/models/UserInfo.dart';
import 'package:finance_car_manager/models/type.dart';

class StaticDataWrapper {
  UserInfo userInfo;
  List<Type> typeServices;
  List<Type> typeEvents;
 List get getTypeServices => typeServices;

 set setTypeServices(List typeServices) => this.typeServices = typeServices;

 List get getTypeEvents => typeEvents;

 set setTypeEvents(List typeEvents) => this.typeEvents = typeEvents;
  StaticDataWrapper({
    this.userInfo,
    this.typeServices,
    this.typeEvents,
  });

  Map<String, dynamic> toMap() {
    return {
      'userInfo': userInfo?.toMap(),
      'typeServices': typeServices?.map((x) => x?.toServiceTypeMap())?.toList(),
      'typeEvents': typeEvents?.map((x) => x?.toEventTypeMap())?.toList(),
    };
  }

  static StaticDataWrapper fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return StaticDataWrapper(
      userInfo: UserInfo.fromMap(map['userInfo']),
      typeServices: List<Type>.from(map['typeServices']?.map((x) => Type.fromMap(x))),
      typeEvents: List<Type>.from(map['typeEvents']?.map((x) => Type.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  static StaticDataWrapper fromJson(String source) => fromMap(json.decode(source));
}
