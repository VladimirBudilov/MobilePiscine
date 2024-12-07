import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/diary_entry.dart';

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
}
