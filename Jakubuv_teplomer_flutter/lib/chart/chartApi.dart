import 'dart:async';
import 'package:http/http.dart' as http;

class Api {
  Future getData() async {
    String data;
    try {
      var response = await http.get(
          Uri.encodeFull("http://109.183.224.100:2222/chart-api"),
          headers: {"Accept": "application/json"});
      data = response.body;
    } catch (e) {
      print("Error ChartAPI");
      print(e);
    }
    return data;
  }
}
