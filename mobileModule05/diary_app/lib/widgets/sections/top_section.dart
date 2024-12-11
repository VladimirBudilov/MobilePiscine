import 'package:flutter/material.dart';

class TopSection extends StatelessWidget {
  final String userName;
  final VoidCallback onLogout;
  final VoidCallback onNavigateToCalendar;

  const TopSection({
    super.key,
    required this.userName,
    required this.onLogout,
    required this.onNavigateToCalendar,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(135, 103, 190, 248).withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              userName.length > 14
                  ? "${userName.substring(0, 12)}..."
                  : userName,
              style: const TextStyle(
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
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                  child: const Text('Calendar'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onLogout,
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                  child: const Text('Logout'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
