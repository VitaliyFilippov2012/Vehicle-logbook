import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:finance_car_manager/style/styles.dart';

class DateTextField extends StatefulWidget {
  final ValueChanged<String> onDateTextChanged;
  final String label;
  final String date;
  final String validationMessage;
  final double procentWidth;
  final double paddingLeft;
  final double paddingRight;
  final double paddingTop;
  final double paddingBottom;
  bool Function(String) validator;

  DateTextField({
    Key key,
    this.onDateTextChanged,
    this.label,
    this.date,
    this.validationMessage = "Please correct",
    this.procentWidth = 1.0,
    this.paddingLeft = 10.0,
    this.paddingRight = 10.0,
    this.paddingTop = 20.0,
    this.paddingBottom = 12.0,
    this.validator,
  }) : super(key: key);

  @override
  _DateTextFieldState createState() => _DateTextFieldState();
}

class _DateTextFieldState extends State<DateTextField> {
  DateTime selectedDate = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd');
  TextEditingController _date = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _date.value = TextEditingValue(text: widget.date ?? formatter.format(selectedDate));
    double screenWidth = MediaQuery.of(context).size.width -
        (widget.paddingLeft + widget.paddingRight);
    return Padding(
      padding: EdgeInsets.fromLTRB(widget.paddingLeft, widget.paddingTop,
          widget.paddingRight, widget.paddingBottom),
      child: Container(
        width: screenWidth * widget.procentWidth,
        child: GestureDetector(
          onTap: () => _selectDate(context),
          child: Container(
            width: 200,
            height: 50,
            child: AbsorbPointer(
              child: TextFormField(
                autovalidate: true,
                autocorrect: true,
                controller: _date,
                style: TextStyle(
                    color: Color(0xFFF234253),
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(0),
                  focusedBorder: borderStyle,
                  enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(1),
                      borderSide: BorderSide(color: blueColor, width: 3.0)),
                  labelText: widget.label,
                  labelStyle: TextStyle(
                      color: Color(0xFFF234253),
                      fontWeight: FontWeight.normal,
                      fontSize: 25),
                  suffixIcon: Icon(
                    Icons.date_range,
                    color: blueColor,
                  ),
                ),
                onSaved: (String value) {
                  // This optional block of code can be used to run
                  // code when the user saves the form.
                },
                validator: widget.validator != null
                    ? (value) {
                        return widget.validator(value)
                            ? null
                            : widget.validationMessage;
                      }
                    : (value) {
                        return value?.isNotEmpty == true
                            ? null
                            : widget.validationMessage;
                      },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _date.value = TextEditingValue(text: formatter.format(picked));
        widget.onDateTextChanged(formatter.format(picked));
      });
  }
}