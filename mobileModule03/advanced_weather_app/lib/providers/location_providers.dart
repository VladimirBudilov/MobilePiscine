import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/geolocation_service.dart';
import '../models/app_status_model.dart';
import '../models/city_model.dart';
import '../services/geocoding_service.dart';

final selectedCityProvider = StateProvider<City?>((ref) => null);

final appStatusProvider =
    StateNotifierProvider<LocationStatusNotifier, AppStatus>((ref) {
  return LocationStatusNotifier();
});

class LocationStatusNotifier extends StateNotifier<AppStatus> {
  LocationStatusNotifier() : super(AppStatus(status: '', isLoading: false));

  void setLoadingStatus() {
    state = AppStatus(status: 'Loading...', isLoading: true);
  }

  void setErrorStatus(String error) {
    state = AppStatus(status: '', isLoading: false, error: error);
  }

  void setSuccessStatus(String status) {
    state = AppStatus(status: status, isLoading: false);
  }

  Future<void> checkLocationPermission() async {
    setLoadingStatus();
    final status = await GeolocationService.checkLocationPermission();
    if (status.isEmpty) {
      setSuccessStatus(status);
    } else {
      setErrorStatus(status);
    }
  }

  Future<void> useGeolocation(WidgetRef ref) async {
    setLoadingStatus();
    await checkLocationPermission();
    final position = await GeolocationService.getCurrentLocation();
    if (position != null) {
      try {
        final city = await GeocodingService.getCityFromLocation(
            position.latitude, position.longitude);
        ref.read(selectedCityProvider.notifier).state = city;
        setSuccessStatus('');
      } catch (e) {
        setErrorStatus('$e');
      }
    }
  }
}
