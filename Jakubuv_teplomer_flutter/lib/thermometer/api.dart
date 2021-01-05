import 'dart:async';
import 'dart:convert';
import 'package:Jakubuv_teplomer_flutter/thermometer/termometer.dart';
import 'package:http/http.dart' as http;

// Třída, ktera zprostředkuje komunikaci se serverem
class Api {
  Future<Thermometer> getData() async {
    // Získání dat
    Map<String, dynamic> data;

    try {
      var response = await http.get(
          Uri.encodeFull("http://109.183.224.100:2222/api"),
          headers: {"Accept": "application/json"});
      data = jsonDecode(response.body);
    } catch (e) {
      print("Error API");
      print(e);
    }

    // Vracíme data ve tvaru thermostatu
    return Thermometer(
        temperature: data["temperature"].toDouble(),
        humidity: data["humidity"].toDouble());
  }
}
