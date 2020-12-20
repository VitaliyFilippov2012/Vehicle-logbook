import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final Color background;
  final Color borderColor;
  final Color fontColor;
  final Widget child;

  CustomButton({
    Key key,
    this.label,
    this.background,
    this.borderColor,
    this.fontColor,
    this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.pushReplacement(context, PageTransition(
          type: PageTransitionType.fade,
          child: child
        ));
      },
      child: Container(
        height: 63,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: borderColor,
            width: 1
          )
        ),
        child: Text(label,style: TextStyle(
          color: fontColor,
          fontSize: 20,
          fontWeight: FontWeight.bold
        )),
      ),
    );
  }
}
