import 'package:finance_car_manager/components/buttonForGraph.dart';
import 'package:finance_car_manager/components/event_details/eventDetailsPage.dart';
import 'package:finance_car_manager/components/graph/circleGraphOutsideLabel.dart';
import 'package:finance_car_manager/components/graph/gridLineWithSelectDashPattern.dart';
import 'package:finance_car_manager/models/category.dart';
import 'package:finance_car_manager/screens/graphPageView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finance_car_manager/models/event.dart';
import 'package:finance_car_manager/style/styles.dart';

class EventDetailsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final event = Provider.of<Event>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
            child: Text(
              categories
                      .firstWhere((x) => x.categoryId == event.idTypeEvents)
                      ?.name ??
                  "Event",
              style: eventWhiteTitleTextStyle,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.14),
            child: Text(
              "On " + event.date.toString(),
              style: eventLocationTextStyle.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.18),
            child: Text(
              "Was wasted: " + event.costs.toString() + "\$",
              style: eventLocationTextStyle.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(screenWidth * 0.24, 0, 0, 0),
            child: Text(
              "Mileage at that time amounted to " + event.mileage.toString() + " km",
              style: eventLocationTextStyle.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          event.comment != null && event.comment.isNotEmpty ?
          Padding(
            padding: EdgeInsets.fromLTRB(screenWidth * 0.30, 0, 0, 0),
            child: Text(
              "Your comment: " + event.comment,
              style: eventLocationTextStyle.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ) : Container(),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(screenWidth * 0.42, 0, 0, 0),
            child: Text(
              "Costs for day in current month",
              style: eventLocationTextStyle.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Container(
                    height: 460,
                    child:
                      event.idTypeEvents == categories[2].categoryId
                          ? CircleGraphWithOutsideLabel(
                              isLabelNeed: false,
                              animate: true,
                              type: TypeCircleGraph.FuelCosts,
                              carId: event.idCar)
                          : event.idTypeEvents == categories[3].categoryId
                              ? CircleGraphWithOutsideLabel(
                                  isLabelNeed: false,
                                  animate: true,
                                  type: TypeCircleGraph.ServiceCosts,
                                  carId: event.idCar)
                              : CircleGraphWithOutsideLabel(
                                  isLabelNeed: false,
                                  animate: true,
                                  type: TypeCircleGraph.OtherCosts,
                                  carId: event.idCar)
                    ),
              )),
          ButtonGraph(
              children: <Widget>[
                Text(
                  'Go to graphics',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Icon(Icons.arrow_forward, color: Colors.white, size: 32)
              ],
              onClick: (inClick) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => GraphPageView(
                      prevChild: EventDetailsPage(event: event),
                      graphicsToShow: <Widget>[
                        if (event.idTypeEvents == categories[2].categoryId)
                          GridLineWithSelectDashPattern(
                              event.idCar, true, TypeGraph.FuelVolume),
                        if (event.idTypeEvents == categories[2].categoryId)
                          GridLineWithSelectDashPattern(
                              event.idCar, true, TypeGraph.FuelSumCostsForDay),
                        if (event.idTypeEvents == categories[2].categoryId)
                          GridLineWithSelectDashPattern(
                              event.idCar, true, TypeGraph.FuelCostsVolume),
                        if (event.idTypeEvents == categories[3].categoryId)
                          GridLineWithSelectDashPattern(
                              event.idCar, true, TypeGraph.ServiceCosts),
                        if (event.idTypeEvents == categories[4].categoryId)
                          GridLineWithSelectDashPattern(
                              event.idCar, true, TypeGraph.OtherCosts),
                        CircleGraphWithOutsideLabel(
                            animate: true,
                            type: TypeCircleGraph.ForAllType,
                            carId: event.idCar),
                        if (event.idTypeEvents == categories[2].categoryId)
                          CircleGraphWithOutsideLabel(
                              animate: true,
                              type: TypeCircleGraph.FuelCosts,
                              carId: event.idCar),
                        if (event.idTypeEvents == categories[3].categoryId)
                          CircleGraphWithOutsideLabel(
                              animate: true,
                              type: TypeCircleGraph.ServiceCosts,
                              carId: event.idCar),
                        if (event.idTypeEvents == categories[4].categoryId)
                          CircleGraphWithOutsideLabel(
                              animate: true,
                              type: TypeCircleGraph.OtherCosts,
                              carId: event.idCar),
                        GridLineWithSelectDashPattern(
                            event.idCar, true, TypeGraph.WhenExistsCosts),
                        GridLineWithSelectDashPattern(
                            event.idCar, true, TypeGraph.SumCostsByDay),
                      ],
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
