import 'package:e_learning_app/screens/main_page.dart';
import 'package:e_learning_app/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';

class ResultDetailsScreen extends StatelessWidget {
  const ResultDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
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
                    builder: (context) => MainPage(index: 2), // Navigate to Profile tab
                  ),
                );
              },
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              Row(
                children: [
                  const Text(
                    "Results",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 34,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 30,
                    width: 65,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.transparent,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "All",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () async {
                            final selectedValue = await showMenu<String>(
                                context: context,
                                position: const RelativeRect.fromLTRB(
                                    100, 150, 20, 0),
                                items: [
                                  const PopupMenuItem<String>(
                                    value: 'Subject',
                                    child: ListTile(
                                      leading: Icon(Icons.subject,
                                          color: Colors.blue),
                                      title: Text("Subject"),
                                    ),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'Date',
                                    child: ListTile(
                                      leading: Icon(Icons.date_range,
                                          color: Colors.blue),
                                      title: Text("Date"),
                                    ),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'Top Scores',
                                    child: ListTile(
                                      leading:
                                          Icon(Icons.star, color: Colors.blue),
                                      title: Text("Top Scores"),
                                    ),
                                  ),
                                ],
                                // Apply a circular rounded shape
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                // Optional: Set the popup background color
                                elevation: 4,
                                color: Colors.white);

                            // Handle the selected value
                            if (selectedValue != null) {
                              if (selectedValue == 'Subject') {
                                // Handle Subject filter logic
                              } else if (selectedValue == 'Date') {
                                // Handle Date filter logic
                              } else if (selectedValue == 'Top Scores') {
                                // Handle Top Scores filter logic
                              }
                            }
                          },
                          child: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.blue,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    _buildResultCard(
                      subject: "BIOLOGY",
                      lesson: "Lesson 1",
                      title: "Animal Nutrition: Food Chain",
                      rightAnswers: 35,
                      totalQuestions: 50,
                      score: 75,
                      scoreColor: Colors.green,
                    ),
                    _buildResultCard(
                      subject: "BIOLOGY",
                      lesson: "Lesson 2",
                      title: "Photosynthesis",
                      rightAnswers: 40,
                      totalQuestions: 50,
                      score: 90,
                      scoreColor: Colors.green,
                    ),
                    _buildResultCard(
                      subject: "PHYSICS",
                      lesson: "Lesson 1",
                      title: "Introduction to Physics",
                      rightAnswers: 18,
                      totalQuestions: 50,
                      score: 20,
                      scoreColor: Colors.red,
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

  Widget _buildResultCard({
    required String subject,
    required String lesson,
    required String title,
    required int rightAnswers,
    required int totalQuestions,
    required int score,
    required Color scoreColor,
  }) {
    return SizedBox(
      width: 200,
      height: 270,
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 20.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    subject,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    lesson,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.black,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Right Answers",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "$rightAnswers",
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "Questions attempted",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "$rightAnswers of $totalQuestions",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 90,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '$score',
                          style: TextStyle(
                            fontSize: 50,
                            color: scoreColor, // Text color
                          ),
                        ),
                        TextSpan(
                          text: '%',
                          style: TextStyle(
                            fontSize: 30,
                            color: scoreColor, // Different color for %
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
