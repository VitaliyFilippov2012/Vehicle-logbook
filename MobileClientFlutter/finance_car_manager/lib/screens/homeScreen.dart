import 'package:finance_car_manager/animations/fadeAnimation.dart';
import 'package:finance_car_manager/components/buttonAnimation.dart';
import 'package:finance_car_manager/components/customButton.dart';
import 'package:finance_car_manager/screens/registrationScreen.dart';
import 'package:finance_car_manager/screens/forgotPassScreen.dart';
import 'package:finance_car_manager/screens/loginScreen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context){
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
      height: screenHeight,
      width: screenWidth,
      child: Stack(fit: StackFit.expand, children: <Widget>[
        Image.asset("assets/images/img3.jpg", fit: BoxFit.cover),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Color(0xFFF001117).withOpacity(0.5),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          margin: EdgeInsets.only(top: 80, bottom: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  FadeAnimation(
                      1.8,
                      Text("Finance Car",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              letterSpacing: 2))),
                  FadeAnimation(
                      2.2,
                      Text("Manager",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ))),
                  FadeAnimation(
                      1.8,
                      Text("#Останься дома",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 3))),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FadeAnimation(
                      2.6,
                      CustomButton(
                        label: "Sign Up",
                        background: Colors.transparent,
                        fontColor: Colors.white,
                        borderColor: Colors.white,
                        child: RegistrationScreen(),
                      )),
                  SizedBox(height: 20),
                  FadeAnimation(
                      3.0,
                      ButtonAnimation(
                        onProgress: (s){
                          
                        },
                        label: "Sign In",
                        fontColor: Color(0xFFF001117),
                        background: Colors.white,
                        borderColor: Colors.white,
                        child: LoginScreen(),
                        isIconNeed: false,
                        begin: 254.0,
                        end: 255.0,
                        milliseconds: 10,
                      )),
                  SizedBox(height: 30),
                  FadeAnimation(
                      3.5,
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.fade,
                                    child: ForgotPassScreen()));
                          },
                          child: Text("Forgot password",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  decoration: TextDecoration.underline))))
                ],
              )
            ],
          ),
        )
      ]),
    )));
  }
}
