import 'package:finance_car_manager/blocs/carsBloc.dart';
import 'package:finance_car_manager/components/deleteUpdateButtons.dart';
import 'package:finance_car_manager/components/saveButton.dart';
import 'package:finance_car_manager/db_context/eventsRepository.dart';
import 'package:finance_car_manager/models/category.dart';
import 'package:flutter/material.dart';
import 'package:finance_car_manager/utils/utils.dart';
import 'package:finance_car_manager/animations/fadeAnimation.dart';
import 'package:finance_car_manager/blocs/eventsBloc.dart';
import 'package:finance_car_manager/components/dateTextField.dart';
import 'package:finance_car_manager/components/headerWidget.dart';
import 'package:finance_car_manager/components/validationTextField.dart';
import 'package:finance_car_manager/components/willPopScopeWithBackground.dart';
import 'package:finance_car_manager/models/event.dart';
import 'package:finance_car_manager/screens/mainScreen.dart';
import 'package:finance_car_manager/style/styles.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class SettingsEvent extends StatefulWidget {
  String idEvent;
  final String idTypeEvent = categories[4].categoryId;
  String date;
  double costs;
  double unitPrice;
  String comment;
  int mileage;
  String photo;
  String addressStation;
  EventsRepository eventsRepository;

  SettingsEvent({Key key, this.idEvent}) : super(key: key);

  @override
  _SettingsEventState createState() => _SettingsEventState();
}

class _SettingsEventState extends State<SettingsEvent> {
  bool isSaved;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    widget.eventsRepository = new EventsRepository();
    isSaved = false;
    if (widget.idEvent != null) {
      isSaved = true;
    }
    double screenWidth = MediaQuery.of(context).size.width - (20 + 0);
    bool Function(String) stringNotEmpty = (value) {
      return value?.isNotEmpty == true;
    };
    return WillPopScopeWithBackground(
      onImageChanged: (image) {
        setState(() {
          widget.photo = image;
        });
      },
      takePhoto: true,
      childToWillPop: MainScreen(),
      children: [
        Form(
          key: _formKey,
          child: FutureBuilder<Event>(
              future: widget.idEvent != null
                  ? eventsBloc.getEventById(widget.idEvent)
                  : null,
              builder: (context, snapshot) {
                var event = snapshot.data;
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
                } else {
                  return Column(
                    children: <Widget>[
                      FadeAnimation(0.4,
                          HeaderWidget(childToPushreplacement: MainScreen())),
                      FadeAnimation(
                        0.5,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Column(children: <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(5, 25, 0, 10),
                                child: Container(
                                  width: screenWidth * 0.48,
                                  height: 210,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20.0),
                                    ),
                                    child: widget.photo != null
                                        ? Utility.imageFromBase64String(
                                            widget.photo)
                                        : event?.photo != null
                                            ? Utility.imageFromBase64String(
                                                event.getPhoto)
                                            : Image.asset(
                                                "assets/images/default-photo-event.jpg",
                                                fit: BoxFit.scaleDown,
                                                color: Colors.transparent,
                                                colorBlendMode:
                                                    BlendMode.darken,
                                              ),
                                  ),
                                ),
                              ),
                            ]),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Row(children: <Widget>[
                                  ValidationTextField(
                                    isEditable: false,
                                    text: categories[4].name,
                                    label: "Type event",
                                    procentWidth: 0.5,
                                    paddingLeft: 5.0,
                                    paddingTop: 25,
                                    validator: (value) {
                                      return (stringNotEmpty(value) &&
                                          value.contains(new RegExp(
                                              r'([a-zA-Z])|([а-яА-Я])')));
                                    },
                                  ),
                                ]),
                                Row(children: <Widget>[
                                  ValidationTextField(
                                    text: widget.unitPrice?.toString() ??
                                        event?.unitPrice?.toString(),
                                    onStringChanged: (changedStr) {
                                      widget.unitPrice =
                                          double.parse(changedStr);
                                    },
                                    label: "Unit price",
                                    procentWidth: 0.5,
                                    paddingLeft: 5.0,
                                    paddingTop: 0.0,
                                    validator: (value) {
                                        return (!value.contains(new RegExp(
                                                r'([a-zA-Z])|([а-яА-Я])')));
                                      },
                                  ),
                                ]),
                                Row(
                                  children: <Widget>[
                                    ValidationTextField(
                                      text: widget?.costs?.toString() ??
                                          event?.costs?.toString(),
                                      onStringChanged: (changedStr) {
                                        widget.costs = double.parse(changedStr);
                                      },
                                      label: "Сost",
                                      procentWidth: 0.5,
                                      paddingLeft: 5.0,
                                      paddingTop: 0.0,
                                      validator: (value) {
                                        return (stringNotEmpty(value) &&
                                            !value.contains(new RegExp(
                                                r'([a-zA-Z])|([а-яА-Я])')));
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      FadeAnimation(
                          0.8,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              FutureBuilder<int>(
                              future: _getMaxMileadeForCar(),
                              builder: (context, AsyncSnapshot<int> snapshot) {
                                var mileage = snapshot.data;
                            return ValidationTextField(
                                  text: widget.mileage?.toString() ??
                                      event?.mileage?.toString() ?? mileage?.toString(),
                                  onStringChanged: (changedStr) {
                                    widget.mileage = int.parse(changedStr);
                                  },
                                  label: "Mileage",
                                  paddingLeft: 20.0,
                                  procentWidth: 0.4,
                                  paddingTop: 10,
                                  validator: (value) {
                                    return (!value.contains(new RegExp(
                                            r'([a-zA-Z])|([а-яА-Я])')) &&
                                        value.length <= 7);
                                  });}),
                              DateTextField(
                                date: widget.date ?? event?.date?.toString(),
                                onDateTextChanged: (date) {
                                  setState(() {
                                    widget.date = date;
                                  });
                                },
                                paddingTop: 10,
                                label: "Date",
                                procentWidth: 0.5,
                                paddingLeft: 0.0,
                              ),
                            ],
                          )),
                      FadeAnimation(
                          1.2,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ValidationTextField(
                                text: widget.addressStation ??
                                    event?.addressStation,
                                onStringChanged: (changedStr) {
                                  widget.addressStation = changedStr;
                                },
                                icon: Icon(
                                  Icons.map,
                                  color: blueColor,
                                ),
                                label: "Address",
                                paddingLeft: 20.0,
                                paddingTop: 0.0,
                              ),
                            ],
                          )),
                      FadeAnimation(
                          1.2,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ValidationTextField(
                                text: widget.comment ?? event?.getComment,
                                onStringChanged: (changedStr) {
                                  widget.comment = changedStr;
                                },
                                label: "Comments",
                                paddingLeft: 20.0,
                                paddingTop: 10,
                                multiline: true,
                                icon: Icon(
                                  Icons.comment,
                                  color: blueColor,
                                ),
                                validator: (value) {
                                  return (stringNotEmpty(value));
                                },
                              )
                            ],
                          )),
                      FadeAnimation(
                        1.5,
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30.0),
                          child: isSaved
                              ? DeleteUpdateButtons(
                                  formKey: _formKey,
                                  onUpdate: (isPress) {
                                    _updateEvent(event);
                                  },
                                  onDelete: (isPress) {
                                    _deleteEvent(event);
                                    setState(() {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MainScreen()),
                                      );
                                    });
                                  },
                                )
                              : SaveButton(
                                  formKey: _formKey,
                                  onSave: (isPress) {
                                    _saveEvent();
                                    setState(() {
                                      isSaved = true;
                                    });
                                  },
                                ),
                        ),
                      ),
                    ],
                  );
                }
              }),
        ),
      ],
    );
  }

  Future<int> _getMaxMileadeForCar() async{
    var car = await carsBloc.selectedCar.first;
    if(car == null)
      return 0;
    return await widget.eventsRepository.getMaxMileageInCar(car.carId);
  }

  _saveEvent() {
    if (widget.idEvent == null) eventsBloc.saveEvent(converToNewEvent(null));
  }

  _updateEvent(Event event) {
    if (event?.eventId != null) eventsBloc.updateEvent(converToNewEvent(event));
  }

  Event converToNewEvent(Event event) {
    widget.idEvent = event?.getEventId ?? Uuid().v4().toString();
    var formatter = new DateFormat('yyyy-MM-dd');
    return new Event.events(
        widget.idEvent,
        widget.idTypeEvent,
        event?.idUser ?? "",
        event?.idCar ?? "",
        widget.date ?? event?.date ?? formatter.format(new DateTime.now()),
        widget.costs ?? event?.costs,
        widget.unitPrice ?? event?.unitPrice,
        widget.comment ?? event?.comment,
        widget.mileage ?? event?.mileage,
        null, //widget.photo ?? event.photo,
        widget.addressStation ?? event?.addressStation);
  }

  _deleteEvent(Event event) {
    if (event?.eventId == null) return;
    eventsBloc.deleteEvent(event.eventId);
  }
}
