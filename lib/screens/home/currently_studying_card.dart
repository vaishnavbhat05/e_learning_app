import 'package:flutter/material.dart';

class StudyCard extends StatelessWidget {
  final String subject;
  final String title;
  final int progress;
  final Color color;
  final IconData icon;

  const StudyCard({
    super.key,
    required this.subject,
    required this.title,
    required this.progress,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280, // Ensures the card is a square
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 180, // Takes up 40% of the card height
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 80, // Adjust the size of the icon
                color: Colors.white, // Icon color
              ),
            ),
          ),
          Expanded(
            // White background section
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white, // White background for text
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: progress / 100,
                          backgroundColor: Colors.grey.shade300,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$progress%',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
