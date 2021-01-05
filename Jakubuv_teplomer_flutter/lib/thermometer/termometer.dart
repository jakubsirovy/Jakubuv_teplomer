// Datový model
class Thermometer {
  double temperature;
  double humidity;

  Thermometer({this.temperature, this.humidity});

  // Takzvaně gettery
  String get temp => this.temperature.toStringAsFixed(1);
  String get humi => this.humidity.toStringAsFixed(1);
}
