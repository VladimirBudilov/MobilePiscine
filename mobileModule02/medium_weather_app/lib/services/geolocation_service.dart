import 'package:geolocator/geolocator.dart';

class GeolocationService {
  static Future<String> checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return 'Location services are disabled.';
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return 'Location permissions were denied.';
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return 'Location permissions are permanently denied.';
    }
    return '';
  }

  static Future<Position?> getCurrentLocation() async {
    try {
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      return null;
    }
  }
}
