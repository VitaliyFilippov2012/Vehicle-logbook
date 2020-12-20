import 'package:charts_flutter/flutter.dart' as charts;
import 'package:finance_car_manager/db_context/graphRepository.dart';
import 'package:finance_car_manager/models/graphInfo.dart';
import 'package:flutter/material.dart';

class GridLineWithSelectDashPattern extends StatefulWidget {
  final TypeGraph type;
  final String carId;
  final bool animate;

  GridLineWithSelectDashPattern(this.carId, this.animate, this.type);

  @override
  State<StatefulWidget> createState() => _SelectionCallbackState();
}

class _SelectionCallbackState extends State<GridLineWithSelectDashPattern> {
  DateTime _time;
  String _value;

  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;
    DateTime time;
    String value;

    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum.day;
      value = selectedDatum.first.datum.value.toString();
    }

    setState(() {
      _time = time;
      _value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.6;
    var style = TextStyle(
        color: Colors.black, fontSize: 15, fontWeight: FontWeight.w400);
    var labelStyle = TextStyle(
        color: Colors.black, fontSize: 19, fontWeight: FontWeight.bold);
    return Container(
      child: FutureBuilder<List<GraphInfo>>(
          future: _getGraphData(widget.type),
          builder: (context, AsyncSnapshot<List<GraphInfo>> snapshot) {
            if (snapshot.hasError || snapshot.data == null) {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(children: <Widget>[]),
              );
            } else {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Text(
                          _getLabel(),
                          style: labelStyle,
                          textAlign: TextAlign.center,
                        )),
                    SizedBox(
                        height: height,
                        child: new charts.TimeSeriesChart(
                          createGraphWithData(snapshot.data),
                          animate: widget.animate,
                          selectionModels: [
                            new charts.SelectionModelConfig(
                              type: charts.SelectionModelType.info,
                              changedListener: _onSelectionChanged,
                            )
                          ],
                        )),
                    _time != null
                        ? Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: Text(
                                "On " + _time.toString().substring(0, 11),
                                style: style))
                        : Container(),
                    _value == null
                        ? Container()
                        : Text('$_value ' + _getPrefix(), style: style),
                  ],
                ),
              );
            }
          }),
    );
  }

  List<charts.Series<GraphInfo, DateTime>> createGraphWithData(
      List<GraphInfo> data) {
    return [
      new charts.Series<GraphInfo, DateTime>(
        id: 'graph',
        domainFn: (GraphInfo graph, _) => graph.day,
        measureFn: (GraphInfo graph, _) => graph.value,
        data: data,
      ),
    ];
  }

  Future<List<GraphInfo>> _getMileagesForDay(String carId) async {
    var rep = new GraphRepository();
    return await rep.getMileagesForEveryDayByCarId(carId);
  }

  Future<List<GraphInfo>> _getSumPouredVolumeForDay(String carId) async {
    var rep = new GraphRepository();
    return await rep.getSumPouredVolumeForDayByCarId(carId);
  }

  Future<List<GraphInfo>> _getCostsFuelVolumeByCarId(String carId) async {
    var rep = new GraphRepository();
    return await rep.getCostsFuelVolumeForDayByCarId(carId);
  }

  Future<List<GraphInfo>> _getTotalMileages(String carId) async {
    var rep = new GraphRepository();
    var graphInfo = await rep.getMileagesForEveryDayByCarId(carId);
    return graphInfo.where((x) => x.value != 0.0).toList();
  }

  Future<List<GraphInfo>> _getSumCostsForDay(String carId) async {
    var rep = new GraphRepository();
    return await rep.getCostsForEveryDayByCarId(carId);
  }

  Future<List<GraphInfo>> _getSumCostsByTypeByCarId(
      String carId, String name) async {
    var rep = new GraphRepository();
    var circleGraphInfo = await rep.getCostsByTypeByCarId(carId);
    var graphInfo = new List<GraphInfo>();
    for (var e in circleGraphInfo.where((x) => x.name == name).toList()) {
      graphInfo.add(new GraphInfo(carId: e.carId, value: e.value, day: e.day));
    }
    return graphInfo;
  }

  Future<List<GraphInfo>> _getWhenExistSumCostsForDay(String carId) async {
    var rep = new GraphRepository();
    var graphInfo = await rep.getCostsForEveryDayByCarId(carId);
    return graphInfo.where((x) => x.value != 0.0).toList();
  }

  String _getLabel() {
    var month = " in current month";
    switch (widget.type) {
      case TypeGraph.DailyMileage:
        return "Mileage for every day" + month;
      case TypeGraph.TotalMileage:
        return "Total mileage";

      case TypeGraph.SumCostsByDay:
        return "Costs for every day" + month;
      case TypeGraph.WhenExistsCosts:
        return "Costs " + month;

      case TypeGraph.FuelCostsVolume:
        return "The average cost of a liter of fuel" + month;
      case TypeGraph.FuelVolume:
        return "Fuel poured" + month;
      case TypeGraph.FuelSumCostsForDay:
        return "Spent on fuel" + month;

      case TypeGraph.ServiceCosts:
        return "Spent on service" + month;
      case TypeGraph.OtherCosts:
        return "Other spent" + month;
    }
  }

  String _getPrefix() {
    if (widget.type == TypeGraph.DailyMileage ||
        widget.type == TypeGraph.TotalMileage) return 'km';
    if (widget.type == TypeGraph.FuelVolume) return 'l';
    return "\$";
  }

  Future<List<GraphInfo>> _getGraphData(TypeGraph type) {
    switch (type) {
      case TypeGraph.DailyMileage:
        return _getMileagesForDay(widget.carId);
      case TypeGraph.TotalMileage:
        return _getTotalMileages(widget.carId);

      case TypeGraph.SumCostsByDay:
        return _getSumCostsForDay(widget.carId);
      case TypeGraph.WhenExistsCosts:
        return _getWhenExistSumCostsForDay(widget.carId);

      case TypeGraph.FuelCostsVolume:
        return _getCostsFuelVolumeByCarId(widget.carId);
      case TypeGraph.FuelVolume:
        return _getSumPouredVolumeForDay(widget.carId);
      case TypeGraph.FuelSumCostsForDay:
        return _getSumCostsByTypeByCarId(widget.carId, 'Fuel');

      case TypeGraph.ServiceCosts:
        return _getSumCostsByTypeByCarId(widget.carId, 'Service');
      case TypeGraph.OtherCosts:
        return _getSumCostsByTypeByCarId(widget.carId, 'Other');
    }
  }
}

enum TypeGraph {
  DailyMileage,
  TotalMileage,
  SumCostsByDay,
  WhenExistsCosts,
  FuelVolume,
  FuelCostsVolume,
  FuelSumCostsForDay,
  ServiceCosts,
  OtherCosts,
}
