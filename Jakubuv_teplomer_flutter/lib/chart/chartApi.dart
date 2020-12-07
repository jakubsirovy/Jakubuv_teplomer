import 'dart:async';
import 'package:http/http.dart' as http;

class Api {
  Future getData() async {
    var response = await http.get(
        Uri.encodeFull("http://109.183.224.100:2222/chart-api"),
        headers: {"Accept": "application/json"});
    String data = response.body;
    return data;
  }
}
