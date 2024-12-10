import 'package:flutter/material.dart';
import '../../models/diary_entry.dart';
import '../diary_entry.dart';

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
    List<DiaryEntry> sortedEntries = List.from(entries);
    sortedEntries.sort(
      (a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)),
    );

    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Recent Notes (Total: ${entries.length})',
              style: const TextStyle(
                fontSize: 26,
                fontFamily: 'StrangeFont',
                color: Color.fromARGB(255, 32, 31, 31),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...sortedEntries.take(2).map((entry) {
            return DiaryEntryWidget(
              entry: entry,
              onTap: () => viewEntry(entry),
            );
          }),
          Center(
            child: ElevatedButton(
              onPressed: createEntry,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color.fromARGB(186, 102, 194, 255).withOpacity(0.6),
                foregroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                textStyle: const TextStyle(
                  fontSize: 24,
                  fontFamily: 'StrangeFont',
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.black.withOpacity(0.7)),
                ),
              ),
              child: const Text('Add Note'),
            ),
          ),
        ],
      ),
    );
  }
}
