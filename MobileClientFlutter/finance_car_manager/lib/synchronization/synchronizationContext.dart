import 'package:finance_car_manager/synchronization/syncEntity.dart';

class SynchronizationContext {
  String lastSyncDate;
  List<SyncEntity> synchronizationDataMembers;
  
  SynchronizationContext({
    this.lastSyncDate,
    this.synchronizationDataMembers,
  });
}
