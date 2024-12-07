import 'package:flutter/material.dart';
import 'weather_tabs/current_weather_tab.dart';
import 'weather_tabs/today_weather_tab.dart';
import 'weather_tabs/weekly_weather_tab.dart';

class WeatherTabs extends StatelessWidget {
  final TabController tabController;

  const WeatherTabs({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: [
        Center(child: CurrentWeatherTab()),
        Center(child: TodayWeatherTab()),
        Center(child: WeeklyWeatherTab()),
      ],
    );
  }
}
