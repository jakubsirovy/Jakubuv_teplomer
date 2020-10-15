import 'dart:async';

import 'package:flutter/material.dart';
import 'package:json_api_fetch/Api.dart';
import 'package:json_api_fetch/termostat.dart';

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
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text("Teplota: ${_data.temp} °C"),
                ),
                Center(
                  child: Text("Tlak: ${_data.psi} hPa"),
                ),
              ],
            ),
    );
  }
}
