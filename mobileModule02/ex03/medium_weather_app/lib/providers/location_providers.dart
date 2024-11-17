import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/geolocation_service.dart';
import '../models/location_status_model.dart';
import '../models/city_model.dart';
import '../services/geocoding_service.dart';

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

  Future<void> useGeolocation(WidgetRef ref) async {
    await checkLocationPermission();  
    state = LocationStatus(status: 'Loading...', isLoading: true);
    final position = await GeolocationService.getCurrentLocation();
    if (position != null) {
      ref.read(selectedCityProvider.notifier).state = await GeocodingService.getCityFromLocation(position.latitude, position.longitude);
    }
    state = LocationStatus(status: 'Loaded', isLoading: false);
  }
}