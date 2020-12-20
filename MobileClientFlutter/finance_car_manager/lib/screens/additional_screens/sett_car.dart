import 'package:finance_car_manager/components/deleteUpdateButtons.dart';
import 'package:finance_car_manager/components/saveButton.dart';
import 'package:flutter/material.dart';
import 'package:finance_car_manager/animations/fadeAnimation.dart';
import 'package:finance_car_manager/blocs/carsBloc.dart';
import 'package:finance_car_manager/components/headerWidget.dart';
import 'package:finance_car_manager/components/validationTextField.dart';
import 'package:finance_car_manager/components/willPopScopeWithBackground.dart';
import 'package:finance_car_manager/models/car.dart';
import 'package:finance_car_manager/screens/AccountScreen.dart';
import 'package:finance_car_manager/screens/additional_screens/sett_aboutMe.dart';
import 'package:finance_car_manager/style/styles.dart';
import 'package:finance_car_manager/utils/utils.dart';
import 'package:uuid/uuid.dart';

class SettingsCar extends StatefulWidget {
  String idCar;
  String photo;
  String mark;
  String model;
  int yearIssue;
  String comment;
  int vin;
  int power;
  int volumeEngine;
  String typeTransmission;
  String fuelType;

  SettingsCar({Key key, this.idCar}) : super(key: key);

  @override
  _SettingsCarState createState() => _SettingsCarState();
}

class _SettingsCarState extends State<SettingsCar> {
  bool isSaved;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    isSaved = false;
    if(widget.idCar != null){
      isSaved = true;
      carsBloc.getSelectedCars(widget.idCar);
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
      childToWillPop: AccountScreen(),
      children: [
        Form(
          key: _formKey,
          child: FutureBuilder<Car>(
            future:
                widget.idCar != null ? carsBloc.getCarById(widget.idCar) : null,
            builder: (context, snapshot) {
              var car = snapshot?.data;
              var active = car != null ? car.active : true;
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
                    FadeAnimation(
                        0.4,
                        HeaderWidget(
                          childToPushreplacement: SettingsAboutMe(),
                          prevChild: AccountScreen(),
                        )),
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
                                      : car?.getPhoto != null
                                          ? Utility.imageFromBase64String(
                                              car.getPhoto)
                                          : Image.asset(
                                              'assets/images/img1.jpg',
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
                                    isEditable: active,
                                    text: widget.mark ?? car?.getMark,
                                    onStringChanged: (changedStr) {
                                      widget.mark = changedStr;
                                    },
                                    label: "Mark",
                                    procentWidth: 0.5,
                                    paddingLeft: 5.0,
                                    paddingTop: 20,
                                    validator: (value){
                                      return active == false || stringNotEmpty(value);
                                    }),
                              ]),
                              Row(children: <Widget>[
                                ValidationTextField(
                                    isEditable: active,
                                    paddingTop: 10,
                                    text: widget.model ?? car?.model,
                                    onStringChanged: (changedStr) {
                                      widget.model = changedStr;
                                    },
                                    label: "Model",
                                    procentWidth: 0.5,
                                    paddingLeft: 5.0,
                                    validator: (value){
                                      return active == false || stringNotEmpty(value);
                                    } )
                              ]),
                              Row(
                                children: <Widget>[
                                  ValidationTextField(
                                      isEditable: active,
                                      paddingTop: 10,
                                      text: widget?.fuelType ?? car?.typeFuel,
                                      onStringChanged: (changedStr) {
                                        widget.fuelType = changedStr;
                                      },
                                      label: "Fuel type",
                                      procentWidth: 0.5,
                                      paddingLeft: 5.0,
                                      validator: (value){
                                      return active == false || stringNotEmpty(value);
                                    })
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    FadeAnimation(
                        0.7,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ValidationTextField(
                              isEditable: active,
                              text: widget?.yearIssue?.toString() ??
                                  car?.yearIssue?.toString(),
                              onStringChanged: (changedStr) {
                                widget.yearIssue = int.parse(changedStr);
                              },
                              paddingTop: 10,
                              label: "Year issue",
                              procentWidth: 0.45,
                              paddingRight: 0.0,
                              maxLength: 4,
                              validator: (value) {
                                return (active == false || (!value.contains(
                                        new RegExp(r'([a-zA-Z])|([а-яА-Я])')) &&
                                    value.length == 4));
                              },
                            ),
                            ValidationTextField(
                                isEditable: active,
                                text: widget.typeTransmission ??
                                    car?.typeTransmission,
                                onStringChanged: (changedStr) {
                                  widget.typeTransmission = changedStr;
                                },
                                paddingTop: 10,
                                label: "Transm",
                                procentWidth: 0.5,
                                validator: (value) {
                                  return (active == false || (stringNotEmpty(value) &&
                                      value.contains(new RegExp(
                                          r'([a-zA-Z])|([а-яА-Я])')) &&
                                      value.length <= 10));
                                }),
                          ],
                        )),
                    FadeAnimation(
                        0.8,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ValidationTextField(
                                isEditable: active,
                                text: widget?.power?.toString() ??
                                    car?.power?.toString(),
                                onStringChanged: (changedStr) {
                                  widget.power = int.parse(changedStr);
                                },
                                paddingTop: 10,
                                label: "Power",
                                procentWidth: 0.45,
                                paddingRight: 0.0,
                                validator: (value) {
                                  return (active == false || (stringNotEmpty(value) &&
                                      !value.contains(new RegExp(
                                          r'([a-zA-Z])|([а-яА-Я])')) &&
                                      value.length <= 5));
                                }),
                            ValidationTextField(
                                isEditable: active,
                                text: widget?.volumeEngine?.toString() ??
                                    car?.volumeEngine?.toString(),
                                onStringChanged: (changedStr) {
                                  widget.volumeEngine = int.parse(changedStr);
                                },
                                paddingTop: 10,
                                label: "Volume",
                                procentWidth: 0.5,
                                validator: (value) {
                                  return (active == false || (stringNotEmpty(value) &&
                                      !value.contains(new RegExp(
                                          r'([a-zA-Z])|([а-яА-Я])')) &&
                                      value.length <= 8));
                                })
                          ],
                        )),
                    FadeAnimation(
                        0.9,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ValidationTextField(
                                isEditable: active,
                                text: widget.vin?.toString() ?? car?.vin?.toString(),
                                onStringChanged: (changedStr) {
                                  widget.vin = int.parse(changedStr);
                                },
                                paddingTop: 10,
                                icon: Icon(
                                  Icons.drive_eta,
                                  color: blueColor,
                                ),
                                label: "VIN",
                                maxLength: 17,
                                validator: (value) {
                                  return (active == false || (stringNotEmpty(value) &&
                                      !value.contains(new RegExp(
                                          r'([a-zA-Z])|([а-яА-Я])')) &&
                                      value.length == 17));
                                })
                          ],
                        )),
                    FadeAnimation(
                        1.2,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ValidationTextField(
                                isEditable: active,
                                text: widget.comment ?? car?.comment,
                                onStringChanged: (changedStr) {
                                  widget.comment = changedStr;
                                },
                                paddingTop: 10,
                                icon: Icon(
                                  Icons.comment,
                                  color: blueColor,
                                ),
                                label: "Comments",
                                multiline: true)
                          ],
                        )),
                    FadeAnimation(
                      1.4,
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30.0),
                        child: isSaved
                            ? DeleteUpdateButtons(
                                formKey: _formKey,
                                onUpdate: (isPress) {
                                  if(!active){
                                    _updateCar(car);
                                  }
                                },
                                onDelete: (isPress) {
                                  _deleteCar(car);
                                  setState(() {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AccountScreen()),
                                      );
                                    });
                                },
                              )
                            : SaveButton(
                                formKey: _formKey,
                                onSave: (isPress) {
                                  _saveCar();
                                  setState((){
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
        ),
      ],
    );
  }

  _saveCar() {
    if(widget.idCar == null)
      carsBloc.saveCar(converToNewCar(null));
  }

  _updateCar(Car car) {
    if(car?.carId != null && car.active == true)
      carsBloc.updateCar(converToNewCar(car));
  }

  Car converToNewCar(Car car) {
    widget.idCar = car?.getCarId ?? Uuid().v4().toString();
    return new Car(
      carId: widget.idCar,
      active: car?.getActive ?? true,
      typeFuel: widget.fuelType ?? car.getTypeFuel,
      typeTransmission: widget.typeTransmission ?? car.getTypeTransmission,
      mark: widget.mark ?? car.getMark,
      model: widget.model ?? car.getModel,
      volumeEngine: widget.volumeEngine ?? car.volumeEngine,
      power: widget.power ?? car.power,
      vin: widget.vin ?? car.vin,
      yearIssue: widget.yearIssue ?? car.yearIssue,
      comment: widget?.comment ?? car?.comment ?? "",
      photo: null,
    );
  }

  _deleteCar(Car car) {
    if(car?.carId == null || car.active == false)
      return;
    carsBloc.deleteCarForever(car.carId);
  }
}
