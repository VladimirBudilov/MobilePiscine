import 'package:flutter/material.dart';

class CitySearchField extends StatelessWidget {
  final ValueChanged<String> onSubmitted;

  const CitySearchField({super.key, required this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: onSubmitted,
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
    );
  }
}
