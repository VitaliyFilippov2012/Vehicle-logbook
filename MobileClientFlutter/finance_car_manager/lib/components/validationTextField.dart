import 'package:finance_car_manager/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:finance_car_manager/style/styles.dart';

class ValidationTextField extends StatefulWidget {
  final ValueChanged<String> onStringChanged;
  final String label;
  final String text;
  final String validationMessage;
  final RegExp regexExp;
  final Widget icon;
  final double procentWidth;
  final double paddingLeft;
  final double paddingRight;
  final double paddingTop;
  final double paddingBottom;
  final int maxLength;
  final bool multiline;
  final bool borderInside;
  final bool isEditable;
  bool Function(String) validator;
  final InputDecoration inputDecoration;

  ValidationTextField(
      {Key key,
      this.label,
      this.isEditable = true,
      this.text,
      this.validationMessage = "Please correct",
      this.regexExp,
      this.icon,
      this.borderInside = false,
      this.procentWidth = 1.0,
      this.paddingLeft = 10.0,
      this.paddingRight = 10.0,
      this.paddingTop = 20.0,
      this.paddingBottom = 12.0,
      this.maxLength,
      this.multiline = false,
      this.validator,
      this.inputDecoration,
      this.onStringChanged})
      : super(key: key);

  @override
  _ValidationTextFieldState createState() => _ValidationTextFieldState();
}

class _ValidationTextFieldState extends State<ValidationTextField> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width -
        (widget.paddingLeft + widget.paddingRight);
    return Padding(
      padding: EdgeInsets.fromLTRB(widget.paddingLeft, widget.paddingTop,
          widget.paddingRight, widget.paddingBottom),
      child: Container(
        width: screenWidth * widget.procentWidth,
        child: TextFormField(
          enabled: widget.isEditable,
          controller: new TextEditingController(text: widget.text ?? ""),
          autovalidate: true,
          autocorrect: true,
          maxLength: widget.maxLength,
          style: TextStyle(
              color: Color(0xFFF234253),
              fontWeight: FontWeight.bold,
              fontSize: 18),
          decoration: widget.inputDecoration != null
              ? widget.inputDecoration
              : InputDecoration(
                  errorStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: orangeColor),
                  contentPadding: EdgeInsets.all(0),
                  focusedBorder: widget.borderInside ? emailShareStyle : borderStyle,
                  enabledBorder: enabledBorderStyle,
                  labelText: widget.label,
                  suffixIcon: widget.icon,
                  labelStyle: TextStyle(
                      color: Color(0xFFF234253),
                      fontWeight: FontWeight.normal,
                      fontSize: 25),
                ),
          onSaved: (String value) {
            // This optional block of code can be used to run
            // code when the user saves the form.
          },
          onChanged: (str) {
            widget.onStringChanged(str);
          },
          validator: widget.validator != null
              ? (value) {
                  return widget.validator(value)
                      ? null
                      : widget.validationMessage;
                }
              : null,
          maxLines: widget.multiline ? 10 : 1,
          minLines: 1,
        ),
      ),
    );
  }
}
