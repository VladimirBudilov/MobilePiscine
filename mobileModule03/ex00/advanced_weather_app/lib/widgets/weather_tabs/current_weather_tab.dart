import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/weather_providers.dart';
import '../../providers/location_providers.dart';
import '../../utils/weather_icons.dart';

class CurrentWeatherTab extends ConsumerWidget {
  const CurrentWeatherTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeather = ref.watch(currentWeatherProvider);
    final selectedCity = ref.watch(selectedCityProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: currentWeather.when(
        data: (weather) {
          if (weather == null) {
            return Center(
              child: Text(
                "Invalid City was selected. Please select a valid city.",
                style: TextStyle(fontSize: 16, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Location
              Text(
                '${selectedCity?.name ?? "Unknown"}, ${selectedCity?.region ?? "Unknown"}, ${selectedCity?.country ?? "Unknown"}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              // Weather Icon and Temperature
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    getWeatherIcon(weather.weatherCode),
                    width: 64,
                    height: 64,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.cloud, size: 64),
                  ),
                  SizedBox(width: 16),
                  Text(
                    '${weather.temperature}°C',
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ],
              ),
              SizedBox(height: 8),
              // Description
              Text(
                weather.weatherDescription,
                style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              // Wind Speed
              Text(
                'Wind Speed: ${weather.windSpeed} km/h',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
            ],
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(),
        ),
        error: (e, _) {
          ref.read(appStatusProvider.notifier).setErrorStatus("$e");
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Unable to load weather data.',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
                SizedBox(height: 8),
                Text(
                  '${selectedCity?.name ?? "Unknown"}, ${selectedCity?.region ?? "Unknown"}, ${selectedCity?.country ?? "Unknown"}',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
