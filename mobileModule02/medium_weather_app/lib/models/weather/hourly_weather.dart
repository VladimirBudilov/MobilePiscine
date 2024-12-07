class HourlyWeather {
  final DateTime time;
  final double temperature;
  final String weatherDescription;
  final double windSpeed;

  HourlyWeather({
    required this.time,
    required this.temperature,
    required this.weatherDescription,
    required this.windSpeed,
  });
}
