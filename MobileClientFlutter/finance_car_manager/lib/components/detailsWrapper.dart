import 'package:flutter/material.dart';
import 'package:finance_car_manager/components/detailWidget.dart';
import 'package:finance_car_manager/models/details.dart';
import 'package:finance_car_manager/style/styles.dart';

class DetailsWrapper extends StatefulWidget {
  final bool isSaved;
  ValueChanged<List<Details>> onChagedListDetails;
  DetailsWrapper(
      {Key key, this.details, this.onChagedListDetails, this.isSaved})
      : super(key: key);

  List<Details> details = new List<Details>();

  @override
  _DetailsWrapperState createState() => _DetailsWrapperState();
}

class _DetailsWrapperState extends State<DetailsWrapper> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width - (20 + 10);
    if (widget.details == null) widget.details = new List<Details>();
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 10, 5, 10),
      width: screenWidth,
      decoration: BoxDecoration(
          border: Border.all(color: blueColor),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(14))),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            widget.details.length == 0
                ? Text(
                    "Add detals",
                    style: labelStyle,
                  )
                : Text(
                    "Detals",
                    style: labelStyle,
                  ),
            Column(
              children: <Widget>[
                for (int i = 0; i < widget.details.length; i++)
                  GestureDetector(
                    child: DetailWidget(
                      detail: widget.details.elementAt(i),
                      onDetailsChanged: (updateDetail) {
                        widget.details.removeAt(i);
                        widget.details.insert(i, updateDetail);
                        widget.onChagedListDetails(widget.details);
                      },
                      number: i,
                    ),
                  ),
              ],
            ),
            widget.isSaved
                ? Container()
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      ButtonTheme(
                        child: RaisedButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(16.0),
                              side: BorderSide(color: blueColor)),
                          color: blueColor,
                          disabledColor: Colors.grey,
                          disabledTextColor: Colors.black,
                          padding: EdgeInsets.symmetric(vertical: 7),
                          onPressed: () {
                            setState(() {
                              widget.details.add(new Details());
                              widget.onChagedListDetails(widget.details);
                            });
                          },
                          child: Icon(
                            Icons.add,
                            color: Color(0x99FFFFFF),
                            size: 30,
                          ),
                        ),
                      ),
                      ButtonTheme(
                        child: RaisedButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(16.0),
                              side: BorderSide(color: blueColor)),
                          color: blueColor,
                          disabledColor: Colors.grey,
                          disabledTextColor: Colors.black,
                          padding: EdgeInsets.symmetric(vertical: 7),
                          child: Icon(
                            Icons.clear,
                            color: Color(0x99FFFFFF),
                            size: 30,
                          ),
                          onPressed: () {
                            setState(() {
                              widget.details.removeLast();
                              widget.onChagedListDetails(widget.details);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
          ]),
    );
  }
}
