class AppStatus {
  final String status;
  final bool isLoading;
  final String? error;

  AppStatus({
    required this.status,
    required this.isLoading,
    this.error,
  });
}
