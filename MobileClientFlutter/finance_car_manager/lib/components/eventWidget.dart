import 'package:finance_car_manager/models/category.dart';
import 'package:finance_car_manager/models/event.dart';
import 'package:flutter/material.dart';
import 'package:finance_car_manager/utils/utils.dart';
import 'package:finance_car_manager/style/styles.dart';

class EventWidget extends StatelessWidget {
  final Event event;

  const EventWidget({Key key, this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                child: event?.photo != null ? Utility.imageFromBase64String(event.photo)
                                      : Image.asset(
                  event.getDefaultImagePathByType(),
                  fit: BoxFit.fitWidth,
                  color: Colors.grey,
                  colorBlendMode: BlendMode.darken,
                  height: 150,
                  width: 400,
                ),
              ),
            ),
            SafeArea(
              child: Column(children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 30,
                              ),
                              Text(
                                categories
                                        .firstWhere((x) =>
                                            x.categoryId == event.idTypeEvents)
                                        ?.name ??
                                    "Event",
                                style: eventCardText.copyWith(
                                    fontSize: 28, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 60,
                          ),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.event,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                event.date.toString(),
                                style: eventCardText.copyWith(
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 65,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                event.costs.toString(),
                                style: eventCardText.copyWith(
                                    fontWeight: FontWeight.w600),
                              ),
                              Icon(
                                Icons.attach_money,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                "ODO:" + event.mileage.toString() + " km.",
                                style: eventCardText.copyWith(
                                    fontStyle: FontStyle.italic),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                event.addressStation != null && event.addressStation.isNotEmpty ?
                Row(
                  children: <Widget>[
                    FittedBox(
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.location_on,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            event.addressStation,
                            style: eventCardText,
                          ),
                        ],
                      ),
                    ),
                  ],
                ) :
                Row(
                  children: <Widget>[
                    FittedBox(
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
