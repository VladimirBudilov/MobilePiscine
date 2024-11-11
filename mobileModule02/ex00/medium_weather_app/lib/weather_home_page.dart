import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _locationStatus = 'Location services are disabled. Please enable them in your settings.';
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationStatus = 'Location permissions were denied. Please allow access.';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationStatus = 'Location permissions are permanently denied. Go to settings to allow them.';
      });
      return;
    }

    setState(() {
      _locationStatus = 'Fetching location...';
      _isLoadingLocation = true;
    });
    await _useGeolocation();
  }

  Future<void> _useGeolocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _displayText = 'Latitude: ${position.latitude}\nLongitude: ${position.longitude}';
        _locationStatus = '';
        _isLoadingLocation = false;
      });
    } catch (e) {
      setState(() {
        _locationStatus = 'Error getting location: $e';
        _isLoadingLocation = false;
      });
    }
  }

  void _updateText(String text) {
    setState(() {
      _displayText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onSubmitted: (text) {
            _updateText(text);
          },
          decoration: InputDecoration(
            hintText: 'Search location...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              setState(() {
                _isLoadingLocation = true;
                _locationStatus = 'Fetching location...';
              });
              _useGeolocation();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_locationStatus.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _locationStatus,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          if (_isLoadingLocation) const CircularProgressIndicator(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Center(child: Text('Currently: $_displayText', style: const TextStyle(fontSize: 24))),
                Center(child: Text('Today: $_displayText', style: const TextStyle(fontSize: 24))),
                Center(child: Text('Weekly: $_displayText', style: const TextStyle(fontSize: 24))),
              ],
            ),
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
