import 'package:finance_car_manager/components/WidgetButtonAnimation.dart';
import 'package:finance_car_manager/components/pageBackground.dart';
import 'package:finance_car_manager/components/profileIconWidget.dart';
import 'package:finance_car_manager/screens/additional_screens/sett_aboutMe.dart';
import 'package:finance_car_manager/screens/additional_screens/sett_car.dart';
import 'package:finance_car_manager/screens/mainScreen.dart';
import 'package:finance_car_manager/state/appState.dart';
import 'package:finance_car_manager/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:finance_car_manager/animations/fadeAnimation.dart';
import 'package:finance_car_manager/components/MyCarsWidget.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: ChangeNotifierProvider<AppState>(
        create: (_) => AppState(),
        child: Stack(
          children: <Widget>[
            PageBackground(
              screenHeight: screenHeight,
            ),
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                                child: IconButton(
                                    icon: Icon(Icons.arrow_back,
                                        color: Color(0x99FFFFFF), size: 30),
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MainScreen()),
                                      );
                                    }),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: Text(
                                  "My Cars",
                                  style: whiteHeadingTextStyle,
                                ),
                              ),
                            ]),
                        Spacer(),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 20, 10, 10),
                                  child: WidgetButtonAnimation(
                                    widget: ProfileIconWidget(
                                      fontColor: Color(0x99FFFFFF),
                                    ),
                                    background: blueColor,
                                    borderColor: Color(0xFFF1a7a8c),
                                    child: SettingsAboutMe(),
                                    begin: 10.0,
                                    end: 255.0,
                                    milliseconds: 600,
                                  ))
                            ])
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: FadeAnimation(0.8, MyCarsWidget()),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => SettingsCar(),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: blueColor,
      ),
    );
  }
}
