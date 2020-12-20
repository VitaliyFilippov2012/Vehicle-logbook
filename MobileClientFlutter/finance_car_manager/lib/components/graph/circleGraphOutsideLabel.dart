import 'package:charts_flutter/flutter.dart' as charts;
import 'package:finance_car_manager/db_context/graphRepository.dart';
import 'package:finance_car_manager/models/circleGraphInfo.dart';
import 'package:flutter/material.dart';

class CircleGraphWithOutsideLabel extends StatefulWidget {
  final TypeCircleGraph type;
  final String carId;
  final bool animate;
  bool isLabelNeed;

  CircleGraphWithOutsideLabel({this.animate, this.type, this.carId, this.isLabelNeed});

  @override
  _CircleGraphWithOutsideLabelState createState() =>
      _CircleGraphWithOutsideLabelState();
}

class _CircleGraphWithOutsideLabelState
    extends State<CircleGraphWithOutsideLabel> {
  @override
  Widget build(BuildContext context) {
    widget.isLabelNeed = widget.isLabelNeed ?? true;
    double height = MediaQuery.of(context).size.height * 0.6;
    var labelStyle = TextStyle(
        color: Colors.black, fontSize: 19, fontWeight: FontWeight.bold);
    return Container(
      child: FutureBuilder<List<CircleGraphInfo>>(
        future: _getGraphData(widget.type),
        builder: (context, AsyncSnapshot<List<CircleGraphInfo>> snapshot) {
          if (snapshot.hasError || snapshot.data == null) {
            return charts.PieChart(List<charts.Series>(),
                animate: widget.animate,
                defaultRenderer: new charts.ArcRendererConfig(
                    arcRendererDecorators: [
                      new charts.ArcLabelDecorator(
                          labelPosition: charts.ArcLabelPosition.outside)
                    ]));
          } else {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[
                  widget.isLabelNeed ? Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: Text(
                        _getLabel(),
                        style: labelStyle,
                        textAlign: TextAlign.center,
                      )) : Container(),
                  SizedBox(
                    height: height,
                    child: charts.PieChart(
                      _createGraphWithData(snapshot.data, widget.type),
                      animate: widget.animate,
                      defaultRenderer: new charts.ArcRendererConfig(
                        arcRendererDecorators: [
                          new charts.ArcLabelDecorator(
                            labelPosition: charts.ArcLabelPosition.auto,
                            insideLabelStyleSpec: charts.TextStyleSpec(
                                fontSize: 20, color: charts.Color.white),
                            outsideLabelStyleSpec: charts.TextStyleSpec(
                                fontSize: 16, fontWeight: "normal"),
                          )
                        ],
                      ),
                      behaviors: [
                        charts.DatumLegend(
                          position: charts.BehaviorPosition.bottom,
                          horizontalFirst: false,
                          cellPadding:
                              new EdgeInsets.only(right: 4.0, bottom: 4.0),
                          showMeasures: true,
                          legendDefaultMeasure:
                              charts.LegendDefaultMeasure.firstValue,
                          measureFormatter: (num value) {
                            return value == null
                                ? '-'
                                : '${value.toString()}\$';
                          },
                          entryTextStyle: charts.TextStyleSpec(
                              fontSize: 16, fontWeight: "normal"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  List<charts.Series<CircleGraphInfo, String>> _createGraphWithData(
      List<CircleGraphInfo> list, TypeCircleGraph type) {
    if (type == TypeCircleGraph.ForAllType) {
      return [
        new charts.Series<CircleGraphInfo, String>(
          id: 'graph',
          domainFn: (CircleGraphInfo data, _) => data.name + ":",
          measureFn: (CircleGraphInfo data, _) => data.value,
          data: list,
          labelAccessorFn: (CircleGraphInfo row, _) => '${row.name}',
        ),
      ];
    }
    if (type == TypeCircleGraph.FuelCosts) {
      return [
        new charts.Series<CircleGraphInfo, String>(
          id: 'graph',
          domainFn: (CircleGraphInfo data, _) =>
              data.day.toString().substring(0, 10) + ":",
          measureFn: (CircleGraphInfo data, _) => data.value,
          data: list,
          labelAccessorFn: (CircleGraphInfo row, _) => '${row.volume} l',
        ),
      ];
    }

    return [
      new charts.Series<CircleGraphInfo, String>(
        id: 'graph',
        domainFn: (CircleGraphInfo data, _) =>
            data.day.toString().substring(0, 10) + ":",
        measureFn: (CircleGraphInfo data, _) => data.value,
        data: list,
        labelAccessorFn: (CircleGraphInfo row, _) => '',
      ),
    ];
  }

  Future<List<CircleGraphInfo>> _getCostsByGroupTypeByCarId(
      String carId) async {
    var rep = new GraphRepository();
    return await rep.getCostsByGroupTypeByCarId(carId);
  }

  Future<List<CircleGraphInfo>> _getCostsByTypeByCarId(
      String carId, String name) async {
    var rep = new GraphRepository();
    var graph = await rep.getCostsByTypeByCarId(carId);
    return graph.where((x) => x.name == name).toList();
  }

  Future<List<CircleGraphInfo>> _getFuelCostsByCarId(String carId) async {
    var rep = new GraphRepository();
    return await rep.getFuelCostsByCarId(carId);
  }

  String _getLabel() {
    var month = " in current month";
    switch (widget.type) {
      case TypeCircleGraph.FuelCosts:
        return "Fuel costs for day" + month;
      case TypeCircleGraph.ServiceCosts:
        return "Service costs for day" + month;
      case TypeCircleGraph.OtherCosts:
        return "Other costs for day";
      case TypeCircleGraph.ForAllType:
        return "Costs by type" + month;
    }
  }

  GraphData _toGraphData(CircleGraphInfo info) {
    double sectorNum;
    if (widget.type == TypeCircleGraph.ForAllType) {
      sectorNum =
          info.name == 'Fuel' ? 1.0 : info.name == 'Service' ? 2.0 : 3.0;
    } else
      sectorNum = double.parse(info.day.day.toString());
    return new GraphData(sectorNum, info.value);
  }

  Future<List<CircleGraphInfo>> _getGraphData(TypeCircleGraph type) {
    switch (type) {
      case TypeCircleGraph.FuelCosts:
        return _getFuelCostsByCarId(widget.carId);
      case TypeCircleGraph.ServiceCosts:
        return _getCostsByTypeByCarId(widget.carId, 'Service');
      case TypeCircleGraph.OtherCosts:
        return _getCostsByTypeByCarId(widget.carId, 'Other');
      case TypeCircleGraph.ForAllType:
        return _getCostsByGroupTypeByCarId(widget.carId);
    }
  }
}

class GraphData {
  final double sectorNum;
  final double value;

  GraphData(this.sectorNum, this.value);
}

enum TypeCircleGraph {
  FuelCosts,
  ServiceCosts,
  OtherCosts,
  ForAllType,
}
