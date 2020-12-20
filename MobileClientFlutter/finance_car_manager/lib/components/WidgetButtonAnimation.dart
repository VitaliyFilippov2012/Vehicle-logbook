import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class WidgetButtonAnimation extends StatefulWidget {
  final Widget widget;
  final Color background;
  final Color borderColor;
  final Widget child;
  final double begin;
  final double end;
  final int milliseconds;

  const WidgetButtonAnimation(
      {Key key,
      this.widget,
      this.background,
      this.borderColor,
      this.child,
      this.begin,
      this.end,
      this.milliseconds})
      : super(key: key);

  @override
  _WidgetButtonAnimationState createState() => _WidgetButtonAnimationState();
}

class _WidgetButtonAnimationState extends State<WidgetButtonAnimation>
    with TickerProviderStateMixin {
  AnimationController _scaleController;
  Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

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
      onTap: () {
        _scaleController.forward();
      },
      child: Stack(
          children: <Widget>[
            widget.widget,
            AnimatedBuilder(
              animation: _scaleController,
              builder: (context, build) => Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      color: widget.background,
                      borderRadius: BorderRadius.circular(25),
                    ),
                  )
                ),
            ),
          ],
        ),
    );
  }
}
