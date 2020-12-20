import 'package:finance_car_manager/db_context/db_provaider.dart';

class ManagerDbContext{
  Future<void> createTriggers() async {
    return await DbProvider().addTriggers();
  }
}