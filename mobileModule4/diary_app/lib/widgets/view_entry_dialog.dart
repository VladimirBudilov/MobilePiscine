import 'package:flutter/material.dart';
import '../models/diary_entry.dart';

class ViewEntryDialog extends StatelessWidget {
  final DiaryEntry entry;

  ViewEntryDialog({required this.entry});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(entry.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Date: ${entry.date}', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(entry.description),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Close'),
        ),
      ],
    );
  }
}
