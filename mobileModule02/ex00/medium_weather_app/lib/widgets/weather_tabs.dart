import 'package:flutter/material.dart';

class WeatherTabs extends StatelessWidget {
  final TabController tabController;
  final String displayText;

  const WeatherTabs({super.key, required this.tabController, required this.displayText});

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: [
        Center(child: Text('Currently: $displayText', style: const TextStyle(fontSize: 24))),
        Center(child: Text('Today: $displayText', style: const TextStyle(fontSize: 24))),
        Center(child: Text('Weekly: $displayText', style: const TextStyle(fontSize: 24))),
      ],
    );
  }
}
