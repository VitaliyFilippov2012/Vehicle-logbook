import 'package:finance_car_manager/blocs/carsBloc.dart';
import 'package:finance_car_manager/models/car.dart';
import 'package:flutter/material.dart';

class CarWidget extends StatefulWidget {
  final Car car;

  const CarWidget({Key key, this.car}) : super(key: key);

  @override
  _CarWidgetState createState() => _CarWidgetState();
}

class _CarWidgetState extends State<CarWidget> {
  Widget carItemIcon(IconData iconData, String text) {
    return Row(
      children: <Widget>[
        Icon(iconData, color: Colors.white),
        SizedBox(width: 2),
        Text(text, style: TextStyle(color: Colors.white))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    carsBloc.getSelectedCarOrSetIfNotExistsInShared();
    return Container(
      margin: EdgeInsets.only(right: 20),
      width: 220,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Color(0xFFF082938)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              width: 220,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      image: AssetImage('assets/images/img1.jpg'),
                      fit: BoxFit.cover)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => carsBloc.setSelectedCar(widget.car.carId),
                    child: Container(
                        alignment: Alignment.topRight,
                        child: StreamBuilder<Car>(
                            stream: carsBloc.selectedCar,
                            builder: (context, AsyncSnapshot<Car> snapshot) {
                              return snapshot.data?.carId == widget.car.carId ?
                              Icon(Icons.check_circle,
                                  color: Color(0xFFF1f94aa),
                                  size: 50) : Icon(Icons.check_circle_outline,
                                  color: Colors.white,
                                  size: 50);
                            })),
                  ),
                  SizedBox(height: 148),
                  Text(widget.car.getMark + " " + widget.car.getModel,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text(widget.car.getTypeFuel,
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            height: 59,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Main characteristics",
                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text("Year issue: " + widget.car.yearIssue.toString(), style: TextStyle(color: Colors.white, fontSize: 15)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.car.typeTransmission, style: TextStyle(color: Colors.white, fontSize: 15)),
                    SizedBox(width: 7),
                    Text(widget.car.volumeEngine.toString() + "sm³", style: TextStyle(color: Colors.white, fontSize: 15)),
                    SizedBox(width: 7),
                    Text(widget.car.power.toString() + "hp", style: TextStyle(color: Colors.white, fontSize: 15)),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
