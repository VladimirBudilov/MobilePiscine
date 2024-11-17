import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/weather_providers.dart';
import '../../providers/location_providers.dart';

class TodayWeatherTab extends ConsumerWidget {
  const TodayWeatherTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCity = ref.watch(selectedCityProvider);
    final hourlyWeather = ref.watch(todayWeatherProvider);

    return hourlyWeather.when(
      data: (hourlyData) => Column(
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
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Time')),
                    DataColumn(label: Text('Temp(°C)')),
                    DataColumn(label: Text('Condition')),
                    DataColumn(label: Text('Wind')),
                  ],
                  rows: hourlyData.map((hourWeather) {
                    final formattedTime = DateFormat('HH:mm').format(hourWeather.time);
                    return DataRow(cells: [
                      DataCell(Text(formattedTime)),
                      DataCell(Text('${hourWeather.temperature}°C')),
                      DataCell(Text(hourWeather.weatherDescription)),
                      DataCell(Text(hourWeather.windSpeed.toString())),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}