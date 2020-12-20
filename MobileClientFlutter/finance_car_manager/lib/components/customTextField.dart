import 'package:finance_car_manager/style/styles.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final ValueChanged<String> onStringChanged;
  final String label;
  final Widget icon;
  final bool isPassword;
  final InputDecoration inputDecoration;
  final String text;

  const CustomTextField({
    Key key,
    this.onStringChanged,
    this.label,
    this.icon,
    this.text,
    this.isPassword,
    this.inputDecoration,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: new TextEditingController(text: widget.text ?? ""),
      onChanged: (str) {
        widget.onStringChanged(str);
      },
      style: TextStyle(color: Color(0xFFF234253), fontWeight: FontWeight.bold),
      obscureText: widget.isPassword ?? false,
      decoration: widget.inputDecoration != null
          ? widget.inputDecoration
          : InputDecoration(
              focusedBorder: loginBorderStyle,
              enabledBorder: loginBorderStyle,
              labelText: widget.label,
              labelStyle: TextStyle(
                  color: Color(0xFFF234253), fontWeight: FontWeight.bold),
            ),
    );
  }
}
