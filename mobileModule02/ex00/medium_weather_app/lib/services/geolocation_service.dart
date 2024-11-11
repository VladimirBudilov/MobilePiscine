import 'package:geolocator/geolocator.dart';

class GeolocationService {
  static Future<String> checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return 'Location services are disabled. Enable them in your settings.';
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return 'Location permissions were denied. Allow access in settings.';
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return 'Location permissions are permanently denied. Go to settings to allow them.';
    }
    return 'Permission granted';
  }

  static Future<Position?> getCurrentLocation() async {
    try {
      return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      return null;
    }
  }
}
