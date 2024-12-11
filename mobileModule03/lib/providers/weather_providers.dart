import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/weather_service.dart';
import '../models/weather/current_weather.dart';
import '../models/weather/hourly_weather.dart';
import '../models/weather/daily_weather.dart';
import 'location_providers.dart';

final currentWeatherProvider = FutureProvider<CurrentWeather?>((ref) async {
  final selectedCity = ref.watch(selectedCityProvider);

  if (selectedCity != null) {
    return await WeatherService.getCurrentWeather(selectedCity);
  }
  return null;
});

final todayWeatherProvider = FutureProvider<List<HourlyWeather>>((ref) async {
  final selectedCity = ref.watch(selectedCityProvider);

  if (selectedCity != null) {
    return await WeatherService.getTodayWeather(
        selectedCity.latitude, selectedCity.longitude);
  }
  return [];
});

final weeklyWeatherProvider = FutureProvider<List<DailyWeather>>((ref) async {
  final selectedCity = ref.watch(selectedCityProvider);

  if (selectedCity != null) {
    return await WeatherService.getWeeklyWeather(
        selectedCity.latitude, selectedCity.longitude);
  }
  return [];
});
