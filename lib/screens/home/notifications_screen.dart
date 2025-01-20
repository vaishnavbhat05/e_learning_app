import 'package:e_learning_app/screens/main_page.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> subjects = [
    {'name': 'Complete the test!', 'description': 'Study of matter and energy,Study of matter and energy,Study of matter and energy', 'time': DateTime.now().subtract(const Duration(hours: 1))},
    {'name': 'Hurry up!', 'description': 'Study of living organisms,Study of living organisms,Study of living organisms', 'time': DateTime.now().subtract(const Duration(minutes: 5))},
    {'name': 'Hurray!', 'description': 'Study of living organisms', 'time': DateTime.now().subtract(const Duration(seconds: 30))},
    {'name': 'Test completed!', 'description': 'Test has been completed for the day.', 'time': DateTime.now().subtract(const Duration(days: 1))},
  ];

  NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
              child: IconButton(
                onPressed: () {Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MainPage()),
                );},
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.blue,
                  size: 30,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20), // Padding around the body content
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView.builder(
                  itemCount: subjects.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(6),
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0.1, // Removes the shadow
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  subjects[index]['name'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                _getCustomTimeFormat(subjects[index]['time']),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black26,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            subjects[index]['description'],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          onTap: () {
                            // Handle subject click
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  String _getCustomTimeFormat(DateTime time) {
    final difference = DateTime.now().difference(time);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}hr ago';
    } else if (difference.inDays == 1) {
      return _formatTime(time);
    } else {
      return _formatTime(time);
    }
  }

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'pm' : 'am';
    final formattedHour = hour > 12 ? hour - 12 : hour;
    return '$formattedHour:$minute$period';
  }
}
