import 'dart:async';
import 'package:finance_car_manager/db_context/db_provaider.dart';
import 'package:finance_car_manager/models/car.dart';

class CarsRepository {
  Future<Car> getCarById(String id) async {
    return await DbProvider().getCarById(id);
  }

  Future<List<Car>> getAllCars() async {
    return await DbProvider().getAllCars();
  }

  Future<int> addCar(Car item) async {
    return await DbProvider().addCar(item);
  }

  Future<int> updateCar(Car item) async {
    return await DbProvider().updateCar(item);
  }

  Future<int> saveCar(Car item) async {
    return await DbProvider().saveCar(item);
  }

  Future<void> deleteCar(String carId) async{
    await DbProvider().deleteCar(carId);
  }

  Future<void> deleteCarFromUser(String carId) async{
    await DbProvider().deleteCarFromUser(carId);
  }
}