import 'package:flutter/material.dart';

class TopSection extends StatelessWidget {
  final String userName;
  final VoidCallback onLogout;
  final VoidCallback onNavigateToCalendar;

  const TopSection({
    Key? key,
    required this.userName,
    required this.onLogout,
    required this.onNavigateToCalendar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              userName,
              style: TextStyle(
                fontSize: 40,
                fontFamily: 'StrangeFont',
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: onNavigateToCalendar,
                  child: const Text('Calendar'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    textStyle: TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onLogout,
                  child: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    textStyle: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
