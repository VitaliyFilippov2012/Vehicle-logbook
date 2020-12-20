import 'package:finance_car_manager/components/headerWidget.dart';
import 'package:finance_car_manager/screens/accountScreen.dart';
import 'package:finance_car_manager/screens/additional_screens/sett_aboutMe.dart';
import 'package:flutter/material.dart';

const double _kViewportFraction = 0.7;

class GraphPageView extends StatefulWidget {
  List<Widget> graphicsToShow;
  Widget prevChild;

  GraphPageView({Key key, this.graphicsToShow, this.prevChild}) : super(key: key);
  @override
  _GraphPageViewState createState() => _GraphPageViewState();
}

class _GraphPageViewState extends State<GraphPageView> {
  ValueNotifier<double> selectedIndex = ValueNotifier<double>(0.0);
  final PageController _backgroundPageController = PageController();
  final PageController _pageController =
      PageController(viewportFraction: _kViewportFraction);

  bool _handlePageNotification(ScrollNotification notification,
      PageController leader, PageController follower) {
    if (notification.depth == 0 && notification is ScrollUpdateNotification) {
      selectedIndex.value = leader.page;
      if (follower.page != leader.page) {
        follower.position
            .jumpToWithoutSettling(leader.position.pixels / _kViewportFraction);
      }
      setState(() {});
    }
    return false;
  }

  Iterable<Widget> _buildBackgroundPages() {
    final List<Widget> backgroundPages = <Widget>[];
    for (int index = 0; index < widget.graphicsToShow.length; index++) {
      backgroundPages.add( Container(
        color: Color(0xB07986CB),
        child: Opacity(
          opacity: 0.3,
          child: Image.asset(
            'assets/images/background.jpg',
            fit: BoxFit.cover,
          ),
        ),
      ));
    }
    return backgroundPages;
  }

  Iterable<Widget> _buildPages() {
    final List<Widget> pages = <Widget>[];
    double pictureHeight = MediaQuery.of(context).size.height * 0.7;
    double pictureWidth = MediaQuery.of(context).size.width * 0.95;
    for (int index = 0; index < widget.graphicsToShow.length; index++) {
      var alignment = Alignment.center.add(
          Alignment((selectedIndex.value - index) * _kViewportFraction, 0.0));
      var resizeFactor =
          (1 - (((selectedIndex.value - index).abs() * 0.5).clamp(0.0, 1.0)));
      pages.add(Container(
        alignment: alignment,
        child: Container(
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.white.withOpacity(0.5),
                offset: Offset(0.0, 6.0),
                blurRadius: 10.0,
              ),
            ],
          ),
          width: pictureWidth * resizeFactor,
          height: pictureHeight * resizeFactor,
          child: Hero(
            tag: "Graph" + index.toString(),
            child: widget.graphicsToShow[index],
          ),
        ),
      ));
    }
    return pages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView(
            reverse: true,
            controller: _backgroundPageController,
            children: _buildBackgroundPages(),
          ),
          NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              return _handlePageNotification(
                  notification, _pageController, _backgroundPageController);
            },
            child: PageView(
              controller: _pageController,
              children: _buildPages(),
            ),
          ),
          HeaderWidget(
            childToPushreplacement: SettingsAboutMe(),
            prevChild: widget.prevChild ?? AccountScreen(),
          ),
        ],
      ),
    );
  }
}
