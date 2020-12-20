import 'package:finance_car_manager/components/imageCliper.dart';
import 'package:finance_car_manager/models/car.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finance_car_manager/utils/utils.dart';

class CarDetailsBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final car = Provider.of<Car>(context);

    return Align(
      alignment: Alignment.topCenter,
      child: ClipPath(
        clipper: ImageClipper(),
        child: car?.photo != null ? Utility.imageFromBase64String(car.photo)
            : Image.asset(
          'assets/images/img1.jpg',
          fit: BoxFit.cover,
          width: screenWidth,
          color: Color(0x99000000),
          colorBlendMode: BlendMode.darken,
          height: screenHeight * 0.5,
        ),
      ),
    );
  }
}