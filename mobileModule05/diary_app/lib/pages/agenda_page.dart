import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../models/diary_entry.dart';
import '../widgets/diary_entry.dart';
import '../../services/auth_service.dart';
import '../../services/diary_service.dart';
import '../widgets/view_entry_dialog.dart';

class AgendaPage extends StatefulWidget {

  const AgendaPage({
    super.key,
  });

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  late DateTime _selectedDate;
  List<DiaryEntry> _allEntries = [];
  List<DiaryEntry> _filteredEntries = [];

  final AuthService _authService = AuthService();
  final DiaryService _diaryService = DiaryService();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _filterEntriesForDate();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final user = _authService.currentUser;
    if (user != null) {
      final entries = await _diaryService.fetchEntries(user.uid);
      setState(() {
        _allEntries = entries;
        print('Loaded entries: $_allEntries');
        _filterEntriesForDate();
      });
    }
  }

  void _filterEntriesForDate() {
    setState(() {
      _filteredEntries = _allEntries
          .where((entry) =>
              DateFormat('yyyy-MM-dd').format(DateTime.parse(entry.date)) ==
              DateFormat('yyyy-MM-dd').format(_selectedDate))
          .toList();
    });
  }

  void _viewEntry(DiaryEntry entry) {
    showDialog(
      context: context,
      builder: (context) => ViewEntryDialog(
        entry: entry,
        diaryService: _diaryService,
        authService: _authService,
        onUpdate: () {
          _loadEntries();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: TableCalendar(
              firstDay: DateTime.utc(2000),
              lastDay: DateTime.utc(2100),
              focusedDay: _selectedDate,
              calendarFormat: CalendarFormat.month,
              selectedDayPredicate: (day) =>
                  DateFormat('yyyy-MM-dd').format(day) ==
                  DateFormat('yyyy-MM-dd').format(_selectedDate),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDate = selectedDay;
                  _filterEntriesForDate();
                });
              },
              availableCalendarFormats: const {
                CalendarFormat.month: 'Month',
              },
              calendarStyle: const CalendarStyle(
                todayDecoration:
                    BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                selectedDecoration:
                    BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
              ),
            ),
          ),
          _filteredEntries.isEmpty
              ? SliverFillRemaining(
                  child: Center(
                    child: const Text(
                      'No entries for this date.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final entry = _filteredEntries[index];
                      return DiaryEntryWidget(
                        entry: entry,
                        onTap: () => _viewEntry(entry),
                      );
                    },
                    childCount: _filteredEntries.length,
                  ),
                ),
        ],
      ),
    );
  }
}
