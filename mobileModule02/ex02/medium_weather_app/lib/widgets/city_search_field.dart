import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/city_model.dart';
import '../providers/location_providers.dart';
import '../services/geocoding_service.dart';

class CitySearchField extends ConsumerStatefulWidget {
  final ValueChanged<City> onCitySelected;

  const CitySearchField({super.key, required this.onCitySelected});

  @override
  _CitySearchFieldState createState() => _CitySearchFieldState();
}

class _CitySearchFieldState extends ConsumerState<CitySearchField> {
  final TextEditingController _controller = TextEditingController();
  OverlayEntry? _overlayEntry;
  List<City> _suggestions = [];

  void _onSearchChanged(String query) async {
    if (query.isEmpty) {
      ref.read(selectedCityProvider.notifier).state = null;
      _removeOverlay();
      return;
    }


    try {
      final results = await GeocodingService.fetchCitySuggestions(query);
      setState(() {
        _suggestions = results;
      });
      ref.read(selectedCityProvider.notifier).state = _suggestions.first;
      _showOverlay();
    } catch (e) {
      setState(() {
        _suggestions = [];
      });
      _removeOverlay();
    }
  }

  void _onCitySelected(City city) async {
    widget.onCitySelected(city);
    _controller.clear();
    _removeOverlay();

    ref.read(selectedCityProvider.notifier).state = city;
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
          elevation: 1.0,
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
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _suggestions.length,
      itemBuilder: (context, index) {
        final city = _suggestions[index];
        return ListTile(
          title: Text(city.name),
          subtitle: Text('${city.region}, ${city.country}'),
          onTap: () => _onCitySelected(city),
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
