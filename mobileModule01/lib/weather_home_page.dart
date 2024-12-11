import 'package:flutter/material.dart';

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  _WeatherHomePageState createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _displayText = '';

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

  void _updateText(String text) {
    setState(() {
      _displayText = text;
    });
  }

  void _useGeolocation() {
    setState(() {
      _displayText = 'Geolocation';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: AppBar(
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
                onPressed: _useGeolocation,
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Center(child: Text('Currently: $_displayText', style: const TextStyle(fontSize: 24))),
          Center(child: Text('Today: $_displayText', style: const TextStyle(fontSize: 24))),
          Center(child: Text('Weekly: $_displayText', style: const TextStyle(fontSize: 24))),
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