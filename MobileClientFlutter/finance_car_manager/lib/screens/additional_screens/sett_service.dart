import 'package:finance_car_manager/blocs/carsBloc.dart';
import 'package:finance_car_manager/components/detailsWrapper.dart';
import 'package:finance_car_manager/components/saveButton.dart';
import 'package:finance_car_manager/db_context/eventsRepository.dart';
import 'package:finance_car_manager/models/category.dart';
import 'package:flutter/material.dart';
import 'package:finance_car_manager/models/type.dart';
import 'package:finance_car_manager/animations/fadeAnimation.dart';
import 'package:finance_car_manager/blocs/eventsBloc.dart';
import 'package:finance_car_manager/components/dateTextField.dart';
import 'package:finance_car_manager/components/deleteUpdateButtons.dart';
import 'package:finance_car_manager/components/headerWidget.dart';
import 'package:finance_car_manager/components/validationTextField.dart';
import 'package:finance_car_manager/components/willPopScopeWithBackground.dart';
import 'package:finance_car_manager/models/details.dart';
import 'package:finance_car_manager/models/event.dart';
import 'package:finance_car_manager/models/eventService.dart';
import 'package:finance_car_manager/screens/mainScreen.dart';
import 'package:finance_car_manager/style/styles.dart';
import 'package:finance_car_manager/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class SettingsService extends StatefulWidget {
  String idEvent;
  String idTypeService;
  String name;
  String date;
  double costs;
  double unitPrice;
  String comment;
  int mileage;
  String photo;
  String addressStation;
  EventsRepository eventsRepository;
  List<Details> details = new List<Details>();

  SettingsService({Key key, this.idEvent}) : super(key: key);

  @override
  _SettingsServiceState createState() => _SettingsServiceState();
}

class _SettingsServiceState extends State<SettingsService> {
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
    eventsBloc.getServiceEventById(widget.idEvent);
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
          child: FutureBuilder<EventService>(
            future: widget.idEvent != null
                ? eventsBloc.getServiceEventById(widget.idEvent)
                : null,
            builder: (context, snapshot) {
              var service = snapshot.data;
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
                      0.6,
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
                                      : service?.photo != null
                                          ? Utility.imageFromBase64String(
                                              service.getPhoto)
                                          : Image.asset(
                                              "assets/images/default-photo-service.jpg",
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
                                ValidationTextField(
                                  text: "Service",
                                  isEditable: false,
                                  label: "Type Event",
                                  procentWidth: 0.5,
                                  paddingLeft: 5.0,
                                  paddingTop: 25.0,
                                ),
                              ]),
                              Row(children: <Widget>[
                                ValidationTextField(
                                  text: widget?.name ?? service?.name,
                                  onStringChanged: (changedStr) {
                                    widget.name = changedStr;
                                  },
                                  label: "Name",
                                  procentWidth: 0.5,
                                  paddingLeft: 5.0,
                                  paddingTop: 0.0,
                                  validator: (value) {
                                    return (stringNotEmpty(value));
                                  },
                                ),
                              ]),
                              Row(
                                children: <Widget>[
                                  FutureBuilder<int>(
                              future: _getMaxMileadeForCar(),
                              builder: (context, AsyncSnapshot<int> snapshot) {
                                var mileage = snapshot.data;
                            return ValidationTextField(
                                    text: widget?.mileage?.toString() ??
                                        service?.mileage?.toString() ?? mileage?.toString(),
                                    onStringChanged: (changedStr) {
                                      widget.mileage = int.parse(changedStr);
                                    },
                                    label: "Mileage",
                                    procentWidth: 0.5,
                                    paddingTop: 0.0,
                                    paddingLeft: 5.0,
                                    validator: (value) {
                                      return (stringNotEmpty(value) &&
                                          !value.contains(new RegExp(
                                              r'([a-zA-Z])|([а-яА-Я])')));
                                    },
                                  );}),
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
                            ValidationTextField(
                              text: widget?.costs?.toString() ??
                                  service?.costs?.toString(),
                              onStringChanged: (changedStr) {
                                widget.costs = double.parse(changedStr);
                              },
                              label: "Total costs",
                              icon: Icon(
                                Icons.attach_money,
                                color: blueColor,
                              ),
                              procentWidth: 0.443,
                              paddingTop: 10.0,
                              paddingLeft: 20.0,
                              validator: (value) {
                                return (stringNotEmpty(value) &&
                                    !value.contains(
                                        new RegExp(r'([a-zA-Z])|([а-яА-Я])')));
                              },
                            ),
                            ValidationTextField(
                              text: widget?.unitPrice?.toString() ??
                                  service?.unitPrice?.toString(),
                              onStringChanged: (changedStr) {
                                widget.unitPrice = double.parse(changedStr);
                              },
                              label: "Costs work",
                              icon: Icon(
                                Icons.attach_money,
                                color: blueColor,
                              ),
                              procentWidth: 0.5,
                              paddingTop: 10.0,
                              paddingLeft: 0.0,
                              validator: (value) {
                                return (stringNotEmpty(value) &&
                                    !value.contains(
                                        new RegExp(r'([a-zA-Z])|([а-яА-Я])')));
                              },
                            )
                          ],
                        )),
                    FadeAnimation(
                        1.0,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            DateTextField(
                              date: widget.date ?? service?.date,
                              onDateTextChanged: (date) {
                                setState(() {
                                  widget.date = date;
                                });
                              },
                              label: "Date",
                              procentWidth: 0.443,
                              paddingLeft: 20.0,
                              paddingTop: 0.0,
                            ),
                            FutureBuilder<List<Type>>(
                                future: eventsBloc.getEventServiceTypes(),
                                builder: (context, snapshot) {
                                  var listTypes = snapshot.data;
                                  if (listTypes == null) {
                                    return Text("No data");
                                  } else {
                                    return Padding(
                                      padding: EdgeInsets.fromLTRB(0, 5, 5, 10),
                                      child: Container(
                                        width: screenWidth * 0.5,
                                        child: snapshot.data != null
                                            ? DropdownButton<String>(
                                                items: [
                                                  for (int i = 0;
                                                      i < listTypes.length;
                                                      i++)
                                                    DropdownMenuItem(
                                                      value: listTypes
                                                          .elementAt(i)
                                                          .typeId
                                                          .toString(),
                                                      child: Text(
                                                        listTypes
                                                            .elementAt(i)
                                                            .typeString,
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFFF234253),
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 25),
                                                      ),
                                                    ),
                                                ],
                                                onChanged: (value) {
                                                  setState(() {
                                                    widget.idTypeService = value;
                                                  });
                                                },
                                                value: widget.idTypeService ?? service?.idTypeService ??
                                                    listTypes.first.typeId,
                                              )
                                            : Container(),
                                      ),
                                    );
                                  }
                                }),
                          ],
                        )),
                    isSaved &&
                            (service?.details != null &&
                                service.details.isEmpty)
                        ? Container()
                        : FadeAnimation(
                            1.1,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                DetailsWrapper(
                                  isSaved: isSaved,
                                  onChagedListDetails: (updateList) {
                                    widget.details = updateList;
                                  },
                                  details: widget.details?.isNotEmpty == false
                                      ? service?.details
                                      : widget?.details,
                                )
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
                                  service?.addressStation,
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
                        1.3,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ValidationTextField(
                                text: widget.comment ?? service?.comment,
                                onStringChanged: (changedStr) {
                                  widget.comment = changedStr;
                                },
                                paddingTop: 0,
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
                                  _updateServiceEvent(service);
                                },
                                onDelete: (isPress) {
                                  _deleteEvent(service);
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
                                  _saveServiceEvent();
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
  
  _saveServiceEvent() {
    if (widget.idEvent == null)
      eventsBloc.saveServiceEvent(converToNewServiceEvent(null));
  }

  _updateServiceEvent(EventService event) {
    if (event?.eventId != null)
      eventsBloc.updateServiceEvent(converToNewServiceEvent(event));
  }

  EventService converToNewServiceEvent(EventService event) {
    widget.idEvent = event?.getEventId ?? Uuid().v4().toString();
    var serviceId = event?.serviceId ?? Uuid().v4().toString();
    var typeServiceId = widget.idTypeService ?? event.idTypeService;
    var formatter = new DateFormat('yyyy-MM-dd');
    return new EventService.toEvent(
        widget.idEvent,
        categories[3].categoryId,
        event?.idUser ?? "",
        event?.idCar ?? "",
        widget.date ?? event?.date ?? formatter.format(new DateTime.now()),
        widget.costs ?? event?.costs,
        widget.unitPrice ?? event?.unitPrice,
        widget.comment ?? event?.comment,
        widget.mileage ?? event?.mileage,
        null, //widget.photo ?? event.photo,
        widget.addressStation ?? event?.addressStation,
        serviceId,
        typeServiceId,
        widget.name ?? event?.name,
        widget.details);
  }

  _deleteEvent(Event event) {
    if (event?.eventId == null) return;
    eventsBloc.deleteEvent(event.eventId);
  }
}
