import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/city_model.dart';

class GeocodingService {
  static const String _baseUrl = 'https://geocoding-api.open-meteo.com/v1/';

  static Future<List<City>> fetchCitySuggestions(String query) async {
    http.Response response;
    try {
      response = await http.get(
        Uri.parse('$_baseUrl/search?name=$query'),
      );
    } catch (e) {
      throw Exception('please check your internet connection.');
    }

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['results'] != null && data['results'] is List) {
        return (data['results'] as List)
            .map<City>((json) => City.fromJson(json))
            .take(5)
            .toList();
      } else {
        return [];
      }
    } else if (response.statusCode >= 400 && response.statusCode <= 500) {
      throw Exception(
          'Invalid request. Check your query or try a different location.');
    } else {
      throw Exception(
          'The API is temporarily unavailable. Please try again later.');
    }
  }

  static Future<City?> getCoordinates(String cityName) async {
    http.Response response;
    try {
      response = await http.get(
        Uri.parse('$_baseUrl/search?name=$cityName'),
      );
    } catch (e) {
      throw Exception('please check your internet connection.');
    }

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['results'] == null) {
        return null;
      }
      final List<dynamic> results = data['results'];
      for (var cityData in results) {
        final city = City.fromJson(cityData);
        if (city.name.toLowerCase() == cityName.toLowerCase()) {
          return city;
        }
      }
      return null;
    } else if (response.statusCode >= 400 && response.statusCode <= 500) {
      throw Exception('Invalid request. Check the city name or try again.');
    } else {
      throw Exception(
          'The API is temporarily unavailable. Please try again later.');
    }
  }

  static Future<City> getCityFromLocation(double lat, double lon) async {
    http.Response response;
    try {
      response = await http.get(
        Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lon&format=json&accept-language=en',
        ),
      );
    } catch (e) {
      throw Exception('please check your internet connection.');
    }

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return City(
        name: data['address']['city'] ?? 'Unknown',
        region: data['address']['state'] ?? 'Unknown',
        country: data['address']['country'] ?? 'Unknown',
        latitude: lat,
        longitude: lon,
      );
    } else if (response.statusCode >= 400 && response.statusCode <= 500) {
      throw Exception('Invalid request. Check the coordinates or try again.');
    } else {
      throw Exception(
          'The API server is temporarily unavailable. Please try again later.');
    }
  }
}
