import '../home/notifications_screen.dart';
import '../home/currently_studying_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Spacer(),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationsScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.notifications_none_outlined,
                        color: Colors.black38, size: 36),
                  ),
                  Positioned(
                    right: 10,
                    top: 9,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Hi, Prallav',
                    style: TextStyle(
                        fontSize: 32,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'What would you like to study today?',
                    style: TextStyle(fontSize: 22, color: Colors.black54),
                  ),
                ),
                const Center(
                  child: Text(
                    'You can search below.',
                    style: TextStyle(fontSize: 22, color: Colors.black54),
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: double.infinity,
                    height: 70,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding:
                              EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // TODO: Add API call logic here
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: const Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text(
                    'CURRENTLY STUDYING',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    height: 320,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        StudyCard(
                          subject: 'Geography',
                          title: 'Elements of Physical Geography',
                          progress: 86,
                          color: Colors.pink.shade200,
                          icon: Icons.map,
                        ),
                        const SizedBox(width: 6),
                        StudyCard(
                          subject: 'Mathematics',
                          title: 'Pairs of Angles in Two Words',
                          progress: 60,
                          color: Colors.blue.shade200,
                          icon: Icons.calculate,
                        ),
                        StudyCard(
                          subject: 'Biology',
                          title: 'Plants and Animals ',
                          progress: 76,
                          color: Colors.teal.shade200,
                          icon: Icons.bubble_chart,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
