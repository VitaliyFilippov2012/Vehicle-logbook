import 'dart:async';
import 'package:finance_car_manager/db_context/db_provaider.dart';
import 'package:finance_car_manager/db_context/sharedPreferencesRepository.dart';
import 'package:finance_car_manager/models/event.dart';
import 'package:finance_car_manager/models/eventService.dart';
import 'package:finance_car_manager/models/fuel.dart';
import 'package:finance_car_manager/models/type.dart';

class EventsRepository {
  SharedPreferencesRepository sharedPreferences = new SharedPreferencesRepository();

  Future<List<Event>> getAllEventsForCar(String carId) async {
    return await DbProvider().getAllEventsForCar(carId);
  }

  Future<int> getMaxMileageInCar(String carId) async{
    return await DbProvider().getMaxMileageInCar(carId);
  }

  Future<List<Event>> getAllEventsByTypeIdForCar(String carId, String typeId) async {
    return await DbProvider().getAllEventsByTypeIdForCar(carId, typeId);
  }

  Future<Event> getEventById(String id) async {
    return await DbProvider().getEventById(id);
  }

  Future<List<Fuel>> getAllFuelEventsForCar(String carId) async {
    return await DbProvider().getAllFuelEventsForCar(carId);
  }

  Future<List<Type>> getTypeServiceEvents() async {
    return await DbProvider().getTypeService();
  }

  Future<Fuel> getFuelEventById(String id) async {
    return await DbProvider().getFuelEventById(id);
  }

  Future<List<EventService>> getAllServiceEventsForCar(String carId) async {
    return await DbProvider().getAllServiceEventsForCar(carId);
  }

  Future<EventService> getServiceEventById(String id) async {
    return await DbProvider().getServiceEventById(id);
  }

  Future<void> deleteEvent(String eventId) async{
    return await DbProvider().deleteEvent(eventId);
  }

  Future<int> updateEvent(Event event) async {
    return await DbProvider().updateEvent(event);
  }

  Future<int> updateFuelEvent(Fuel event) async {
    return await DbProvider().updateFuelEvent(event);
  }

  Future<int> updateServiceEvent(EventService event) async {
    return await DbProvider().updateServiceEvent(event);
  }

  Future<void> saveEvents(List<Event> events) async{
    for(var e in events){
      await DbProvider().saveEvent(e);
    }
  }

  Future<void> saveFuelEvents(List<Fuel> events) async{
    for(var e in events){
     await DbProvider().saveFuelEvent(e);
    }
  }

  Future<void> saveServiceEvents(List<EventService> events) async{
    for(var e in events){
     await DbProvider().saveServiceEvent(e);
    }
  }


  Future<int> saveEvent(Event event) async{
    return await DbProvider().saveEvent(event);
  }

  Future<int> saveFuelEvent(Fuel event) async{
    return await DbProvider().saveFuelEvent(event);
  }

  Future<int> saveServiceEvent(EventService event) async{
    return await DbProvider().saveServiceEvent(event);
  }

  Future<void> addServiceTypes(List<Type> serviceTypes) async{
    return await DbProvider().addServiceTypes(serviceTypes);
  }

  Future<void> addEventTypes(List<Type> eventType) async{
    return await DbProvider().addEventTypes(eventType);
  }
}
