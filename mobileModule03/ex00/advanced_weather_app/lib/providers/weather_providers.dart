import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/weather_service.dart';
import '../models/weather/current_weather.dart';
import '../models/weather/hourly_weather.dart';
import '../models/weather/daily_weather.dart';
import 'location_providers.dart';
import 'network_status_provider.dart';

final currentWeatherProvider = FutureProvider<CurrentWeather>((ref) async {
  final selectedCity = ref.watch(selectedCityProvider);
  final isConnected = await ref.watch(internetStatusProvider.future);

  if (!isConnected) {
    throw Exception("No internet connection. Please check your internet.");
  }

  if (selectedCity != null) {
    return await WeatherService.getCurrentWeather(selectedCity);
  }

  throw Exception("Invalid city name. Please try something else.");
});

final todayWeatherProvider = FutureProvider<List<HourlyWeather>>((ref) async {
  final selectedCity = ref.watch(selectedCityProvider);
  final isConnected = await ref.watch(internetStatusProvider.future);

  if (!isConnected) {
    throw Exception("No internet connection. Please check your internet.");
  }

  if (selectedCity != null) {
    return await WeatherService.getTodayWeather(
        selectedCity.latitude, selectedCity.longitude);
  }

  throw Exception("Invalid city name. Please try something else.");
});

final weeklyWeatherProvider = FutureProvider<List<DailyWeather>>((ref) async {
  final selectedCity = ref.watch(selectedCityProvider);
  final isConnected = await ref.watch(internetStatusProvider.future);

  if (!isConnected) {
    throw Exception("No internet connection. Please check your internet.");
  }

  if (selectedCity != null) {
    return await WeatherService.getWeeklyWeather(
        selectedCity.latitude, selectedCity.longitude);
  }

  throw Exception("Invalid city name. Please try something else.");
});
