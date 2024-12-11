import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/diary_entry.dart';
import 'package:intl/intl.dart';

class DiaryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<DiaryEntry>> fetchEntries(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('entries')
        .get();

    return snapshot.docs
        .map((doc) => DiaryEntry.fromFirestore(doc.id, doc.data()))
        .toList();
  }

  Future<void> addEntry(String userId, DiaryEntry entry) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('entries')
        .add(entry.toFirestore());
  }

  Future<void> deleteEntry(String userId, String entryId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('entries')
        .doc(entryId)
        .delete();
  }

  Future<Map<String, double>> fetchMoodStatistics(String userId) async {
    List<DiaryEntry> entries = await fetchEntries(userId);

    Map<String, int> moodCount = {
      'Happy': 0,
      'Sad': 0,
      'Neutral': 0,
      'Angry': 0,
      'Excited': 0,
      'Calm': 0,
      'Exhausted': 0,
      'Stressed': 0,
      'Default': 0,
    };

    DateTime sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    for (var entry in entries) {
      DateTime entryDate = DateFormat('yyyy-MM-dd').parse(entry.date);
      if (entryDate.isAfter(sevenDaysAgo)) {
        moodCount[entry.mood] = (moodCount[entry.mood] ?? 0) + 1;
      }
    }
    moodCount.removeWhere((key, value) => value == 0);
    double totalEntries = moodCount.values.fold(0, (sum, count) => sum + count);
    Map<String, double> moodPercentages = {};
    moodCount.forEach((mood, count) {
      moodPercentages[mood] =
          totalEntries > 0 ? (count / totalEntries) * 100 : 0.0;
    });

    return moodPercentages;
  }
}
