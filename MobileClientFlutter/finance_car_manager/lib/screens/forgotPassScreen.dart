import 'package:finance_car_manager/screens/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:finance_car_manager/components/loginWidget.dart';
import 'package:finance_car_manager/screens/loginScreen.dart';

class ForgotPassScreen extends StatefulWidget {
  @override
  _ForgotPassScreenState createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  @override
  Widget build(BuildContext context) {
    LoginScreen loginWidget = LoginScreen(mainLabel: "And Last step");
    LoginWidget emailWidget = LoginWidget(
        labelForButton: "Next",
        mainLabel: "Do not worry",
        loginForServer: true,
        label: "Enter your email so that we can send you a new password",
        type: ScreenType.forgot,
        prevChild: HomeScreen(),
        child: loginWidget);
    return emailWidget;
  }
}
