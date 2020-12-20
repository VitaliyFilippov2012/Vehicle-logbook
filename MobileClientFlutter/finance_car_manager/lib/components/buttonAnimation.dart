import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class ButtonAnimation extends StatefulWidget {
  final ValueChanged<bool> onProgress;
  final TapCallback tap;
  final bool loginFromServer;
  final String label;
  final Color background;
  final Color borderColor;
  final Color fontColor;
  final Function onTap;
  final Widget child;
  final double begin;
  final double end;
  final int milliseconds;
  final bool isIconNeed;

  const ButtonAnimation(
      {Key key,
      this.label,
      this.tap,
      this.background,
      this.borderColor,
      this.fontColor,
      this.onTap,
      this.isIconNeed,
      this.child,
      this.begin,
      this.onProgress,
      this.end,
      this.milliseconds,
      this.loginFromServer = false})
      : super(key: key);

  @override
  _ButtonAnimationState createState() => _ButtonAnimationState();
}

class _ButtonAnimationState extends State<ButtonAnimation>
    with TickerProviderStateMixin {
  AnimationController _positionController;
  Animation<double> _positionAnimation;

  AnimationController _scaleController;
  Animation<double> _scaleAnimation;

  bool _isLogin = false;
  bool _isIconHide = false;
  bool inProgress = false;
  @override
  void initState() {
    super.initState();

    _positionController = AnimationController(
        vsync: this, duration: Duration(milliseconds: widget.milliseconds));

    _positionAnimation = Tween<double>(begin: widget.begin, end: widget.end)
        .animate(_positionController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                _isIconHide = true;
              });
              _scaleController.forward();
            }
          });

    _scaleController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 32).animate(_scaleController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              Navigator.pushReplacement(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: widget.child,
                ),
              );
            }
          });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (!inProgress) {
          inProgress = true;
          widget.onProgress(true);
          if (widget.loginFromServer) {
            var result = await widget.tap();
            if ((result as LinkedHashSet<bool>).first != true) {
              widget.onProgress(false);
              inProgress = false;
              return;
            }
          }
          setState(() {
            _isLogin = true;
          });
          widget.onProgress(false);
          _positionController.forward();
          inProgress = false;
        }
      },
      child: Container(
        height: 63,
        width: double.infinity,
        decoration: BoxDecoration(
          color: widget.background,
          borderRadius: BorderRadius.circular(14),
        ),
        child: !_isLogin
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(widget.label,
                      style: TextStyle(
                          color: widget.fontColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  SizedBox(width: 10),
                  widget.isIconNeed
                      ? Icon(Icons.arrow_forward,
                          color: widget.fontColor, size: 32)
                      : Container(),
                ],
              )
            : Stack(
                children: <Widget>[
                  AnimatedBuilder(
                    animation: _positionController,
                    builder: (context, child) => Positioned(
                      left: _positionAnimation.value,
                      top: 5,
                      child: AnimatedBuilder(
                        animation: _scaleController,
                        builder: (context, build) => Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: widget.background,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: widget.borderColor,
                                  width: 1,
                                ),
                              ),
                              child: !_isIconHide && widget.isIconNeed
                                  ? Icon(Icons.arrow_forward,
                                      color: widget.fontColor, size: 32)
                                  : Container(),
                            )),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}

typedef TapCallback<bool> = dynamic Function();
