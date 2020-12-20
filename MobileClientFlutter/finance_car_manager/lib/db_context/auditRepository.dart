
import 'package:finance_car_manager/db_context/db_provaider.dart';
import 'package:finance_car_manager/synchronization/syncEntity.dart';

class AuditRepository {
  Future<List<SyncEntity>> getAllSyncEntities(String lastDateSync) async {
    return await DbProvider().getAllSyncEntities(lastDateSync);
  }

  Future<void> deleteSyncEntities(String dateTime) async {
    return await DbProvider().deleteSyncEntities(dateTime);
  }
}