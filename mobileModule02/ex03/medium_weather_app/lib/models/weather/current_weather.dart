class CurrentWeather {
   String weatherDescription;
   double temperature;
   int weatherCode;
   double windSpeed;

  CurrentWeather({
    required this.weatherDescription,
    required this.temperature,
    required this.weatherCode,
    required this.windSpeed,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      weatherDescription: "Unknown",
      temperature: json['current_weather']['temperature'],
      weatherCode: json['current_weather']['weathercode'],
      windSpeed: json['current_weather']['windspeed'],
    );
  }
}