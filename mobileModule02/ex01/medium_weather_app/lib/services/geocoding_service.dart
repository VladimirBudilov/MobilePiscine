import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/city.dart';

class GeocodingService {
  static const String _baseUrl = 'https://api.open-meteo.com/geocoding';

  static Future<List<City>> fetchCitySuggestions(String query) async {
    final response = await http.get(Uri.parse('$_baseUrl/search?name=$query'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data.map<City>((item) => City.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load city suggestions');
    }
  }
}
