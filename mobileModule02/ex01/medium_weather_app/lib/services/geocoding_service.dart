import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/city.dart';

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
      //will be shown that no connection to api
      throw Exception('Failed to load city suggestions');
    }
  }
}
