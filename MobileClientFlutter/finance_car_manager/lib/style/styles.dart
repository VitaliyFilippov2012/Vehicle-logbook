import 'package:flutter/material.dart';

final TextStyle eventCardText = TextStyle(
    fontSize: 20.0,
    color: Colors.white,
    fontWeight: FontWeight.w500);

final TextStyle fadedTextStyle = TextStyle(
  fontSize: 16.0,
  fontWeight: FontWeight.bold,
  color: Color(0x99FFFFFF),
);

final TextStyle whiteHeadingTextStyle = TextStyle(
  fontSize: 28.0,
  fontWeight: FontWeight.bold,
  color: Color(0xFFFFFFFF),
);

final TextStyle categoryTextStyle = TextStyle(
  fontSize: 14.0,
  fontWeight: FontWeight.bold,
  color: Color(0xFFFFFFFF),
);

final TextStyle selectedCategoryTextStyle = categoryTextStyle.copyWith(
  color: Color(0xFF000000),
);

final TextStyle eventTitleTextStyle = TextStyle(
  fontSize: 24.0,
  fontWeight: FontWeight.bold,
  color: Color(0xFF000000),
);

final TextStyle eventWhiteTitleTextStyle = TextStyle(
  fontSize: 38.0,
  fontWeight: FontWeight.bold,
  color: Color(0xFFFFFFFF),
);

final TextStyle eventLocationTextStyle =
    TextStyle(fontSize: 20.0, color: Color(0xFF000000));

final TextStyle guestTextStyle = TextStyle(
  fontSize: 16.0,
  fontWeight: FontWeight.w800,
  color: Color(0xFF000000),
);

final TextStyle punchLine1TextStyle = TextStyle(
  fontSize: 28.0,
  fontWeight: FontWeight.w800,
  color: orangeColor,
);

final OutlineInputBorder loginBorderStyle = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 1.0), gapPadding: 4);

final OutlineInputBorder borderStyle = OutlineInputBorder(
    borderSide: BorderSide(color: blueColor, width: 2.0), gapPadding: 1);
  
final InputBorder emailShareStyle = UnderlineInputBorder(
    borderRadius: BorderRadius.circular(1),
    borderSide: BorderSide(color: blueColor, width: 2.0)
  );

final InputBorder errorBorderStyle = UnderlineInputBorder(
    borderRadius: BorderRadius.circular(1),
    borderSide: BorderSide(color: orangeColor, width: 3.0));

final InputBorder enabledBorderStyle = UnderlineInputBorder(
    borderRadius: BorderRadius.circular(1),
    borderSide: BorderSide(color: blueColor, width: 3.0));

final TextStyle punchLine2TextStyle =
    punchLine1TextStyle.copyWith(color: Color(0xFF000000));

final TextStyle labelStyle = TextStyle(
                      color: Color(0xFFF234253),
                      fontWeight: FontWeight.normal,
                      fontSize: 20);

final Color orangeColor = Color(0xfff16517);
final Color blueColor = Color(0xFFF1f94aa);
