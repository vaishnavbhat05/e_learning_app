import '/screens/main_page.dart';
import '/screens/chapters/chapter_tab_bar.dart';
import 'package:flutter/material.dart';
import '/screens/lessons/lessons_tests_screen.dart';


double currentProgress = 50;
double normalizedProgress = (currentProgress / 100).clamp(0.0, 1.0);

class ChapterScreen extends StatelessWidget {
  const ChapterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.grey[100],
          elevation: 0,
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
                    builder: (context) =>
                        MainPage(index: 1), // Navigate to Profile tab
                  ),
                );
              },
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Biology',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              const ChapterTabBar(),
              const SizedBox(height: 30),
              // Lesson Cards
              Stack(
                clipBehavior:
                    Clip.none, // Prevent clipping of the downward icon
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildLessonCard('Introduction To Biology',
                            Colors.green[100]!, Icons.eco),
                        const SizedBox(width: 10),
                        _buildLessonCard('Morphology of Flowering Plants',
                            Colors.yellow[100]!, Icons.science),
                        const SizedBox(width: 10),
                        _buildLessonCard('Biological Classification',
                            Colors.pink[100]!, Icons.lightbulb),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: -16, // Moves the container outside
                    left: 70, // Adjust this for horizontal positioning
                    child: ClipPath(
                      clipper: TriangleClipper(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Lesson Progress
              _buildLessonProgressCard(
                  title: 'ANIMAL NUTRITION',
                  lessonNumber: 1,
                  topics: [
                    _buildTopic(
                        'Food Substances', 'Classes and sources.', true),
                    _buildTopic(
                        'Balanced Diet', 'Sources of food substance.', true),
                    _buildTopic(
                        'Food Test', 'Malnutrition and its effects.', false),
                    _buildTopic('Digestive Enzymes',
                        'Effects of pH, temperature.', false),
                  ],
                  isCurrentContent: true,
                  context: context),
              const SizedBox(height: 25),
              _buildLessonProgressCard(
                  title: 'PLANT NUTRITION',
                  lessonNumber: 2,
                  topics: [
                    _buildTopic('Photosynthesis', 'Light reactions.', false),
                    _buildTopic(
                        'Mineral Absorption', 'Nutrient uptake.', false),
                  ],
                  isCurrentContent: false,
                  context: context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLessonCard(String title, Color color, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Container(
        width: 155,
        height: 175,
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top container (reduced height)
            Container(
              height: 100, // Reduced height for the top container
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Align(
                alignment: Alignment.center, // Centering the icon
                child: Icon(
                  icon, // Dynamic icon
                  size: 50, // Fixed size for the icon
                  color: Colors.green, // Icon color
                ),
              ),
            ),
            // Bottom white container (increased height)
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                    ), // Center the title text
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonProgressCard(
      {required String title,
      required int lessonNumber,
      required List<Widget> topics,
      required bool isCurrentContent,
      required BuildContext context}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LessonTestScreen(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Stack(
                  alignment: Alignment.center, // Center the circular progress indicator
                  children: [
                    Transform.rotate(
                      angle: 3.1,
                      child: CircularProgressIndicator(
                        value: normalizedProgress, // Ensure value is between 0.0 and 1.0
                        strokeWidth: 3, // Adjust stroke width to match your design
                        color: Colors.green,
                        backgroundColor: Colors.grey[200],
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 14),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '$title    ',
                        style: TextStyle(
                          fontSize: 12,
                          color: isCurrentContent
                              ? Colors.blue
                              : Colors
                                  .grey, // Change color to blue for the current content
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: 'Lesson $lessonNumber',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ), // Add some spacing between the title and the line
            Padding(
              padding: const EdgeInsets.only(
                  left:
                      18.0), // Align the line to the right, matching the topic
              child: Container(
                width: 2, // Thickness of the line
                height: 25, // Height of the line below the dot
                color: Colors.grey[300], // Line color
              ),
            ), // Add some space between the line and the topics
            ...topics,
          ],
        ),
      ),
    );
  }

  Widget _buildTopic(String title, String subtitle, bool isCompleted) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              const SizedBox(height: 7),
              // Conditionally show the check icon or the dot container
              isCompleted
                  ? const Icon(
                      Icons.check, // Check icon for completed topic
                      color: Colors.green, // Green color for the check icon
                      size: 18, // Icon size
                    )
                  : Icon(
                      Icons.circle_sharp,
                      size: 12,
                      color: Colors.grey[300],
                    ),
              const SizedBox(height: 5),
              // Line below the dot/check icon
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  width: 2, // Thickness of the line
                  height: 40, // Height of the line below the dot/check icon
                  color: Colors.grey[300], // Line color
                ),
              ),
            ],
          ),
          const SizedBox(width: 10), // Space between the dot/check and text
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
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

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    // Start from top left
    path.lineTo(0, 0);
    // Go to top right
    path.lineTo(size.width * 1,0);  // Increase the width for a larger base
    // Go to bottom center (reduce height for a smaller triangle)
    path.lineTo(size.width / 2, size.height / 2);  // Smaller height
    path.close(); // Close the path (back to the starting point)
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false; // No need to reclip
  }
}

