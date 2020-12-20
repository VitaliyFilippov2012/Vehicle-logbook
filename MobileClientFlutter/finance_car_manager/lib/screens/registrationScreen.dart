import 'package:finance_car_manager/components/loginWidget.dart';
import 'package:finance_car_manager/screens/homeScreen.dart';
import 'package:finance_car_manager/screens/loginScreen.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            ),
        child: LoginWidget(
            loginForServer: true,
            labelForButton: "Sign Up",
            mainLabel: "Welcome",
            label: "Register to Continue",
            type: ScreenType.auth,
            prevChild: HomeScreen(),
            child: LoginScreen(mainLabel: "Last step")));
  }
}
