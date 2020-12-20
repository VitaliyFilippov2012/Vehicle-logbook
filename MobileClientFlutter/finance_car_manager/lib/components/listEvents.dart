import 'dart:async';

import 'package:finance_car_manager/animations/fadeAnimation.dart';
import 'package:finance_car_manager/blocs/carsBloc.dart';
import 'package:finance_car_manager/blocs/eventsBloc.dart';
import 'package:finance_car_manager/components/eventWidget.dart';
import 'package:finance_car_manager/components/event_details/eventDetailsPage.dart';
import 'package:finance_car_manager/models/car.dart';
import 'package:finance_car_manager/models/category.dart';
import 'package:finance_car_manager/models/event.dart';
import 'package:finance_car_manager/style/styles.dart';
import 'package:flutter/material.dart';

class ListEvents extends StatefulWidget {
  final Category typeEvent;

  const ListEvents({Key key, this.typeEvent}) : super(key: key);
  @override
  _ListEventsState createState() => _ListEventsState();
}

class _ListEventsState extends State<ListEvents> {
  @override
  Widget build(BuildContext context) {
    carsBloc.getSelectedCarOrSetIfNotExistsInShared();
    return StreamBuilder(
      stream: carsBloc.selectedCar,
      builder: (context, AsyncSnapshot<Car> snapshot) {
        var carId = snapshot?.data?.carId;
        var duration = 0.0;
        loadEventsByType(carId);
        return StreamBuilder(
          stream: eventsBloc.allEvents,
          builder: (context, AsyncSnapshot<List<Event>> snapshot) {
            if (snapshot.hasError) {
              return Column(
                children: <Widget>[
                  Center(
                    child: Text(
                      "Oxxx error, please  refresh",
                      style: fadedTextStyle,
                    ),
                  )
                ],
              );
            } else if (snapshot.hasData) {
              return Column(
                children: <Widget>[
                  for (final event in snapshot.data)
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) =>
                                EventDetailsPage(event: event),
                          ),
                        );
                      },
                      child: FadeAnimation(
                          duration += 0.2,
                          EventWidget(
                            event: event,
                          )),
                    ),
                ],
              );
            } else {
              return Column(
                children: <Widget>[
                  Center(
                    child: Text(
                      "No data",
                      style: fadedTextStyle,
                    ),
                  )
                ],
              );
            }
          },
        );
      },
    );
  }

  void loadEventsByType(String carId) {
    if(carId == null)
      return;
    if (widget.typeEvent == categories[2])
      eventsBloc.getAllFuelEventsForCar(carId);
    else if (widget.typeEvent == categories[3])
      eventsBloc.getAllServiceEventsForCar(carId);
    else if (widget.typeEvent == categories[0])
      eventsBloc.getAllEventsForCar(carId);
    else if (widget.typeEvent == categories[1])
      eventsBloc.getPlanningEventsForCar(carId);
    else
      eventsBloc.getAllEventsByTypeIdForCar(carId, widget.typeEvent.categoryId);
  }
}
