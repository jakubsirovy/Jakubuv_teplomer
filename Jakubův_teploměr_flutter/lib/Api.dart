import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:json_api_fetch/termostat.dart';

/// Třída, kter8 zprostředkovává veškerou komunikaci se serverem
class Api {
  Future<Thermostat> getData() async {
    // Získání dat
    var response = await http.get(
        Uri.encodeFull("http://109.183.224.100:2222/api"),
        headers: {"Accept": "application/json"});
    Map<String, dynamic> data = jsonDecode(response.body);

    // Vracíme data ve tvaru thermostatu
    return Thermostat(
        temperature: data["temperature"].toDouble(),
        pressure: data["pressure"].toDouble());
  }
}
