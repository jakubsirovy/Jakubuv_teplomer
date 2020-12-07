import 'dart:async';

import 'package:Jakubuv_teplomer_flutter/thermometer/api.dart';
import 'package:Jakubuv_teplomer_flutter/thermometer/termometer.dart';
import 'package:Jakubuv_teplomer_flutter/wave.dart';
import 'package:Jakubuv_teplomer_flutter/chart/chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future main() async {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: new HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  Thermometer _data;

  Future getData() async {
    Thermometer data = await Api().getData();
    setState(() {
      _data = data;
    });
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 5), (Timer t) {
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      appBar: AppBar(
        title: Text("Jakubův teploměr"),
      ),
      body: _data == null
          ? Center(child: CircularProgressIndicator())
          : Scaffold(
              body: Column(
                children: [
                  Container(
                    color: Colors.blue,
                    height: 252,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${_data.temp}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 72,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "\u2103",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 72,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ]),
                  ),
                  Align(
                      alignment: Alignment.bottomLeft,
                      child: CustomPaint(
                          painter: Wave(),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 50))),
                  Container(
                    height: 222,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${_data.psi}",
                            style: TextStyle(
                              color: Color.fromARGB(255, 200, 200, 200),
                              fontSize: 72,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "\u02b0\u1d3e\u1d43",
                            style: TextStyle(
                              color: Color.fromARGB(255, 200, 200, 200),
                              fontSize: 72,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ]),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Chart()));
                },
                label: Text('Graf'),
                icon: Icon(Icons.analytics_rounded),
                backgroundColor: Colors.blue,
              ),
            ),
    );
  }
}
