import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/weather_providers.dart';
import '../../providers/location_providers.dart';

class CurrentWeatherTab extends ConsumerWidget {
  const CurrentWeatherTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeather = ref.watch(currentWeatherProvider);
    final selectedCity = ref.watch(selectedCityProvider);

    return currentWeather.when(
      data: (weather) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              'Location: ${selectedCity?.name ?? "empty"}, ${selectedCity?.region ?? "empty"}, ${selectedCity?.country ?? "empty"}'),
          Text('Temperature: ${weather.temperature}°C'),
          Text('Description: ${weather.weatherDescription}'),
          Text('Wind Speed: ${weather.windSpeed} km/h'),
        ],
      ),
      loading: () => CircularProgressIndicator(),
      error: (e, _) => Text(e.toString().replaceFirst('Exception: ', ''),
          style: TextStyle(color: Colors.red)),
    );
  }
}
