/// Datový model
class Thermometer {
  double temperature;
  double pressure;

  Thermometer({this.temperature, this.pressure});

  // Takzvaně gettery
  String get temp => this.temperature.toStringAsFixed(1);
  String get psi => this.pressure.toStringAsFixed(0);
}
