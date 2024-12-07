import 'package:flutter/material.dart';
import '../services/diary_service.dart';
import '../models/diary_entry.dart';
import '../widgets/create_entry_dialog.dart';
import '../widgets/view_entry_dialog.dart';
import '../services/auth_service.dart';

class DiaryPage extends StatefulWidget {
  final AuthService authService;
  final DiaryService diaryService;

  const DiaryPage({
    Key? key,
    required this.authService,
    required this.diaryService,
  }) : super(key: key);

  @override
  _DiaryPageState createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  List<DiaryEntry> _entries = [];

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final user = widget.authService.currentUser;
    if (user != null) {
      final entries = await widget.diaryService.fetchEntries(user.uid);
      setState(() {
        _entries = entries;
      });
    }
  }

  void _createEntry() async {
    final newEntry = await showDialog<DiaryEntry>(
      context: context,
      builder: (context) => CreateEntryDialog(),
    );

    if (newEntry != null) {
      final user = widget.authService.currentUser;
      if (user != null) {
        await widget.diaryService.addEntry(user.uid, newEntry);
        _loadEntries();
      }
    }
  }

  void _viewEntry(DiaryEntry entry) {
    showDialog(
      context: context,
      builder: (context) => ViewEntryDialog(entry: entry),
    );
  }

  void _logout() async {
    await widget.authService.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diary'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _entries.length,
        itemBuilder: (context, index) {
          final entry = _entries[index];
          return ListTile(
            title: Text(entry.title),
            subtitle: Text(entry.date),
            onTap: () => _viewEntry(entry),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createEntry,
        child: Icon(Icons.add),
      ),
    );
  }
}
