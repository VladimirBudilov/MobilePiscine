import 'package:flutter/material.dart';
import '../../models/diary_entry.dart';
import 'package:intl/intl.dart';
import '../../services/mood_icon_service.dart';

class MiddleSection extends StatelessWidget {
  final List<DiaryEntry> entries;
  final VoidCallback createEntry;
  final Function(DiaryEntry) viewEntry;

  const MiddleSection({
    Key? key,
    required this.entries,
    required this.createEntry,
    required this.viewEntry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Recent Notes (Total: ${entries.length})',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'StrangeFont',
                color: const Color.fromARGB(255, 32, 31, 31),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...entries.take(2).map((entry) {
            final formattedDate =
                DateFormat('dd MMM yyyy').format(DateTime.parse(entry.date));
            final moodIconPath = MoodIconService.moodToIcon(entry.mood);
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Image.asset(
                    moodIconPath,
                    width: 46,
                    height: 46,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error, color: Colors.red);
                    },
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      entry.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          Padding(padding: const EdgeInsets.all(8)),
              Center(
                child: ElevatedButton(
                  onPressed: createEntry,
                  child: const Text('Add Note'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    textStyle: const TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontFamily: 'StrangeFont',
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
