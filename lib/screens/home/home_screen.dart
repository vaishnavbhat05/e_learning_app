import 'study_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Spacer(),
            Icon(Icons.notifications_none, color: Colors.black38,size: 28,),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Hi, Prallav',
                style: TextStyle(fontSize: 32, color: Colors.black,fontWeight: FontWeight.bold),
              ),
            ),
            const Center(
              child: Text(
                'What would you like to study today?',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
            const Center(
                child: Text(
                  'You can search below.',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),

            ),
            const SizedBox(height: 50),
            TextField(
              decoration: InputDecoration(
                suffixIcon: const Icon(Icons.search,color: Colors.blue,),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 50),
            const Text(
              'CURRENTLY STUDYING',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.black54),
            ),
            const SizedBox(height: 50),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    StudyCard(
                      subject: 'Geography',
                      title: 'Elements of Physical Geography',
                      progress: 86,
                      color: Colors.pink.shade100,
                    ),
                    StudyCard(
                      subject: 'Mathematics',
                      title: 'Pairs of Angles in Two Words',
                      progress: 60,
                      color: Colors.blue.shade100,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
