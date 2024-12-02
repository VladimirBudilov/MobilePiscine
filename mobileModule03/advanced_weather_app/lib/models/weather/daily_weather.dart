class DailyWeather {
  final DateTime date;
  final double temperatureMax;
  final double temperatureMin;
  final int weatherCode;
  final String weatherDescription;

  DailyWeather({
    required this.date,
    required this.temperatureMax,
    required this.temperatureMin,
    required this.weatherCode,
    required this.weatherDescription,
  });
}
