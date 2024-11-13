import 'package:flutter/material.dart';
import 'dart:async';
import '../models/city.dart';
import '../services/geocoding_service.dart';
import '../services/weather_service.dart';

class CitySearchField extends StatefulWidget {
  final ValueChanged<City> onCitySelected;

  const CitySearchField({super.key, required this.onCitySelected});

  @override
  _CitySearchFieldState createState() => _CitySearchFieldState();
}

class _CitySearchFieldState extends State<CitySearchField> {
  final TextEditingController _controller = TextEditingController();
  OverlayEntry? _overlayEntry;
  List<City> _suggestions = [];
  Timer? _debounceTimer; 

  void _onSearchChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    if (query.isEmpty) {
      _removeOverlay();
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      try {
        final results = await GeocodingService.fetchCitySuggestions(query);
     if (results.isNotEmpty) {
      final weatherData = await WeatherService.fetchWeather(results.first);
      print(weatherData);
      }
        setState(() {
          _suggestions = results;
        });
        _showOverlay();
      } catch (e) {
        setState(() {
          _suggestions = [];
        });
        _removeOverlay();
      }
    });
  }

  void _onCitySelected(City city) async {
  widget.onCitySelected(city);
  _controller.clear();
  _removeOverlay();

  final weatherData = await WeatherService.fetchWeather(city);
        print(weatherData);
}

  void _showOverlay() {
    _removeOverlay();
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx,
        top: position.dy + size.height,
        width: size.width,
        child: Material(
          elevation: 4.0,
          child: _buildSuggestionList(),
        ),
      ),
    );
    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Widget _buildSuggestionList() {
    return  ListView.builder(
            shrinkWrap: true,
            itemCount: _suggestions.length,
            itemBuilder: (context, index) {
              final city = _suggestions[index];
              return ListTile(
                title: Text(city.name),
                subtitle: Text('${city.region}, ${city.country}'),
                onTap: () {
                  widget.onCitySelected(city);
                  _controller.clear();
                  _removeOverlay();
                },
              );
            },
          );
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _onSearchChanged(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounceTimer?.cancel();
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: 'Enter city name...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
