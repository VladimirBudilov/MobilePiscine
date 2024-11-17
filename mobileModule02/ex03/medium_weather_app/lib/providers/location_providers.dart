import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/geolocation_service.dart';
import '../models/location_status_model.dart';
import '../models/city_model.dart';

final selectedCityProvider = StateProvider<City?>((ref) => null);

final locationStatusProvider = StateNotifierProvider<LocationStatusNotifier, LocationStatus>((ref) {
  return LocationStatusNotifier();
});

class LocationStatusNotifier extends StateNotifier<LocationStatus> {
  LocationStatusNotifier() : super(LocationStatus(status: '', isLoading: false));

  Future<void> checkLocationPermission() async {
    state = LocationStatus(status: 'Checking...', isLoading: true);
    final status = await GeolocationService.checkLocationPermission();
    state = LocationStatus(status: status, isLoading: false);
  }

  Future<void> useGeolocation() async {
    state = LocationStatus(status: 'Loading...', isLoading: true);
    final position = await GeolocationService.getCurrentLocation();
    if (position != null) {
      // Здесь можно обновить город и погоду, если геолокация успешна
    }
    state = LocationStatus(status: 'Loaded', isLoading: false);
  }
}