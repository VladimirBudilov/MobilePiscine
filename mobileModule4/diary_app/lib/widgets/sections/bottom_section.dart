import 'package:flutter/material.dart';
import '../../services/mood_icon_service.dart';

class BottomSection extends StatelessWidget {
  final Map<String, double> moodData;

  const BottomSection({
    Key? key,
    required this.moodData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Mood for the last week',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'StrangeFont',
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 4,
              ),
              itemCount: moodData.length,
              itemBuilder: (context, index) {
                final entry = moodData.entries.elementAt(index);
                final moodIconPath = MoodIconService.moodToIcon(entry.key);
                return Row(
                  children: [
                    Image.asset(
                      moodIconPath,
                      width: 32,
                      height: 32,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.error, color: Colors.red);
                      },
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${entry.value.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
