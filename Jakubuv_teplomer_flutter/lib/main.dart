import 'dart:async';

import 'package:Jakubuv_teplomer_flutter/Api.dart';
import 'package:Jakubuv_teplomer_flutter/termostat.dart';
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
                          painter: MyPainter(),
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

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    Path path = Path();

    // Path number

    paint.color = Color(0xff2196f3);
    path = Path();
    path.lineTo(0, 0);
    path.cubicTo(0, 0, size.width * 0.02, size.height * 0.11, size.width * 0.02,
        size.height * 0.11);
    path.cubicTo(size.width * 0.04, size.height * 0.23, size.width * 0.08,
        size.height * 0.45, size.width * 0.13, size.height * 0.64);
    path.cubicTo(size.width * 0.17, size.height * 0.83, size.width / 5,
        size.height * 0.98, size.width / 4, size.height);
    path.cubicTo(size.width * 0.29, size.height * 1.02, size.width / 3,
        size.height * 0.9, size.width * 0.38, size.height * 0.77);
    path.cubicTo(size.width * 0.42, size.height * 0.64, size.width * 0.46,
        size.height * 0.49, size.width / 2, size.height * 0.49);
    path.cubicTo(size.width * 0.54, size.height * 0.49, size.width * 0.58,
        size.height * 0.64, size.width * 0.63, size.height * 0.6);
    path.cubicTo(size.width * 0.67, size.height * 0.56, size.width * 0.71,
        size.height * 0.34, size.width * 0.75, size.height * 0.3);
    path.cubicTo(size.width * 0.79, size.height * 0.26, size.width * 0.83,
        size.height * 0.41, size.width * 0.88, size.height * 0.43);
    path.cubicTo(size.width * 0.92, size.height * 0.45, size.width * 0.96,
        size.height * 0.34, size.width * 0.98, size.height * 0.28);
    path.cubicTo(size.width * 0.98, size.height * 0.28, size.width,
        size.height * 0.23, size.width, size.height * 0.23);
    path.cubicTo(size.width, size.height * 0.23, size.width, 0, size.width, 0);
    path.cubicTo(size.width, 0, size.width * 0.98, 0, size.width * 0.98, 0);
    path.cubicTo(
        size.width * 0.96, 0, size.width * 0.92, 0, size.width * 0.88, 0);
    path.cubicTo(
        size.width * 0.83, 0, size.width * 0.79, 0, size.width * 0.75, 0);
    path.cubicTo(
        size.width * 0.71, 0, size.width * 0.67, 0, size.width * 0.63, 0);
    path.cubicTo(size.width * 0.58, 0, size.width * 0.54, 0, size.width / 2, 0);
    path.cubicTo(
        size.width * 0.46, 0, size.width * 0.42, 0, size.width * 0.38, 0);
    path.cubicTo(size.width / 3, 0, size.width * 0.29, 0, size.width / 4, 0);
    path.cubicTo(size.width / 5, 0, size.width * 0.17, 0, size.width * 0.13, 0);
    path.cubicTo(
        size.width * 0.08, 0, size.width * 0.04, 0, size.width * 0.02, 0);
    path.cubicTo(size.width * 0.02, 0, 0, 0, 0, 0);
    path.cubicTo(0, 0, 0, 0, 0, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
