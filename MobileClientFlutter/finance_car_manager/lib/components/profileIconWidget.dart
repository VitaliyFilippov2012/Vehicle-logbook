import 'package:finance_car_manager/blocs/userInfoBloc.dart';
import 'package:finance_car_manager/models/UserInfo.dart';
import 'package:finance_car_manager/style/styles.dart';
import 'package:finance_car_manager/utils/utils.dart';
import 'package:flutter/material.dart';

class ProfileIconWidget extends StatefulWidget {
  Image image;
  final Color fontColor;

  ProfileIconWidget({Key key, this.image, this.fontColor}) : super(key: key);

  @override
  _ProfileIconWidgetState createState() => _ProfileIconWidgetState();
}

class _ProfileIconWidgetState extends State<ProfileIconWidget> {
  @override
  void initState() {
    super.initState();
    userInfoBloc.getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserInfo>(
        stream: userInfoBloc.userInfo,
        builder: (context, snapshot) {
          String name;
          String lastName;
          if (snapshot.hasData) {
            name = snapshot.data.name;
            lastName = snapshot.data.lastname;
            widget.image =
                Utility.imageFromBase64String(snapshot.data?.getPhoto);
          } else {
            name = "Your name";
            lastName = "Your lasname";
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(name,
                      style: TextStyle(
                          color: widget.fontColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  Text(lastName,
                      style: TextStyle(
                          color: widget.fontColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ],
              ),
              SizedBox(width: 10),
              Container(
                height: 50,
                width: 50,
                child: widget.image == null
                    ? Icon(
                        Icons.person_outline,
                        color: Color(0x99FFFFFF),
                        size: 50,
                      )
                    : Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: blueColor),
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.0),
                            ),
                            child: widget.image),
                      ),
              )
            ],
          );
        });
  }
}
