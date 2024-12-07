import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../providers/weather_providers.dart';
import '../../providers/location_providers.dart';
import '../../utils/weather_icons.dart';

class WeeklyWeatherTab extends ConsumerWidget {
  const WeeklyWeatherTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCity = ref.watch(selectedCityProvider);
    final weeklyWeather = ref.watch(weeklyWeatherProvider);

    return weeklyWeather.when(
      data: (weeklyData) {
        if (weeklyData.isEmpty) {
          return Center(
            child: Text(
              "Invalid City was selected. Please select a valid city.",
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return Container(
            alignment: Alignment.center,
            child: SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${selectedCity?.name ?? "Unknown City"}, ${selectedCity?.region ?? ""}, ${selectedCity?.country ?? ""}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 250,
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(
                      title: AxisTitle(
                        text: 'Days of the Week',
                        textStyle: TextStyle(color: Colors.black54),
                      ),
                    ),
                    primaryYAxis: NumericAxis(
                      title: AxisTitle(
                        text: 'Temperature (°C)',
                        textStyle: TextStyle(color: Colors.black54),
                      ),
                      minimum: weeklyData
                              .map((data) => data.temperatureMin)
                              .reduce((a, b) => a < b ? a : b) -
                          5,
                      maximum: weeklyData
                              .map((data) => data.temperatureMax)
                              .reduce((a, b) => a > b ? a : b) +
                          5,
                    ),
                    series: <ChartSeries>[
                      LineSeries<dynamic, String>(
                        name: 'Min Temp',
                        dataSource: weeklyData,
                        xValueMapper: (data, _) =>
                            DateFormat('EEEE').format(data.date),
                        yValueMapper: (data, _) => data.temperatureMin,
                        color: Colors.blue,
                        width: 2,
                        markerSettings: MarkerSettings(isVisible: true),
                      ),
                      LineSeries<dynamic, String>(
                        name: 'Max Temp',
                        dataSource: weeklyData,
                        xValueMapper: (data, _) =>
                            DateFormat('EEEE').format(data.date),
                        yValueMapper: (data, _) => data.temperatureMax,
                        color: Colors.red,
                        width: 2,
                        markerSettings: MarkerSettings(isVisible: true),
                      ),
                    ],
                    legend: Legend(isVisible: true),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 160,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: weeklyData.length,
                    itemBuilder: (context, index) {
                      final daily = weeklyData[index];
                      final formattedDay =
                          DateFormat('EEEE').format(daily.date);
                      return Container(
                        width: 120,
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Card(
                          color: const Color.fromARGB(255, 200, 222, 243),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  formattedDay,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Min: ${daily.temperatureMin}°C',
                                  style: TextStyle(fontSize: 12),
                                ),
                                Text(
                                  'Max: ${daily.temperatureMax}°C',
                                  style: TextStyle(fontSize: 12),
                                ),
                                const SizedBox(height: 4),
                                Image.network(
                                  getWeatherIcon(daily.weatherCode),
                                  width: 40,
                                  height: 40,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.cloud,
                                          color: Colors.black54, size: 40),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )));
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) {
        ref.read(appStatusProvider.notifier).setErrorStatus("$e");
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$e",
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        );
      },
    );
  }
}
