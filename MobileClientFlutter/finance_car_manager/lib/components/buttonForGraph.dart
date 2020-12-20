import 'package:flutter/material.dart';

import 'package:finance_car_manager/style/styles.dart';

class ButtonGraph extends StatelessWidget {
  ValueChanged<bool> onClick;
  List<Widget> children;

  ButtonGraph({
    Key key,
    this.onClick,
    this.children
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        ButtonTheme(
          minWidth: 150.0,
          height: 50.0,
          child: RaisedButton(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                  side: BorderSide(color: blueColor)),
              color: blueColor,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              padding: EdgeInsets.all(14.0),
              onPressed: () {
                onClick(true);
              },
              child: Row(
                children: children
              )),
        ),
      ],
    );
  }
}
