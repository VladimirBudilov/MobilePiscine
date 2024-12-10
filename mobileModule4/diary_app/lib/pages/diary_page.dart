import 'package:flutter/material.dart';
import '../services/diary_service.dart';
import '../models/diary_entry.dart';
import '../widgets/create_entry_dialog.dart';
import '../widgets/view_entry_dialog.dart';
import '../services/auth_service.dart';
import '../widgets/sections/top_section.dart';
import '../widgets/sections/middle_section.dart';
import '../widgets/sections/bottom_section.dart';
import '../pages/agenda_page.dart';

class DiaryPage extends StatefulWidget {
  final AuthService authService;
  final DiaryService diaryService;

  const DiaryPage({
    super.key,
    required this.authService,
    required this.diaryService,
  });

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
      builder: (context) => const CreateEntryDialog(),
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
    final screenHeight = MediaQuery.of(context).size.height;
    final safeAreaVertical = MediaQuery.of(context).padding.top +
        MediaQuery.of(context).padding.bottom;
    final availableHeight = screenHeight - safeAreaVertical;
    final topSectionHeight = availableHeight * 0.2;

    return Scaffold(
      body: SafeArea(
        child: Container(
          constraints: BoxConstraints(
            minHeight: availableHeight,
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage("assets/background_main.webp"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.4),
                BlendMode.dstATop,
              ),
            ),
          ),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: availableHeight,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: topSectionHeight,
                    child: TopSection(
                      userName: _userName,
                      onLogout: _logout,
                      onNavigateToCalendar: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AgendaPage()),
                        );
                      },
                    ),
                  ),
                  MiddleSection(
                    entries: _entries,
                    createEntry: _createEntry,
                    viewEntry: _viewEntry,
                  ),
                  BottomSection(moodData: _moodData),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
