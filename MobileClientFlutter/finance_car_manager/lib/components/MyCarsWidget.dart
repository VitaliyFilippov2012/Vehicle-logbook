import 'package:finance_car_manager/blocs/carsBloc.dart';
import 'package:finance_car_manager/components/carWidget.dart';
import 'package:finance_car_manager/components/car_details/carDetailsPage.dart';
import 'package:finance_car_manager/models/car.dart';
import 'package:finance_car_manager/state/appState.dart';
import 'package:finance_car_manager/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyCarsWidget extends StatefulWidget {
  @override
  _MyCarsWidgetState createState() => _MyCarsWidgetState();
}

class _MyCarsWidgetState extends State<MyCarsWidget> {
  @override
  void initState() {
    super.initState();
    carsBloc.getAllCars();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Car>>(
      stream: carsBloc.allCars,
      builder: (context, snapshot) {
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
        }
        else if (snapshot.hasData) {
          return Container(
            height: 350,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Consumer<AppState>(
              builder: (context, appState, _) => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    for (final car in snapshot.data)
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => CarDetailsPage(car: car),
                            ),
                          );
                        },
                        child: CarWidget(
                          car: car,
                        ),
                      )
                  ],
                ),
              ),
            ),
          );
        }
        else{
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
  }
}
