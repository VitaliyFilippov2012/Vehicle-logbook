import 'package:finance_car_manager/style/styles.dart';
import 'package:flutter/material.dart';

class DeleteUpdateButtons extends StatelessWidget {
  ValueChanged<bool> onDelete;
  ValueChanged<bool> onUpdate;

  DeleteUpdateButtons(
      {Key key,
      @required GlobalKey<FormState> formKey,
      this.onDelete,
      this.onUpdate})
      : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormState> _formKey;

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
              if (_formKey.currentState.validate()) {
                onUpdate(true);
              }
            },
            child: Text(
              'Update',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
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
              onDelete(true);
            },
            child: Text(
              'Delete',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
