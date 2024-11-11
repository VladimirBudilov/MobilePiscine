import 'package:flutter/material.dart';

class LocationStatus extends StatelessWidget {
  final String status;
  final bool isLoading;

  const LocationStatus({super.key, required this.status, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: isLoading
          ? const CircularProgressIndicator()
          : Text(status, style: const TextStyle(color: Colors.red)),
    );
  }
}
