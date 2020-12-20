import 'package:finance_car_manager/blocs/userInfoBloc.dart';
import 'package:finance_car_manager/components/WidgetButtonAnimation.dart';
import 'package:finance_car_manager/components/listEvents.dart';
import 'package:finance_car_manager/screens/AccountScreen.dart';
import 'package:finance_car_manager/components/profileIconWidget.dart';
import 'package:finance_car_manager/screens/additional_screens/sett_event.dart';
import 'package:finance_car_manager/screens/additional_screens/sett_fuels.dart';
import 'package:finance_car_manager/screens/additional_screens/sett_service.dart';
import 'package:flutter/material.dart';
import 'package:finance_car_manager/models/category.dart';
import 'package:provider/provider.dart';
import 'package:finance_car_manager/state/appState.dart';
import 'package:finance_car_manager/components/categoryWidget.dart';
import 'package:finance_car_manager/style/styles.dart';
import 'package:finance_car_manager/components/pageBackground.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    userInfoBloc.getUserInfo();
  }

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
                                padding:
                                    const EdgeInsets.fromLTRB(22, 20, 0, 20),
                                child: Text(
                                  "LOCAL EVENTS",
                                  style: fadedTextStyle,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(22, 0, 0, 0),
                                child: Text(
                                  "What's Up",
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
                                    child: AccountScreen(),
                                    begin: 10.0,
                                    end: 255.0,
                                    milliseconds: 600,
                                  ))
                            ])
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      child: Consumer<AppState>(
                        builder: (context, appState, _) =>
                            SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: <Widget>[
                              for (final category in categories)
                                CategoryWidget(category: category)
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Consumer<AppState>(
                          builder: (context, appState, _) =>
                              ListEvents(typeEvent: appState.category)),
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
          _asyncSimpleDialog(context);
        },
        child: Icon(Icons.add),
        backgroundColor: blueColor,
      ),
    );
  }

  _asyncSimpleDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.all(30),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            title: Text(
              'Select type Event',
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => SettingsFuel(),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: blueColor),
                  child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      child: Text(
                        'Fuel',
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFFFFF),
                        ),
                      )),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => SettingsService(),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: blueColor),
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    child: Text(
                      'Service',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => SettingsEvent(),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: blueColor),
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    child: Text(
                      'Other',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
