import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/location_providers.dart';

class LocationStatusWidget extends ConsumerWidget {
  const LocationStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationStatus = ref.watch(locationStatusProvider);

    if (locationStatus.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (locationStatus.error != null) {
      return Center(
        child: Text('Error: ${locationStatus.error}', style: TextStyle(color: Colors.red)),
      );
    }

    return Center(child: Text(locationStatus.status));
  }
}
