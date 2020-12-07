import 'dart:convert';

import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter/material.dart';
import 'chartApi.dart';

class Chart extends StatefulWidget {
  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List<dynamic> _temp;
  Future getData() async {
    String data = await Api().getData();
    final List list = jsonDecode(data);
    setState(() {
      _temp = list
          .map((item) => double.parse(item["temperature"].toString()))
          .toList();
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final fromDate = DateTime.now().subtract(Duration(hours: 13));
    final toDate = DateTime.now();

    final date1 = toDate.subtract(Duration(hours: 0));
    final date2 = toDate.subtract(Duration(hours: 1));
    final date3 = toDate.subtract(Duration(hours: 2));
    final date4 = toDate.subtract(Duration(hours: 3));
    final date5 = toDate.subtract(Duration(hours: 4));
    final date6 = toDate.subtract(Duration(hours: 5));
    final date7 = toDate.subtract(Duration(hours: 6));
    final date8 = toDate.subtract(Duration(hours: 7));
    final date9 = toDate.subtract(Duration(hours: 8));
    final date10 = toDate.subtract(Duration(hours: 9));
    final date11 = toDate.subtract(Duration(hours: 10));
    final date12 = toDate.subtract(Duration(hours: 11));
    final date13 = toDate.subtract(Duration(hours: 12));

    return Scaffold(
        appBar: AppBar(
          title: Text("Historie teploty"),
        ),
        body: Center(
          child: _temp != null
              ? Container(
                  color: Colors.blue,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: BezierChart(
                    bezierChartScale: BezierChartScale.HOURLY,
                    fromDate: fromDate,
                    toDate: toDate,
                    selectedDate: toDate,
                    series: [
                      BezierLine(
                        label: "°C",
                        data: [
                          DataPoint<DateTime>(value: _temp[0], xAxis: date1),
                          DataPoint<DateTime>(value: _temp[1], xAxis: date2),
                          DataPoint<DateTime>(value: _temp[2], xAxis: date3),
                          DataPoint<DateTime>(value: _temp[3], xAxis: date4),
                          DataPoint<DateTime>(value: _temp[4], xAxis: date5),
                          DataPoint<DateTime>(value: _temp[5], xAxis: date6),
                          DataPoint<DateTime>(value: _temp[6], xAxis: date7),
                          DataPoint<DateTime>(value: _temp[7], xAxis: date8),
                          DataPoint<DateTime>(value: _temp[8], xAxis: date9),
                          DataPoint<DateTime>(value: _temp[9], xAxis: date10),
                          DataPoint<DateTime>(value: _temp[10], xAxis: date11),
                          DataPoint<DateTime>(value: _temp[11], xAxis: date12),
                          DataPoint<DateTime>(value: _temp[12], xAxis: date13),
                        ],
                      ),
                    ],
                    config: BezierChartConfig(
                      //startYAxisFromNonZeroValue: false,
                      verticalIndicatorStrokeWidth: 3.0,
                      verticalIndicatorColor: Colors.black26,
                      showVerticalIndicator: true,
                      verticalIndicatorFixedPosition: false,
                      bubbleIndicatorTitleStyle: TextStyle(
                        color: Colors.blue,
                      ),
                      bubbleIndicatorLabelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      displayYAxis: true,
                      stepsYAxis: 5,
                      backgroundColor: Colors.blue,
                      footerHeight: 35.0,
                    ),
                  ),
                )
              : CircularProgressIndicator(),
        ));
  }
}
