import 'package:flutter/material.dart';

import '../chapters/chapter_screen.dart';

class SubjectsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> subjects = [
    {'icon': Icons.science, 'name': 'Physics'},
    {'icon': Icons.bubble_chart, 'name': 'Biology'},
    {'icon': Icons.calendar_month, 'name': 'Chemistry'},
    {'icon': Icons.calculate, 'name': 'Mathematics'},
    {'icon': Icons.map, 'name': 'Geography'},
    {'icon': Icons.palette, 'name': 'Art and Culture'},
  ];

  SubjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20), // Padding around the body content
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox( height: 40,),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Subjects',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 15,),
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
                        elevation: 0.1,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 25),
                          leading: Icon(subjects[index]['icon'], size: 40),
                          title: Text(
                            subjects[index]['name'],
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ChapterScreen(),
                              ),
                            );
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
}
