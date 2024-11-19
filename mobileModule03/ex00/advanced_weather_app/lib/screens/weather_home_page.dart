import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/city_search_field.dart';
import '../widgets/app_status.dart';
import '../widgets/weather_tabs.dart';
import '../providers/location_providers.dart';

class WeatherHomePage extends ConsumerStatefulWidget {
  const WeatherHomePage({super.key});

  @override
  ConsumerState<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends ConsumerState<WeatherHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          top: true,
          child: AppBar(
            title: CitySearchField(
              onCitySelected: (city) {
                ref.read(selectedCityProvider.notifier).state = city;
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.my_location),
                onPressed: () => {
                  ref.read(locationStatusProvider.notifier).useGeolocation(ref),
                },
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8.0),
          AppStatusWidget(),
          Expanded(
            child: WeatherTabs(tabController: _tabController),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.wb_sunny), text: 'Currently'),
            Tab(icon: Icon(Icons.today), text: 'Today'),
            Tab(icon: Icon(Icons.calendar_view_week), text: 'Weekly'),
          ],
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorSize: TabBarIndicatorSize.label,
        ),
      ),
    );
  }
}
