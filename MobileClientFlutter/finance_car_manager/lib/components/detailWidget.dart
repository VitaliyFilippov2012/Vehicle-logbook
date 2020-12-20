import 'package:finance_car_manager/components/validationTextField.dart';
import 'package:finance_car_manager/style/styles.dart';
import 'package:flutter/material.dart';

import 'package:finance_car_manager/models/details.dart';
import 'package:uuid/uuid.dart';

class DetailWidget extends StatefulWidget {
  final int number;
  Details detail;
  String type;
  String name;
  ValueChanged<Details> onDetailsChanged;
  DetailWidget({
    Key key,
    this.number,
    this.detail,
    this.onDetailsChanged,
  }) : super(key: key);

  @override
  _DetailWidgetState createState() => _DetailWidgetState();
}

class _DetailWidgetState extends State<DetailWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.detail == null) {
      widget.detail = new Details();
      widget.detail.detailsId = Uuid().v4().toString().toUpperCase();
    }
    bool Function(String) stringNotEmpty = (value) {
      return value?.isNotEmpty == true;
    };
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(children: <Widget>[
            ValidationTextField(
              text: widget.name ?? widget.detail?.name,
              onStringChanged: (changedStr) {
                widget.name = changedStr;
                widget.detail.name = changedStr;
                widget.onDetailsChanged(widget.detail);
              },
              label: "Name",
              procentWidth: 0.4,
              paddingTop: 0.0,
              paddingBottom: 0.0,
              paddingLeft: 20.0,
              validator: (value) {
                return (stringNotEmpty(value));
              },
            ),
            ValidationTextField(
              text: widget.type ?? widget.detail.type,
              onStringChanged: (changedStr) {
                widget.type = changedStr;
                widget.detail.type = changedStr;
                widget.onDetailsChanged(widget.detail);
              },
              label: "Type details",
              procentWidth: 0.45,
              paddingLeft: 5.0,
              paddingTop: 0.0,
              paddingBottom: 0.0,
              validator: (value) {
                return (stringNotEmpty(value));
              },
            ),
          ]),
          Divider(
            color: blueColor,
            endIndent: 20,
            indent: 20,
            thickness: 1.5,
          )
        ],
      ),
    );
  }
}
