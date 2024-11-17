// Модель состояния геолокации
class LocationStatus {
  final String status;
  final bool isLoading;
  final String? error;

  LocationStatus({
    required this.status,
    required this.isLoading,
    this.error,
  });
}