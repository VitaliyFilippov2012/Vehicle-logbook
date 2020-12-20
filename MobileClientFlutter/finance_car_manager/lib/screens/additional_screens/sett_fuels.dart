import 'dart:math';

import 'package:finance_car_manager/blocs/carsBloc.dart';
import 'package:finance_car_manager/components/deleteUpdateButtons.dart';
import 'package:finance_car_manager/components/saveButton.dart';
import 'package:finance_car_manager/db_context/eventsRepository.dart';
import 'package:finance_car_manager/models/car.dart';
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
import 'package:finance_car_manager/models/fuel.dart';
import 'package:finance_car_manager/screens/mainScreen.dart';
import 'package:finance_car_manager/style/styles.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class SettingsFuel extends StatefulWidget {
  String idEvent;
  double volume;
  String date;
  String fuelType;
  double costs;
  double unitPrice;
  String comment;
  int mileage;
  String photo;
  String addressStation;
  EventsRepository eventsRepository;
  SettingsFuel({Key key, this.idEvent}) : super(key: key);

  @override
  _SettingsFuelState createState() => _SettingsFuelState();
}

class _SettingsFuelState extends State<SettingsFuel> {
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
    carsBloc.getSelectedCarOrSetIfNotExistsInShared();
    eventsBloc.setFuelEventById(widget.idEvent);
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
          child: FutureBuilder<Fuel>(
            future: widget.idEvent != null
                ? eventsBloc.getFuelEventById(widget.idEvent)
                : null,
            builder: (context, snapshot) {
              var fuel = snapshot.data;
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
                                      : fuel?.photo != null
                                          ? Utility.imageFromBase64String(
                                              fuel.getPhoto)
                                          : Image.asset(
                                              "assets/images/default-photo-fuel.jpg",
                                              fit: BoxFit.scaleDown,
                                              color: Colors.transparent,
                                              colorBlendMode: BlendMode.darken,
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
                                StreamBuilder<Car>(
                                    stream: carsBloc.selectedCar,
                                    builder: (context, snapshot) {
                                      var fuelType = snapshot.data?.getTypeFuel;
                                      return ValidationTextField(
                                        isEditable: false,
                                        text: fuelType ?? "",
                                        onStringChanged: (changedStr) {
                                          widget.fuelType = changedStr;
                                        },
                                        label: "Fuel type",
                                        procentWidth: 0.5,
                                        paddingLeft: 5.0,
                                        paddingTop: 25,
                                        validator: (value) {
                                          return (stringNotEmpty(value));
                                        },
                                      );
                                    }),
                              ]),
                              Row(children: <Widget>[
                                ValidationTextField(
                                  text: widget.volume?.toString() ??
                                      fuel?.volume?.toString() ??
                                      "",
                                  onStringChanged: (changedStr) {
                                    widget.volume = double.parse(changedStr);
                                  },
                                  label: "Volume",
                                  procentWidth: 0.5,
                                  paddingLeft: 5.0,
                                  paddingTop: 10.0,
                                  maxLength: 5,
                                  validator: (value) {
                                    return (stringNotEmpty(value) &&
                                        !value.contains(new RegExp(
                                            r'([a-zA-Z])|([а-яА-Я])')));
                                  },
                                ),
                              ]),
                              Row(
                                children: <Widget>[
                                  ValidationTextField(
                                    text: widget?.unitPrice?.toString() ??
                                        fuel?.unitPrice?.toString(),
                                    onStringChanged: (changedStr) {
                                      widget.unitPrice =
                                          double.parse(changedStr);
                                    },
                                    label: "Сost of a liter",
                                    procentWidth: 0.5,
                                    paddingTop: 0.0,
                                    paddingLeft: 5.0,
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
                        1.0,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            FutureBuilder<int>(
                              future: _getMaxMileadeForCar(),
                              builder: (context, AsyncSnapshot<int> snapshot) {
                                var mileage = snapshot.data;
                            return ValidationTextField(
                                text: widget?.mileage?.toString() ??
                                    fuel?.mileage?.toString() ?? mileage?.toString(),
                                onStringChanged: (changedStr) {
                                  widget.mileage = int.parse(changedStr);
                                },
                                label: "Mileage",
                                paddingTop: 0.0,
                                paddingLeft: 20.0,
                                procentWidth: 0.4,
                                validator: (value) {
                                  return (stringNotEmpty(value) &&
                                      !value.contains(new RegExp(
                                          r'([a-zA-Z])|([а-яА-Я])')) &&
                                      value.length <= 7);
                                });}),
                            DateTextField(
                              date: widget.date ?? fuel?.date?.toString(),
                              onDateTextChanged: (date) {
                                setState(() {
                                  widget.date = date;
                                });
                              },
                              label: "Date",
                              paddingTop: 0.0,
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
                              text:
                                  widget.addressStation ?? fuel?.addressStation,
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
                              validator: (value) {
                                return (stringNotEmpty(value));
                              },
                            ),
                          ],
                        )),
                    FadeAnimation(
                        1.4,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ValidationTextField(
                                text: widget.comment ?? fuel?.comment,
                                onStringChanged: (changedStr) {
                                  widget.comment = changedStr;
                                },
                                paddingTop: 10,
                                paddingLeft: 20.0,
                                icon: Icon(
                                  Icons.comment,
                                  color: blueColor,
                                ),
                                label: "Comments",
                                multiline: true)
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
                                  _updateFuelEvent(fuel);
                                },
                                onDelete: (isPress) {
                                  _deleteEvent(fuel);
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
                                  _saveFuelEvent();
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
            },
          ),
        )
      ],
    );
  }

  Future<int> _getMaxMileadeForCar() async{
    var car = await carsBloc.selectedCar.first;
    if(car == null)
      return 0;
    return await widget.eventsRepository.getMaxMileageInCar(car.carId);
  }

  _saveFuelEvent() {
    if (widget.idEvent == null)
      eventsBloc.saveFuelEvent(converToNewFuelEvent(null));
  }

  _updateFuelEvent(Fuel event) {
    if (event?.eventId != null)
      eventsBloc.updateFuelEvent(converToNewFuelEvent(event));
  }

  Fuel converToNewFuelEvent(Fuel event) {
    widget.idEvent = event?.getEventId ?? Uuid().v4().toString();
    var fuelId = event?.fuelId ?? Uuid().v4().toString();
    var unitPrice = widget.unitPrice ?? event?.unitPrice;
    var volume = widget.volume ?? event?.volume;
    double mod = pow(10.0, 2);
    var costs = (((volume * unitPrice) * mod).round().toDouble() / mod);
    var formatter = new DateFormat('yyyy-MM-dd');
    return new Fuel.toEvent(
        fuelId,
        volume,
        widget.idEvent,
        categories[2].categoryId,
        event?.idUser ?? "",
        event?.idCar ?? "",
        widget.date ?? event?.date ?? formatter.format(new DateTime.now()),
        costs,
        unitPrice,
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
