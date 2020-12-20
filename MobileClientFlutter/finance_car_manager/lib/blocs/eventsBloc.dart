import 'package:finance_car_manager/blocs/carsBloc.dart';
import 'package:finance_car_manager/blocs/userInfoBloc.dart';
import 'package:finance_car_manager/db_context/eventsRepository.dart';
import 'package:finance_car_manager/models/event.dart';
import 'package:finance_car_manager/models/eventService.dart';
import 'package:finance_car_manager/models/fuel.dart';
import 'package:finance_car_manager/models/type.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

class EventsBloc {
  final _repository = EventsRepository();
  final _events = PublishSubject<List<Event>>();
  final _selectedEvents = PublishSubject<Event>();

  Stream<List<Event>> get allEvents => _events.stream;
  Stream<Event> get selectedEvent => _selectedEvents.stream;

  getAllEventsForCar(String carId) async {
    var events = await _repository.getAllEventsForCar(carId);
    setToStream(events);
  }

  getPlanningEventsForCar(String carId) async {
    var events = await _repository.getAllEventsForCar(carId);
    var formatter = new DateFormat('yyyy-MM-dd');
    setToStream(events.where((x) => x.date.toString().compareTo(formatter.format(new DateTime.now())) == 1).toList());
  }

  getAllServiceEventsForCar(String carId) async {
    var events = await _repository.getAllServiceEventsForCar(carId);
    setToStream(events);
  }

  setSelectedEventById(String id) async {
    var event = await _repository.getEventById(id);
    _selectedEvents.sink.add(event);
  }

  Future<Event> getEventById(String id) async {
    return await _repository.getEventById(id);
  }

  setServiceEventById(String id) async {
    var event = await getServiceEventById(id);
    _selectedEvents.sink.add(event);
  }

  Future<EventService> getServiceEventById(String id) async {
    return await _repository.getServiceEventById(id);
  }

  void setToStream(List<Event> events) {
    events.sort((x, y) => y.date.compareTo(x.date));
    _events.sink.add(events);
  }

  getAllFuelEventsForCar(String carId) async {
    var events = await _repository.getAllFuelEventsForCar(carId);
    setToStream(events);
  }

  setFuelEventById(String id) async {
    var event = await getFuelEventById(id);
    _selectedEvents.sink.add(event);
  }

  Future<Fuel> getFuelEventById(String id) async {
    return await _repository.getFuelEventById(id);
  }

  dispose() {
    _events.close();
    _selectedEvents.close();
  }

  getAllEventsByTypeIdForCar(String carId, String typeId) async {
    var events = await _repository.getAllEventsByTypeIdForCar(carId, typeId);
    _events.sink.add(events);
  }

  deleteEvent(String eventId) async {
    return await _repository.deleteEvent(eventId);
  }

  updateEvent(Event event) async {
    if (event?.idCar != null) return await _repository.updateEvent(event);
  }

  updateFuelEvent(Fuel event) async {
    if (event?.idCar != null) return await _repository.updateFuelEvent(event);
  }

  updateServiceEvent(EventService event) async {
    if (event?.idCar != null) return await _repository.updateServiceEvent(event);
  }

  Future<Event> setUserIdAndCarIdIfNotExists(Event event) async {
    if (event == null) return null;
    if (event.idCar == '') {
      carsBloc.getSelectedCarOrSetIfNotExistsInShared();
      var car = await carsBloc.selectedCar.first;
      event.idCar = car.carId;
    }
    if (event.idUser == '') {
      var user = await userInfoBloc.userInfo.first;
      event.idUser = user.userId;
    }
    return event;
  }

  Future<List<Type>> getEventServiceTypes() async {
    return await _repository.getTypeServiceEvents();
  }

  saveEvent(Event event) async {
    event = await setUserIdAndCarIdIfNotExists(event);
    if (event == null) return;
    await _repository.saveEvent(event);
  }

  saveFuelEvent(Fuel event) async {
    event = await setUserIdAndCarIdIfNotExists(event);
    if (event == null) return;
    await _repository.saveFuelEvent(event);
  }

  saveServiceEvent(EventService event) async {
    event = await setUserIdAndCarIdIfNotExists(event);
    if (event == null) return;
    await _repository.saveServiceEvent(event);
  }
}

final eventsBloc = EventsBloc();
