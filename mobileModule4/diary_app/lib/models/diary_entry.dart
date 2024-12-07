class DiaryEntry {
  final String id;
  final String title;
  final String description;
  final String date;

  DiaryEntry({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
  });

  factory DiaryEntry.fromFirestore(String id, Map<String, dynamic> data) {
    return DiaryEntry(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      date: data['date'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'date': date,
    };
  }
}
