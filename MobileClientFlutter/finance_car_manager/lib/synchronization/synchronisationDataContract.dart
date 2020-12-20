
import 'package:finance_car_manager/synchronization/syncEntity.dart';

class SynchronisationDataContract {
  List<SyncEntity> delete;
  List<SyncEntity> post;
  List<SyncEntity> put;

  SynchronisationDataContract({
    this.delete,
    this.post,
    this.put,
  });
}
