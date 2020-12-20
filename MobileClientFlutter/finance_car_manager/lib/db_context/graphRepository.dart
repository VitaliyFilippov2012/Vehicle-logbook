import 'dart:async';
import 'package:finance_car_manager/db_context/db_provaider.dart';
import 'package:finance_car_manager/models/graphInfo.dart';
import 'package:finance_car_manager/models/circleGraphInfo.dart';

class GraphRepository {
  Future<List<GraphInfo>> getMileagesForEveryDayByCarId(String carId) async {
    return await DbProvider().getMileagesForEveryDayByCarId(carId);
  }

  Future<List<GraphInfo>> getSumPouredVolumeForDayByCarId(String carId) async {
    return await DbProvider().getSumPouredVolumeForDayByCarId(carId);
  }

  Future<List<GraphInfo>> getTotalMileagesByCarId(String carId) async {
    return await DbProvider().getTotalMileagesByCarId(carId);
  }

  Future<List<GraphInfo>> getCostsForEveryDayByCarId(String carId) async {
    return await DbProvider().getCostsForEveryDayByCarId(carId);
  }

  Future<List<GraphInfo>> getCostsFuelVolumeForDayByCarId(String carId) async {
    return await DbProvider().getCostsFuelVolumeForDayByCarId(carId);
  }

  Future<List<CircleGraphInfo>> getCostsByTypeByCarId(String carId) async {
    return await DbProvider().getCostsByTypeByCarId(carId);
  }

  Future<List<CircleGraphInfo>> getFuelCostsByCarId(String carId) async {
    return await DbProvider().getFuelCostsByCarId(carId);
  }

  Future<List<CircleGraphInfo>> getCostsByGroupTypeByCarId(String carId) async {
    return await DbProvider().getCostsByGroupTypeByCarId(carId);
  }
}
