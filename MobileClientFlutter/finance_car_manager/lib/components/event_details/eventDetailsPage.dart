import 'package:finance_car_manager/models/category.dart';
import 'package:finance_car_manager/models/event.dart';
import 'package:finance_car_manager/screens/additional_screens/sett_event.dart';
import 'package:finance_car_manager/screens/additional_screens/sett_fuels.dart';
import 'package:finance_car_manager/screens/additional_screens/sett_service.dart';
import 'package:finance_car_manager/screens/mainScreen.dart';
import 'package:finance_car_manager/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'eventDetailBackground.dart';
import 'eventDetailContent.dart';

class EventDetailsPage extends StatefulWidget {
  final Event event;

  const EventDetailsPage({Key key, this.event}) : super(key: key);

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      ),
      child: Scaffold(
        body: Provider<Event>.value(
          value: widget.event,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              EventDetailsBackground(),
              EventDetailsContent(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => getEventWidgetByType()),
            );
          },
          child: Icon(Icons.edit),
          backgroundColor: blueColor,
        ),
      ),
    );
  }

  getEventWidgetByType() {
    if (widget.event.getIdTypeEvents == categories[2].categoryId)
      return SettingsFuel(idEvent: widget.event.eventId);
    else if (widget.event.getIdTypeEvents == categories[3].categoryId)
      return SettingsService(idEvent: widget.event.eventId);
    else
      return SettingsEvent(idEvent: widget.event.eventId);
  }
}
