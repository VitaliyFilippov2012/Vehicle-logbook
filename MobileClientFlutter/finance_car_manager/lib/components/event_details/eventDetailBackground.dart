import 'package:finance_car_manager/components/imageCliper.dart';
import 'package:flutter/material.dart';
import 'package:finance_car_manager/models/event.dart';
import 'package:provider/provider.dart';
import 'package:finance_car_manager/utils/utils.dart';

class EventDetailsBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final event = Provider.of<Event>(context);

    return Align(
      alignment: Alignment.topCenter,
      child: ClipPath(
        clipper: ImageClipper(),
        child: event?.photo != null ? Utility.imageFromBase64String(event.photo)
            : Image.asset(
          event.getDefaultImagePathByType(),
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