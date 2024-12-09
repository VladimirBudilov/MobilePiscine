import 'package:diary_app/widgets/sections/bottom_section.dart';
import 'package:diary_app/widgets/sections/middle_section.dart';
import 'package:flutter/material.dart';
import '../services/diary_service.dart';
import '../models/diary_entry.dart';
import '../widgets/create_entry_dialog.dart';
import '../widgets/view_entry_dialog.dart';
import '../services/auth_service.dart';
import '../widgets/sections/top_section.dart';

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
  String _userName = '';
  Map<String, double> _moodData = {};

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadEntries();
    _loadMoodData();
  }

  Future<void> _loadUserData() async {
    final user = widget.authService.currentUser;
    if (user != null) {
      setState(() {
        _userName = user.displayName ?? 'User';
      });
    }
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

  Future<void> _loadMoodData() async {
    final user = widget.authService.currentUser;
    if (user != null) {
      final moodData = await widget.diaryService.fetchMoodStatistics(user.uid);
      setState(() {
        _moodData = moodData;
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
        _loadMoodData();
      }
    }
  }

  void _viewEntry(DiaryEntry entry) {
    showDialog(
      context: context,
      builder: (context) => ViewEntryDialog(
        entry: entry,
        diaryService: widget.diaryService,
        authService: widget.authService,
        onUpdate: () {
          _loadEntries();
          _loadMoodData();
        },
      ),
    );
  }

  void _logout() async {
    await widget.authService.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background_main.webp"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.4),
                BlendMode.dstATop,
              ),
            ),
          ),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: TopSection(
                  userName: _userName,
                  onLogout: _logout,
                  onNavigateToCalendar: () => print('Navigate to Calendar'),
                ),
              ),
              Expanded(
                flex: 4,
                child: MiddleSection(
                  entries: _entries,
                  createEntry: _createEntry,
                  viewEntry: _viewEntry,
                ),
              ),
              Expanded(flex: 4, child: BottomSection(moodData: _moodData)),
            ],
          ),
        ),
      ),
    );
  }
}
