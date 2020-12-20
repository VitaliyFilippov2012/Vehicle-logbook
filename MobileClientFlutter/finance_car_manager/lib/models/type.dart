import 'dart:convert';

class Type {
  String typeId;
  String typeString;

  String get getTypeId => typeId;
  set setTypeId(String typeId) => this.typeId = typeId;
  String get getTypeString => typeString;
  set setTypeString(String typeString) => this.typeString = typeString;

  Type({
    this.typeId,
    this.typeString,
  });

  Map<String, dynamic> toEventTypeMap() {
    return {
      'typeEventId': typeId,
      'TypeName': typeString,
    };
  }

  Map<String, dynamic> toServiceTypeMap() {
    return {
      'typeServiceId': typeId,
      'TypeName': typeString,
    };
  }

  static Type fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Type(
      typeId: map['typeId'] ?? map['typeServiceId'] ?? map['typeEventId'],
      typeString: map['typeName'] ?? map['TypeName'],
    );
  }

  String toEventTypeJson() => json.encode(toEventTypeMap());
  String toServiceTypeJson() => json.encode(toServiceTypeMap());

  static Type fromJson(String source) => fromMap(json.decode(source));
}
