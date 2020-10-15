/// Datový model
class Thermostat {
  double temperature;
  double pressure;

  Thermostat({this.temperature, this.pressure});

  // Takzvaně gettery
  String get temp => this.temperature.toStringAsFixed(1);
  String get psi => this.pressure.toStringAsFixed(0);
}
