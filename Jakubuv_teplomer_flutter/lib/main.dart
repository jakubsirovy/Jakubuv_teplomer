import 'dart:async';

import 'package:Jakubuv_teplomer_flutter/Api.dart';
import 'package:Jakubuv_teplomer_flutter/termostat.dart';
import 'package:Jakubuv_teplomer_flutter/wave.dart';
import 'package:flutter/material.dart';

Future main() async {
  runApp(new MaterialApp(
    home: new HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  Thermostat _data;

  Future getData() async {
    Thermostat data = await Api().getData();
    setState(() {
      _data = data;
    });
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kubovo počasí"),
      ),
      body: _data == null
          ? Center(child: CircularProgressIndicator())
          : Scaffold(
              body: Column(
                children: [
                  Container(
                    color: Colors.blue,
                    height: 262,
                    child: Center(
                      child: Text(
                        "${_data.temp} °C",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 72,
                        ),
                      ),
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomLeft,
                      child: CustomPaint(
                          painter: Wave(),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 50))),
                  Container(
                    height: 212,
                    child: Center(
                      child: Text(
                        "${_data.psi} hPa",
                        style: TextStyle(
                          color: Color.fromARGB(255, 200, 200, 200),
                          fontSize: 72,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
