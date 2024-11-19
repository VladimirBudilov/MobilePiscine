import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather/current_weather.dart';
import '../models/weather/hourly_weather.dart';
import '../models/weather/daily_weather.dart';
import '../models/city_model.dart';
import '../utils/weather_codes.dart';

class WeatherService {
  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  static Future<CurrentWeather> getCurrentWeather(City city) async {
    http.Response response;
    try {
      response = await http.get(Uri.parse(
          '$_baseUrl/?latitude=${city.latitude}&longitude=${city.longitude}&daily=weathercode,temperature_2m_max,temperature_2m_min&timezone=GMT&current_weather=true'));
    } catch (e) {
      throw Exception('please check your internet connection.');
    }
    if (response.statusCode == 200) {
      var currentWeather = CurrentWeather.fromJson(json.decode(response.body));
      currentWeather.weatherDescription =
          weatherDescriptions[currentWeather.weatherCode] ?? 'Unknown';
      return currentWeather;
    } else if (response.statusCode >= 400 && response.statusCode <= 500) {
      throw Exception(
          'Invalid request. Check city name or try a different location.');
    } else {
      throw Exception(
          'The API server is temporarily unavailable. Please try again later.');
    }
  }

  static Future<List<HourlyWeather>> getTodayWeather(
      double lat, double lon) async {
    http.Response response;
    try {
      response = await http.get(Uri.parse(
          '$_baseUrl/?latitude=$lat&longitude=$lon&hourly=temperature_2m,weathercode,windspeed_10m&timezone=GMT'));
    } catch (e) {
      throw Exception('please check your internet connection.');
    }
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final hourly = data['hourly'];
      final times = List<String>.from(hourly['time']);
      final temperatures = List<double>.from(hourly['temperature_2m']);
      final windSpeed = List<double>.from(hourly['windspeed_10m']);
      final weatherCodes = List<int>.from(hourly['weathercode']);

      final hourlyWeatherdData = List.generate(times.length, (index) {
        return HourlyWeather(
          time: DateTime.parse(times[index]),
          temperature: temperatures[index],
          weatherDescription:
              weatherDescriptions[weatherCodes[index]] ?? 'Unknown',
          windSpeed: windSpeed[index],
        );
      });

      return hourlyWeatherdData;
    } else if (response.statusCode >= 400 && response.statusCode <= 500) {
      throw Exception(
          'Invalid request. Check city name or try a different location.');
    } else {
      throw Exception(
          'The API server is temporarily unavailable. Please try again later.');
    }
  }

  static Future<List<DailyWeather>> getWeeklyWeather(
      double lat, double lon) async {
    http.Response response;
    try {
      response = await http.get(Uri.parse(
        '$_baseUrl?latitude=$lat&longitude=$lon&daily=weathercode,temperature_2m_max,temperature_2m_min&timezone=GMT',
      ));
    } catch (e) {
      throw Exception(
          'An unknown error occurred. please check your internet connection.');
    }
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final daily = data['daily'];

      final times = List<String>.from(daily['time']);
      final temperatureMax = List<double>.from(daily['temperature_2m_max']);
      final temperatureMin = List<double>.from(daily['temperature_2m_min']);
      final weatherCodes = List<int>.from(daily['weathercode']);

      return List.generate(times.length, (index) {
        return DailyWeather(
          date: DateTime.parse(times[index]),
          temperatureMax: temperatureMax[index],
          temperatureMin: temperatureMin[index],
          weatherDescription:
              weatherDescriptions[weatherCodes[index]] ?? 'Unknown',
        );
      });
    } else if (response.statusCode >= 400 && response.statusCode <= 500) {
      throw Exception(
          'Invalid request. Check city name or try a different location.');
    } else {
      throw Exception(
          'The API server is temporarily unavailable. Please try again later.');
    }
  }
}
