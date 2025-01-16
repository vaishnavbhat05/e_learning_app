import 'package:flutter/material.dart';
class StudyCard extends StatelessWidget {
  final String subject;
  final String title;
  final int progress;
  final Color color;

  const StudyCard({super.key,
    required this.subject,
    required this.title,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subject.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          LinearProgressIndicator(
            value: progress / 100,
            backgroundColor: Colors.grey.shade300,
            color: Colors.green,
          ),
          const SizedBox(height: 8),
          Text('$progress% Completed'),
        ],
      ),
    );
  }
}
