import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/city.dart';

class WeatherService {
  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  static Future<Map<String, dynamic>> fetchWeather(City city) async {
    final url = '$_baseUrl?latitude=${city.latitude}&longitude=${city.longitude}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch weather data');
    }
  }
}
