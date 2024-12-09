class MoodIconService {
  static const Map<String, String> _moodToIcon = {
    'Happy': 'assets/icon/emotions/happy.png',
    'Sad': 'assets/icon/emotions/sad.png',
    'Angry': 'assets/icon/emotions/angry.png',
    'Excited': 'assets/icon/emotions/excited.png',
    'Calm': 'assets/icon/emotions/calm.png',
    'Default': 'assets/icon/emotions/default.png',
    'Exhausted': 'assets/icon/emotions/exhausted.png',
    'Stressed': 'assets/icon/emotions/stressed.png',
  };

  static String moodToIcon(String mood) {
    return _moodToIcon[mood] ?? 'assets/icon/emotions/default.png';
  }

  static String iconToMood(String iconPath) {
    return _moodToIcon.entries
        .firstWhere((entry) => entry.value == iconPath,
            orElse: () => const MapEntry('Default', 'assets/icon/emotions/default.png'))
        .key;
  }

  static List<String> get moods => _moodToIcon.keys.toList();
  static String get defaultIcon => _moodToIcon['Default']!;
}