import 'package:flutter/material.dart';
import '../models/diary_entry.dart';

class CreateEntryDialog extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Create Entry'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              maxLength: 50,
              decoration: InputDecoration(labelText: 'Title'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Title is required';
                }
                return null;
              },
              onChanged: (value) => _title = value,
            ),
            TextFormField(
              maxLength: 500,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Description is required';
                }
                return null;
              },
              onChanged: (value) => _description = value,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final newEntry = DiaryEntry(
                id: '', // Firebase will generate ID
                title: _title,
                description: _description,
                date: DateTime.now().toIso8601String(),
              );
              Navigator.pop(context, newEntry);
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
