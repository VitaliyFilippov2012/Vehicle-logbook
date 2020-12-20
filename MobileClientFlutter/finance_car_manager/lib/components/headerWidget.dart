import 'package:flutter/material.dart';

import 'package:finance_car_manager/components/WidgetButtonAnimation.dart';
import 'package:finance_car_manager/components/profileIconWidget.dart';
import 'package:finance_car_manager/screens/mainScreen.dart';
import 'package:finance_car_manager/style/styles.dart';

class HeaderWidget extends StatefulWidget {
  final Widget childToPushreplacement;
  final Widget prevChild;


  const HeaderWidget({
    Key key,
    this.childToPushreplacement,
    this.prevChild,
  }) : super(key: key);

  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.11,
      decoration: BoxDecoration(
          color: blueColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(color: blueColor.withOpacity(0.5), blurRadius: 5)
          ]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => widget.prevChild ?? MainScreen()),
                );
              }),
          widget.childToPushreplacement != null
              ? WidgetButtonAnimation(
                  widget: ProfileIconWidget(
                    fontColor: Colors.white,
                  ),
                  background: blueColor,
                  borderColor: Color(0xFFF1a7a8c),
                  child: widget.childToPushreplacement,
                  begin: 10.0,
                  end: 255.0,
                  milliseconds: 600,
                )
              : ProfileIconWidget(
                  fontColor: Colors.white,
                )
        ],
      ),
    );
  }
}
