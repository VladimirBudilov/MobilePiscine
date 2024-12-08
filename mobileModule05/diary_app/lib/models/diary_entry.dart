class DiaryEntry {
  final String id;
  final String email;
  final String mood;
  final String title;
  final String description;
  final String date;

  DiaryEntry({
    required this.id,
    required this.email,
    required this.mood,
    required this.title,
    required this.description,
    required this.date,
  });

  factory DiaryEntry.fromFirestore(String id, Map<String, dynamic> data) {
    return DiaryEntry(
      id: id,
      title: data['title'] ?? '',
      email: data['email'] ?? '',
      mood: data['feeling'] ?? '',
      description: data['description'] ?? '',
      date: data['date'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'email': email,
      'feeling': mood,
    };
  }
}
