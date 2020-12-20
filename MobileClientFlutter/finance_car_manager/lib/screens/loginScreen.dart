import 'package:flutter/material.dart';
import 'package:finance_car_manager/components/loginWidget.dart';
import 'package:finance_car_manager/screens/mainScreen.dart';
import 'package:finance_car_manager/screens/homeScreen.dart';

class LoginScreen extends StatefulWidget {
  final String mainLabel;

  LoginScreen({
    Key key,
    this.mainLabel = "Welcome",
  }) : super(key: key);


  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()),),
      child: LoginWidget(labelForButton: "Login" , mainLabel: widget.mainLabel, label:"Sign to Continue", type: ScreenType.login, loginForServer: true,child: MainScreen(),prevChild: HomeScreen(),)
    );
  }
}