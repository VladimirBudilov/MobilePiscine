import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../providers/location_providers.dart';

final internetStatusProvider = StreamProvider<bool>((ref) {
  return InternetConnectionChecker().onStatusChange.map(
        (status) => status == InternetConnectionStatus.connected,
      );
});

class AppStatusWidget extends ConsumerWidget {
  const AppStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationStatus = ref.watch(appStatusProvider);

    final internetStatus = ref.watch(internetStatusProvider);

    if (locationStatus.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    String locationErrorMessage = '';
    String internetErrorMessage = '';

    if (locationStatus.error != null) {
      locationErrorMessage = '${locationStatus.error}';
    }

    internetStatus.when(
      data: (isConnected) {
        if (!isConnected) {
          internetErrorMessage = 'No internet connection';
        }
      },
      loading: () {},
      error: (err, stack) {
        internetErrorMessage = '$err';
      },
    );

    if (locationErrorMessage.isNotEmpty || internetErrorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (locationErrorMessage.isNotEmpty)
              Text(
                locationErrorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            if (internetErrorMessage.isNotEmpty)
              Text(
                internetErrorMessage,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      );
    }

    return internetStatus.when(
      data: (isConnected) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8.0),
              Text(locationStatus.status),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Text(
          '$err',
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}
