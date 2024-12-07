import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/city_model.dart';

class GeocodingService {
  static const String _baseUrl = 'https://geocoding-api.open-meteo.com/v1/';

  static Future<List<City>> fetchCitySuggestions(String query) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/search?name=$query'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['results'] as List)
          .map<City>((json) => City.fromJson(json))
          .take(5)
          .toList();
    } else {
      throw Exception('Failed to load city suggestions');
    }
  }

  static Future<City> getCoordinates(String cityName) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/search?name=$cityName'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return City.fromJson(data['results'][0]);
    } else {
      throw Exception('Failed to load city coordinates');
    }
  }
}
