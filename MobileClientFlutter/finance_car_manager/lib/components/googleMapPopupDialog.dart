import 'dart:async';

import 'package:finance_car_manager/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class GoogleMapPopupDialog extends StatefulWidget {
  final String label;
  final String validationMessage;
  final double procentWidth;
  final double paddingLeft;
  final double paddingRight;
  final double paddingTop;
  final double paddingBottom;
  bool Function(String) validator;

  GoogleMapPopupDialog({
    Key key,
    this.label,
    this.validationMessage,
    this.procentWidth = 1.0,
    this.paddingLeft = 10.0,
    this.paddingRight = 10.0,
    this.paddingTop = 20.0,
    this.paddingBottom = 12.0,
    this.validator,
  }) : super(key: key);
  @override
  _GoogleMapPopupDialogState createState() => _GoogleMapPopupDialogState();
}

class _GoogleMapPopupDialogState extends State<GoogleMapPopupDialog> {
  TextEditingController _addr = new TextEditingController();
  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width -
        (widget.paddingLeft + widget.paddingRight);
    return Padding(
      padding: EdgeInsets.fromLTRB(widget.paddingLeft, widget.paddingTop,
          widget.paddingRight, widget.paddingBottom),
      child: Container(
        width: screenWidth * widget.procentWidth,
        child: GestureDetector(
          onTap: () => _onAlertWithCustomContentPressed(context),
          child: Container(
            width: 200,
            height: 50,
            child: AbsorbPointer(
              child: TextFormField(
                autocorrect: true,
                controller: _addr,
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
                    Icons.map,
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

  _onAlertWithCustomContentPressed(context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Alert(
        context: context,
        title: "Address",
        content: Container(
          width: screenWidth * 0.95,
          height: screenHeight * 0.65,
          child: Scaffold(
            body: GoogleMap(
              mapType: MapType.satellite,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
            ),
          ),
        ),
        buttons: [
          DialogButton(
            radius: BorderRadius.all(Radius.circular(14)),
            color: blueColor,
            width: screenWidth * 0.25,
            onPressed: () => Navigator.pop(context),
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }
}
