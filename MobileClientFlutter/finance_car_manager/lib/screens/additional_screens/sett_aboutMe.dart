import 'dart:convert';

import 'package:finance_car_manager/animations/fadeAnimation.dart';
import 'package:finance_car_manager/blocs/userInfoBloc.dart';
import 'package:finance_car_manager/components/dateTextField.dart';
import 'package:finance_car_manager/components/headerWidget.dart';
import 'package:finance_car_manager/components/validationTextField.dart';
import 'package:finance_car_manager/components/willPopScopeWithBackground.dart';
import 'package:finance_car_manager/models/UserInfo.dart';
import 'package:finance_car_manager/screens/accountScreen.dart';
import 'package:finance_car_manager/screens/mainScreen.dart';
import 'package:finance_car_manager/style/styles.dart';
import 'package:finance_car_manager/utils/utils.dart';
import 'package:flutter/material.dart';

class SettingsAboutMe extends StatefulWidget {
  String photo;
  Image img;
  String lastname;
  String name;
  String patronymic;
  String phone;
  String birthday;
  String sex;
  String address;
  String comments;
  String city;

  @override
  _SettingsAboutMeState createState() => _SettingsAboutMeState();
}

class _SettingsAboutMeState extends State<SettingsAboutMe> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width - (20 + 0);
    bool Function(String) stringNotEmpty = (value) {
      return value?.isNotEmpty == true;
    };
    bool Function(String) ifStringForGender = (value) {
      return value.toLowerCase() == 'f' || value.toLowerCase() == 'm';
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
          child: FutureBuilder<UserInfo>(
            future: userInfoBloc.getUser(),
            builder: (context, snapshot) {
              var user = snapshot.data;
              if (snapshot.hasError || snapshot.data == null) {
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
                              padding: EdgeInsets.fromLTRB(20, 25, 0, 10),
                              child: Container(
                                width: screenWidth * 0.45,
                                height: 220,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20.0),
                                  ),
                                  child: widget.photo != null ? Utility.imageFromBase64String(widget.photo) :
                                      user?.photo != null ? Utility.imageFromBase64String(user.getPhoto) :
                                      Image.asset(
                                        "assets/images/default-photo.jpg",
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
                                  text: widget.lastname ?? user.getLastname,
                                  onStringChanged: (changedStr) {
                                    widget.lastname = changedStr;
                                  },
                                  label: "Lastname",
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
                                  text: widget.name ?? user.getName,
                                  onStringChanged: (changedStr) {
                                    widget.name = changedStr;
                                  },
                                  label: "Name",
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
                              Row(
                                children: <Widget>[
                                  ValidationTextField(
                                    text: widget.patronymic ?? user.getPatronymic,
                                    onStringChanged: (changedStr) {
                                      widget.patronymic = changedStr;
                                    },
                                    label: "Patronymic",
                                    procentWidth: 0.5,
                                    paddingLeft: 5.0,
                                    paddingTop: 25,
                                    validator: (value) {
                                      return (stringNotEmpty(value) &&
                                          value.contains(new RegExp(
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
                            ValidationTextField(
                              text: widget.phone ?? user.getPhone,
                              onStringChanged: (changedStr) {
                                widget.phone = changedStr;
                              },
                              label: "Phone",
                              procentWidth: 0.7,
                              paddingLeft: 20.0,
                              validator: (value) {
                                return (stringNotEmpty(value) &&
                                    !value.contains(
                                        new RegExp(r'([a-zA-Z])|([а-яА-Я])')));
                              },
                            ),
                            ValidationTextField(
                              text: widget.sex ?? user.getSex,
                              onStringChanged: (changedStr) {
                                widget.sex = changedStr;
                              },
                              label: "Sex",
                              procentWidth: 0.22,
                              paddingLeft: 5.0,
                              validator: (value) {
                                return (stringNotEmpty(value) &&
                                    ifStringForGender(value));
                              },
                            ),
                          ],
                        )),
                    FadeAnimation(
                        1.0,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            DateTextField(
                              date: widget.birthday ?? user.getBirthday,
                              onDateTextChanged: (changedStr) {
                                setState(() {
                                  widget.birthday = changedStr;
                                });
                              },
                              label: "Birthday",
                              paddingLeft: 20.0,
                              procentWidth: 0.5,
                              paddingTop: 20,
                            ),
                            ValidationTextField(
                              text: widget.city ?? user.city,
                              onStringChanged: (changedStr) {
                                widget.city = changedStr;
                              },
                              icon: Icon(
                                Icons.location_city,
                                color: blueColor,
                              ),
                              label: "City",
                              paddingLeft: 0.0,
                              procentWidth: 0.4,
                              paddingTop: 20.0,
                              validator: (value) {
                                return (stringNotEmpty(value));
                              },
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
                              text: widget.address ?? user.address,
                              onStringChanged: (changedStr) {
                                widget.address = changedStr;
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
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            ButtonTheme(
                              minWidth: 150.0,
                              height: 50.0,
                              child: RaisedButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(18.0),
                                    side: BorderSide(color: blueColor)),
                                color: blueColor,
                                disabledColor: Colors.grey,
                                disabledTextColor: Colors.black,
                                padding: EdgeInsets.all(14.0),
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    var updateUser = UserInfo(
                                        address:
                                            widget.address ?? user.getAddress,
                                        userId: user.getUserId,
                                        sex: widget.sex ?? user.getSex,
                                        birthday:
                                            widget.birthday ?? user.getBirthday,
                                        name: widget.name ?? user.getName,
                                        lastname:
                                            widget.lastname ?? user.getLastname,
                                        patronymic: widget.patronymic ??
                                            user.getPatronymic,
                                        phone:
                                            widget.phone ?? user.getPhone,
                                        city: widget.city ?? user.getCity,
                                        photo: widget.photo ?? user.getPhoto);
                                    userInfoBloc.updateUserInfo(updateUser);
                                  }
                                },
                                child: Text(
                                  'Update',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
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
}
