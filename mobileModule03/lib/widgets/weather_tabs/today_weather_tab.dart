import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../../providers/weather_providers.dart';
import '../../providers/location_providers.dart';
import '../../utils/weather_icons.dart';
import '../../models/weather/hourly_weather.dart';
import '../error_mesage.dart';

class TodayWeatherTab extends ConsumerWidget {
  const TodayWeatherTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCity = ref.watch(selectedCityProvider);
    final hourlyWeather = ref.watch(todayWeatherProvider);

    return hourlyWeather.when(
      data: (hourlyData) {
        Future.microtask(
            () => ref.read(appStatusProvider.notifier).setErrorStatus(''));

        if (hourlyData.isEmpty) {
          return const ErrorMessage();
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${selectedCity?.name ?? "Unknown City"}, ${selectedCity?.region ?? ""}, ${selectedCity?.country ?? ""}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 250,
                  child: SfCartesianChart(
                    primaryXAxis: DateTimeAxis(
                      title: AxisTitle(
                        text: 'Time of Day',
                        textStyle: TextStyle(color: Colors.black54),
                      ),
                      dateFormat: DateFormat.Hm(),
                      intervalType: DateTimeIntervalType.hours,
                      minimum: DateTime(
                          hourlyData.first.time.year,
                          hourlyData.first.time.month,
                          hourlyData.first.time.day,
                          0,
                          0),
                      maximum: DateTime(
                          hourlyData.first.time.year,
                          hourlyData.first.time.month,
                          hourlyData.first.time.day,
                          23,
                          59),
                    ),
                    primaryYAxis: NumericAxis(
                      title: AxisTitle(
                        text: 'Temperature (°C)',
                        textStyle: TextStyle(color: Colors.black54),
                      ),
                      minimum: hourlyData
                              .map((data) => data.temperature)
                              .reduce((a, b) => a < b ? a : b) -
                          5,
                      maximum: hourlyData
                              .map((data) => data.temperature)
                              .reduce((a, b) => a > b ? a : b) +
                          5,
                    ),
                    series: <ChartSeries>[
                      LineSeries<HourlyWeather, DateTime>(
                        dataSource: hourlyData,
                        xValueMapper: (HourlyWeather data, _) => data.time,
                        yValueMapper: (HourlyWeather data, _) =>
                            data.temperature,
                        color: Colors.blue,
                        width: 2,
                        markerSettings: MarkerSettings(isVisible: true),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 160,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: hourlyData.length,
                    itemBuilder: (context, index) {
                      final hourWeather = hourlyData[index];
                      final formattedTime =
                          DateFormat('HH:mm').format(hourWeather.time);
                      return Container(
                        width: 100,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 200, 222, 243),
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              formattedTime,
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black87),
                            ),
                            const SizedBox(height: 8),
                            Image.network(
                              getWeatherIcon(hourWeather.weatherCode),
                              width: 40,
                              height: 40,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.cloud,
                                      color: Colors.black54, size: 40),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${hourWeather.temperature}°C',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${hourWeather.windSpeed} km/h',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) {
        ref.read(appStatusProvider.notifier).setErrorStatus("$e");
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Error: $e",
                style: TextStyle(fontSize: 14, color: Colors.red),
              ),
            ],
          ),
        );
      },
    );
  }
}
