import 'package:finance_car_manager/db_context/userRepository.dart';
import 'package:finance_car_manager/models/userCredentials.dart';
import 'package:finance_car_manager/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:finance_car_manager/components/customTextField.dart';
import 'package:finance_car_manager/components/buttonAnimation.dart';
import 'package:loading_gifs/loading_gifs.dart';

class LoginWidget extends StatefulWidget {
  final bool loginForServer;
  Function action;
  final String labelForButton;
  final String mainLabel;
  final String label;
  final Widget child;
  Widget prevChild;
  ScreenType type;

  LoginWidget(
      {Key key,
      this.labelForButton,
      this.loginForServer = false,
      this.mainLabel,
      this.label,
      this.action,
      this.child,
      this.prevChild,
      this.type})
      : super(key: key);

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  UserRepository _repository;
  @override
  void initState() {
    super.initState();
    _repository = new UserRepository();
  }

  bool progress = false;
  String password = "";
  String login = "";
  String secondPassword;
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return FutureBuilder<UserCredentials>(
        future: _repository.checkKeepCredentials(),
        builder: (context, AsyncSnapshot<UserCredentials> snapshot) {
          UserCredentials credentials = snapshot.data;
          if (credentials != null && widget.type == ScreenType.login) {
            if (password.length == 0 && login.length == 0) {
              password = credentials.getPassword;
              login = credentials.getLogin;
            }
          }
          return WillPopScope(
            onWillPop: () async => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => widget.prevChild),
            ),
            child: Scaffold(
              body: SingleChildScrollView(
                child: Container(
                  height: screenHeight,
                  width: screenWidth,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage('assets/images/img2.jpg'),
                    fit: BoxFit.contain,
                    alignment: Alignment.topCenter,
                  )),
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        progress
                            ? FadeInImage.assetNetwork(
                                placeholder: cupertinoActivityIndicator,
                                image: "image.png",
                                placeholderScale: 2,
                              )
                            : Container(),
                        SizedBox(height: 15),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                IconButton(
                                    icon: Icon(Icons.arrow_back,
                                        color: Colors.white, size: 36),
                                    onPressed: () {
                                      progress = false;
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                widget.prevChild),
                                      );
                                      progress = true;
                                    }),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: screenHeight * 0.65 * 0.05),
                          height: screenHeight * 0.65,
                          width: screenWidth,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              )),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(widget.mainLabel,
                                    style: TextStyle(
                                        color: Color(0xFFF032f42),
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                  widget.label,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 25,
                                  ),
                                ),
                                Column(
                                  children: <Widget>[
                                    SizedBox(
                                        height: screenHeight * 0.65 * 0.05),
                                    CustomTextField(
                                      text: login,
                                      onStringChanged: (str) {
                                        login = str;
                                      },
                                      label: "Email",
                                    ),
                                  ],
                                ),
                                widget.type != ScreenType.forgot
                                    ? Column(
                                        children: <Widget>[
                                          SizedBox(
                                              height:
                                                  screenHeight * 0.65 * 0.05),
                                          CustomTextField(
                                            text: password,
                                            onStringChanged: (str) {
                                              password = str;
                                            },
                                            label: "Password",
                                            isPassword: true,
                                            icon: Icon(Icons.https,
                                                size: 27,
                                                color: Color(0xFFF032F41)),
                                          ),
                                        ],
                                      )
                                    : Container(),
                                widget.type == ScreenType.auth
                                    ? Column(
                                        children: <Widget>[
                                          SizedBox(
                                              height:
                                                  screenHeight * 0.65 * 0.03),
                                          CustomTextField(
                                            text: secondPassword,
                                            onStringChanged: (str) {
                                              secondPassword = str;
                                            },
                                            label: "Repeat Password",
                                            isPassword: true,
                                            icon: Icon(Icons.https,
                                                size: 27,
                                                color: Color(0xFFF032F41)),
                                          ),
                                        ],
                                      )
                                    : Container(),
                                SizedBox(height: screenHeight * 0.65 * 0.05),
                                ButtonAnimation(
                                  onProgress: (isInProgress) {
                                    setState(() {
                                      progress = isInProgress;
                                    });
                                  },
                                  loginFromServer: widget.loginForServer,
                                  tap: widget.type == ScreenType.forgot
                                      ? () async => {
                                            await _repository
                                                .updateForgotCredentialsInRemoteDB(
                                                    password, login)
                                          }
                                      : widget.type == ScreenType.auth
                                          ? () async => {
                                                await _repository.registerUser(
                                                    password,
                                                    login,
                                                    secondPassword)
                                              }
                                          : () async => {
                                                await _repository.authUser(
                                                    password, login)
                                              },
                                  label: widget.labelForButton,
                                  fontColor: Colors.white,
                                  background: blueColor,
                                  borderColor: Color(0xFFF1a7a8c),
                                  child: widget.child,
                                  isIconNeed: true,
                                  begin: 10.0,
                                  end: 255.0,
                                  milliseconds: 600,
                                )
                              ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}

enum ScreenType { login, forgot, auth }
