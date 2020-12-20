import 'package:finance_car_manager/blocs/carsBloc.dart';
import 'package:finance_car_manager/components/buttonForGraph.dart';
import 'package:finance_car_manager/components/graph/circleGraphOutsideLabel.dart';
import 'package:finance_car_manager/components/graph/gridLineWithSelectDashPattern.dart';
import 'package:finance_car_manager/components/validationTextField.dart';
import 'package:finance_car_manager/models/car.dart';
import 'package:finance_car_manager/screens/graphPageView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finance_car_manager/style/styles.dart';

class CarDetailsContent extends StatefulWidget {
  @override
  _CarDetailsContentState createState() => _CarDetailsContentState();
}

class _CarDetailsContentState extends State<CarDetailsContent> {
  String login;

  @override
  Widget build(BuildContext context) {
    final car = Provider.of<Car>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 80,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
            child: Text(
              car.getMark + " " + car.getModel,
              style: eventWhiteTitleTextStyle,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.14),
            child: Text(
              'VIN: ' + car.getVin.toString(),
              style: eventLocationTextStyle.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.18),
            child: Text(
              'Type transmission: ' + car.getTypeTransmission,
              style: eventLocationTextStyle.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(screenWidth * 0.24, 0, 0, 0),
            child: Text(
              'Volume engine: ' + car.getVolumeEngine.toString() + " sm³",
              style: eventLocationTextStyle.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(screenWidth * 0.31, 0, 0, 0),
            child: Text(
              'Power engine: ' + car.getPower.toString() + " hp",
              style: eventLocationTextStyle.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(screenWidth * 0.40, 0, 0, 0),
            child: Text(
              'Type fuel: ' + car.getTypeFuel,
              style: eventLocationTextStyle.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(screenWidth * 0.50, 0, 0, 0),
            child: Text(
              'Year issue: ' + car.getYearIssue.toString(),
              style: eventLocationTextStyle.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            height: 130,
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            width: screenWidth,
            decoration: BoxDecoration(
                border: Border.all(color: blueColor),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(14))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    "To share your car with another user, enter email ",
                    style: labelStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: ValidationTextField(
                    borderInside: true,
                    onStringChanged: (changedStr) {
                      login = changedStr;
                    },
                    label: "Email",
                    procentWidth: 0.7,
                    paddingLeft: 0.0,
                    paddingTop: 0,
                    validator: (value) {
                      return (value == null ||
                          value == "" ||
                          (value != null &&
                              value.contains(new RegExp(r'([a-zA-Z])|(@)'))));
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: ButtonGraph(
                      children: <Widget>[
                        Text(
                          'Share car',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        )
                      ],
                      onClick: (inClick) {
                        if (login != null &&
                            login.contains(new RegExp(r'([a-zA-Z])|(@)'))) {
                          _shareCarWithUser(login, car.carId);
                        }
                      }),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ButtonGraph(
                      children: <Widget>[
                        Text(
                          'Disactive car',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        Icon(Icons.delete_forever, color: Colors.white)
                      ],
                      onClick: (inClick) {
                          carsBloc.deleteCar(car.carId);
                        }
                      ),
                  ButtonGraph(
                      children: <Widget>[
                        Text(
                          'Go to graphics',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        Icon(Icons.arrow_forward, color: Colors.white)
                      ],
                      onClick: (inClick) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => GraphPageView(
                              graphicsToShow: <Widget>[
                                GridLineWithSelectDashPattern(
                                    car.carId, true, TypeGraph.DailyMileage),
                                GridLineWithSelectDashPattern(
                                    car.carId, true, TypeGraph.TotalMileage),
                                CircleGraphWithOutsideLabel(
                                    animate: true,
                                    type: TypeCircleGraph.FuelCosts,
                                    carId: car.carId),
                                GridLineWithSelectDashPattern(
                                    car.carId, true, TypeGraph.FuelCostsVolume),
                                CircleGraphWithOutsideLabel(
                                    animate: true,
                                    type: TypeCircleGraph.ForAllType,
                                    carId: car.carId),
                                GridLineWithSelectDashPattern(
                                    car.carId, true, TypeGraph.FuelVolume),
                                GridLineWithSelectDashPattern(car.carId, true,
                                    TypeGraph.FuelSumCostsForDay),
                              ],
                            ),
                          ),
                        );
                      }),
                ],
              )),
        ],
      ),
    );
  }

  _shareCarWithUser(String email, String carId) {
    carsBloc.shareCarWithOtherUser(carId, email);
  }
}
