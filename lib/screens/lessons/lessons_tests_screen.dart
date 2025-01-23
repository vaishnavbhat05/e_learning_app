import 'dart:math';

import 'package:e_learning_app/screens/lessons/provider/lesson_test_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/model/test.dart';
import '../chapters/chapter_screen.dart';
import '../tests/test_screen.dart';
import 'lesson_details_screen.dart';


class LessonTestScreen extends StatefulWidget {
  const LessonTestScreen({super.key});

  @override
  _LessonTestScreenState createState() => _LessonTestScreenState();
}

class _LessonTestScreenState extends State<LessonTestScreen> {
  bool showLessons = true;
  int lessonId = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.blue,
              size: 30,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChapterScreen(),
                ),
              );
            },
          ),
        ),
        title: const Text(
          "INTRODUCTION TO BIOLOGY",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Animal Nutrition:',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Food Chain',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Lesson 1',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              height: 50,
              width: 370, // Ensure it takes full width or adjust as needed
              decoration: BoxDecoration(
                color: Colors.white, // Background color for the container
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTab("LESSONS", showLessons, () {
                    setState(() {
                      showLessons = true; // Show lessons
                    });
                  }),
                  const VerticalDivider(
                    color: Colors.grey, // Divider color
                    width: 100, // Width of the divider
                    thickness: 0.2, // Divider thickness
                  ),
                  _buildTab("TESTS", !showLessons, () {
                    setState(() {
                      showLessons = false; // Show tests
                    });
                    // Trigger API call when "TESTS" is selected
                    Provider.of<LessonTestProvider>(context, listen: false)
                        .fetchTests(lessonId); // Pass the lessonId here
                  }),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child:
              showLessons ? _buildLessonsContent() : _buildTestsContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, bool isSelected, VoidCallback onTap) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: isSelected
          ? BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      )
          : null,
      child: GestureDetector(
        onTap: onTap,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
                color: isSelected ? Colors.blue : Colors.grey.shade500,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildLessonsContent() {
    return ListView(
      children: [
        _buildLessonCard(
          "Food Substances",
          "Classes and sources.",
          Colors.yellow.shade300,
          "BEGINNER",
        ),
        _buildLessonCard(
          "Balanced Diet",
          "Sources of food substance.",
          Colors.red.shade300,
          "INTERMEDIATE",
        ),
        _buildLessonCard(
          "Food Test",
          "Malnutrition and its effects.",
          Colors.blue.shade300,
          "BEGINNER",
        ),
        _buildLessonCard(
          "Digestive Enzymes",
          "Effects of pH, temperature.",
          Colors.green.shade300,
          "BEGINNER",
        ),
      ],
    );
  }

  Widget _buildLessonCard(
      String title, String description, Color color, String level) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LessonDetailScreen(title: title),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20), // Rounded corners
          border: Border.all(
            color: Colors.white, // Light border color
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200, // Subtle shadow color
              blurRadius: 8, // Slight blur for shadow
              offset: const Offset(0, 4), // Shadow offset
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 20), // Increased padding inside the card
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30, // Increased size of the avatar
                backgroundColor: color,
                child: const Icon(Icons.eco,
                    color: Colors.white, size: 32), // Larger icon
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '$level\n\n', // Display the level first
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16, // Larger font size for level
                              color: Colors.blue, // Level in blue color
                            ),
                          ),
                          TextSpan(
                            text: title, // Display the title below
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22, // Larger font size for title
                              color: Colors.black, // Title in black color
                            ),
                          ),
                        ],
                      ),
                    ), // Increased space between title and description
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 18, // Larger font size for description
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTestsContent() {
    return Consumer<LessonTestProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.errorMessage != null) {
          return Center(child: Text(provider.errorMessage!));
        }

        return ListView.builder(
          itemCount: provider.tests.length,
          itemBuilder: (context, index) {
            final test = provider.tests[index];
            Random random = Random(index); // Use index to fix the color for each item
            Color randomColor = Color.fromARGB(
              255,
              random.nextInt(150) + 50, // Random Red value (0-255)
              random.nextInt(150) + 50, // Random Green value (0-255)
              random.nextInt(150) + 50, // Random Blue value (0-255)
            );

            return _buildTestCard(
              test.level,
              test.heading,
              test.subHeading,
              "${test.totalTime} minutes to complete",
              randomColor, // Pass the fixed random color
              true,
            );
          },
        );
      },
    );
  }

  Widget _buildTestCard(
      String level, String title, String subtitle, String testDescription, Color color, bool isCurrentContent) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // Rounded corners
        border: Border.all(
          color: Colors.white, // Light border color
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200, // Subtle shadow color
            blurRadius: 8, // Slight blur for shadow
            offset: const Offset(0, 4), // Shadow offset
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20), // Padding inside the card
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color,
                  radius: 35,
                  child: const Icon(Icons.eco, color: Colors.white, size: 32), // Icon
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        level,
                        style: const TextStyle(
                            color: Colors.blue, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        title,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold,),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Subtitle in the middle
            Text(
              subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 18),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 20),
            // Button at the bottom
            SizedBox(
              height: 60, // Button height
              width: 320, // Button width
              child: Material(
                shadowColor: Colors.blue[300], // Shadow color
                borderRadius: BorderRadius.circular(10), // Matches button border radius
                child: OutlinedButton(
                  onPressed: isCurrentContent
                      ? () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TestScreen(),
                      ),
                    );
                  }
                      : null, // Disable button if not current content
                  style: OutlinedButton.styleFrom(
                    backgroundColor: isCurrentContent
                        ? Colors.blue
                        : Colors.grey, // Background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Button rounded edges
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start, // Aligns content
                    children: [
                      const SizedBox(width: 90),
                      const Text(
                        'Begin Test',
                        style: TextStyle(
                          color: Colors.white, // Text remains white
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(width: 70),
                      CircleAvatar(
                        backgroundColor: isCurrentContent
                            ? Colors.blue[700]
                            : Colors.blue.withOpacity(0.2), // Slightly shaded blue for icon
                        radius: 12,
                        child: const Icon(Icons.arrow_right_alt_sharp, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
