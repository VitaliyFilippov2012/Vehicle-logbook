import 'package:finance_car_manager/components/car_details/carDetailsBackground.dart';
import 'package:finance_car_manager/components/car_details/carDetailsContent.dart';
import 'package:finance_car_manager/models/car.dart';
import 'package:finance_car_manager/screens/additional_screens/sett_car.dart';
import 'package:finance_car_manager/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class CarDetailsPage extends StatelessWidget {
  final Car car;

  const CarDetailsPage({Key key, this.car}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Provider<Car>.value(
        value: car,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            CarDetailsBackground(),
            CarDetailsContent(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => SettingsCar(idCar: car.carId,),
                ),
              );
            },
            child: Icon(Icons.edit),
            backgroundColor: blueColor,
          ),
    );
  }
}