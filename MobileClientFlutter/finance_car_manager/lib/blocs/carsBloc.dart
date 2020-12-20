import 'package:finance_car_manager/db_context/carsRepository.dart';
import 'package:finance_car_manager/db_context/sharedPreferencesRepository.dart';
import 'package:finance_car_manager/models/car.dart';
import 'package:finance_car_manager/models/myApi.dart';
import 'package:rxdart/rxdart.dart';

class CarsBloc {
  final _repository = CarsRepository();
  final _cars = PublishSubject<List<Car>>();
  final _selectedCar = PublishSubject<Car>();

  Stream<List<Car>> get allCars => _cars.stream;
  Stream<Car> get selectedCar => _selectedCar.stream;

  getAllCars() async {
    var cars = await _repository.getAllCars();
    _cars.sink.add(cars);
    _cars.share();
  }

  updateCar(Car car) async  {
    return await _repository.updateCar(car);
  }

  saveCar(Car car) async  {
    var r = await _repository.saveCar(car);
    if(r != -1){
      setSelectedCar(car.carId);
    }
  }

  shareCarWithOtherUser(String carId, String email) async{
    return await MyApi.sendShareCarWithOtherUserPOST(carId, email);
  }

  deleteCar(String carId) async  {
    return await _repository.deleteCar(carId);
  }

  deleteCarForever(String carId) async  {
    return await _repository.deleteCarFromUser(carId);
  }

  getSelectedCars(String id) async {
    Car car = await getCarById(id);
    if(car == null)
      return;
    _selectedCar.sink.add(car);
    _selectedCar.share();
  }

  Future<Car> getCarById(String id) async {
    if(id == null)
      return null;
    return await _repository.getCarById(id);
  }

  dispose() {
    _cars.close();
    _selectedCar.close();
  }

  setSelectedCar(String id) async {
    var sharedPreferencesRep = SharedPreferencesRepository();
    await sharedPreferencesRep.saveSelectedCar(id);
    getSelectedCars(id);
  }

  getSelectedCarOrSetIfNotExistsInShared() async {
    var sharedPreferencesRep = SharedPreferencesRepository();
    var res = await sharedPreferencesRep.getSelectedCar();
    if(res == null){
      getAllCars();
      var car = await _cars.first;
      if(car?.first == null)
        return;
      res = car.first.carId;
      await sharedPreferencesRep.saveSelectedCar(res);
    }
    getSelectedCars(res);
  }
}

final carsBloc = CarsBloc();
