import 'package:flutter/material.dart';
import '../widgets/city_search_field.dart';
import '../widgets/location_status.dart';
import '../widgets/weather_tabs.dart';
import '../services/geolocation_service.dart';

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  _WeatherHomePageState createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _displayText = '';
  String _locationStatus = '';
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    final status = await GeolocationService.checkLocationPermission();
    if (status == 'Permission granted') {
      _useGeolocation();
      return;
    }
    setState(() => _locationStatus = status);
  }

  Future<void> _useGeolocation() async {
    setState(() => _isLoadingLocation = true);
    final position = await GeolocationService.getCurrentLocation();
    setState(() {
      _displayText = position != null
          ? 'Latitude: ${position.latitude}, Longitude: ${position.longitude}'
          : 'Failed to get location';
      _isLoadingLocation = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CitySearchField(
          onSubmitted: (city) {
            setState(() => _displayText = city);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _useGeolocation,
          ),
        ],
      ),
      body: Column(
        children: [
          LocationStatus(status: _locationStatus, isLoading: _isLoadingLocation),
          Expanded(
            child: WeatherTabs(tabController: _tabController, displayText: _displayText),
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
