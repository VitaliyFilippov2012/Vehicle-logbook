import 'dart:convert';

class SyncEntity {
  String entityName;
  String entityId;
  String actionDate;
  String actionSide;
  String actionType;

  SyncEntity({
    this.entityName,
    this.entityId,
    this.actionDate,
    this.actionSide,
    this.actionType
  });

  Map<String, dynamic> toMap() {
    return {
      'entityName': entityName,
      'entityId': entityId,
      'actionDate': actionDate,
      'actionSide': actionSide,
      'actionType': actionType,
    };
  }

  static SyncEntity fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return SyncEntity(
      entityName: map['entity'],
      entityId: map['entityId'],
      actionDate: map['dateUpdate'],
      actionSide: 'Client',
      actionType: map['action'],
    );
  }

  String toJson() => json.encode(toMap());

  static SyncEntity fromJson(String source) => fromMap(json.decode(source));
}
