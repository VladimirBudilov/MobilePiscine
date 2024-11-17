import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/weather_providers.dart';
import '../../providers/location_providers.dart';

class WeeklyWeatherTab extends ConsumerWidget {
  const WeeklyWeatherTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCity = ref.watch(selectedCityProvider);
    final weeklyWeather = ref.watch(weeklyWeatherProvider);

    return weeklyWeather.when(
      data: (weeklyData) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${selectedCity?.name ?? "Unknown City"}, ${selectedCity?.region ?? ""}, ${selectedCity?.country ?? ""}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: weeklyData.length,
              itemBuilder: (context, index) {
                final daily = weeklyData[index];
                final formattedDate = DateFormat('EEEE, MMM d').format(daily.date);

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text(formattedDate),
                    subtitle: Text(
                      'Min: ${daily.temperatureMin}°C, Max: ${daily.temperatureMax}°C\n${daily.weatherDescription}',
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}
