import 'package:diary_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import '../models/diary_entry.dart';
import '../services/diary_service.dart';

class ViewEntryDialog extends StatelessWidget {
  final DiaryEntry entry;
  final DiaryService diaryService;
  final AuthService authService;
  final VoidCallback onUpdate;

  ViewEntryDialog({
    required this.entry,
    required this.diaryService,
    required this.authService,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(entry.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Date: ${entry.date}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Mood: ${entry.mood}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(entry.description),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Close'),
        ),
        TextButton(
          onPressed: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Confirm Deletion'),
                  content: Text('Are you sure you want to delete this entry?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text('Delete'),
                    ),
                  ],
                );
              },
            );

            if (confirm == true) {
              diaryService.deleteEntry(
                authService.currentUser!.uid,
                entry.id,
              );
               onUpdate();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Entry deleted successfully')),
              );
            }
          },
          child: Text('Delete'),
        ),
      ],
    );
  }
}
