import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/weather_providers.dart';
import '../../providers/location_providers.dart';
import '../error_message.dart';

class CurrentWeatherTab extends ConsumerWidget {
  const CurrentWeatherTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeather = ref.watch(currentWeatherProvider);
    final selectedCity = ref.watch(selectedCityProvider);

    return currentWeather.when(
        data: (weather) {
          if (weather == null) {
            return const ErrorMessage();
          }
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ...[
                Text(
                    'Location: ${selectedCity?.name ?? "Unknown"}, ${selectedCity?.region ?? "Unknown"}, ${selectedCity?.country ?? "Unknown"}'),
                Text('Temperature: ${weather.temperature}°C'),
                Text('Description: ${weather.weatherDescription}'),
                Text('Wind Speed: ${weather.windSpeed} km/h'),
              ],
            ],
          );
        },
        loading: () => CircularProgressIndicator(),
        error: (e, _) {
          ref.read(appStatusProvider.notifier).setErrorStatus("$e");
          return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ...[
                  Text(
                      'Location: ${selectedCity?.name ?? "Unknown"}, ${selectedCity?.region ?? "Unknown"}, ${selectedCity?.country ?? "Unknown"}'),
                  Text('Temperature:Unknown'),
                  Text('Description: Unknown'),
                  Text('Wind Speed: Unknown'),
                ]
              ]);
        });
  }
}
