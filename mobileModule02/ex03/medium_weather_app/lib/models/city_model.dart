class City {
  final String name;
  final String region;
  final String country;
  final double latitude;
  final double longitude;

  City({required this.name, required this.region, required this.country, required this.latitude, required this.longitude});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'],
      region: json['admin1'] ?? 'Unknown Region',
      country: json['country'] ?? 'Unknown Country',
      latitude: json["latitude"] ?? 0.0,
      longitude: json["longitude"] ?? 0.0,
    );
  }
}
