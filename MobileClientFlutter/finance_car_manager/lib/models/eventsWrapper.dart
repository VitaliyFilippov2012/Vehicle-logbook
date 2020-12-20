import 'dart:convert';

import 'package:finance_car_manager/models/event.dart';
import 'package:finance_car_manager/models/eventService.dart';
import 'package:finance_car_manager/models/fuel.dart';

class EventsWrapper {
  List<Event> events;
  List<EventService> eventServices;
  List<Fuel> fuels;
  List get getEvents => events;

  set setEvents(List events) => this.events = events;

  List get getEventServices => eventServices;

  set setEventServices(List eventServices) =>
      this.eventServices = eventServices;

  List get getFuels => fuels;

  set setFuels(List fuels) => this.fuels = fuels;
  EventsWrapper({
    this.events,
    this.eventServices,
    this.fuels,
  });

  Map<String, dynamic> toMap() {
    return {
      'events': events?.map((x) => x?.toMap())?.toList(),
      'eventServices': eventServices?.map((x) => x?.toMap())?.toList(),
      'fuels': fuels?.map((x) => x?.toMap())?.toList(),
    };
  }

  static EventsWrapper fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return EventsWrapper(
      events: List<Event>.from(map['events']?.map((x) => Event.fromMap(x))),
      eventServices: List<EventService>.from(
          map['eventServices']?.map((x) => EventService.fromEventMap(x))),
      fuels: List<Fuel>.from(map['fuels']?.map((x) => Fuel.fromEventMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  static EventsWrapper fromJson(String source) => fromMap(json.decode(source));
}
