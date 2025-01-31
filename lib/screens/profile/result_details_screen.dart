import 'package:e_learning_app/screens/main_page.dart';
import 'package:e_learning_app/screens/profile/provider/result_details_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class ResultDetailsScreen extends StatefulWidget {
  const ResultDetailsScreen({super.key});

  @override
  State<ResultDetailsScreen> createState() => _ResultDetailsScreenState();
}

class _ResultDetailsScreenState extends State<ResultDetailsScreen> {
  String selectedSubject = "All"; // Default to show all subjects

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
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
        body: Consumer<ResultProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.results == null || provider.results!.isEmpty) {
              return const Center(child: Text('No results available.'));
            }

            // Filter results based on selected subject
            final filteredResults = selectedSubject == "All"
                ? provider.results!
                : provider.results!.where((result) => result.subjectName == selectedSubject).toList();

            return Padding(
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
                      SizedBox(
                        width: selectedSubject.length * 10.0 + 40,
                        child: PopupMenuButton<String>(
                          onSelected: (value) {
                            setState(() {
                              selectedSubject = value;
                            });
                          },
                          itemBuilder: (context) => [
                            for (var subject in [
                              "All", "Physics", "Biology", "Chemistry", "Mathematics",
                              "Geography", "Art and Culture", "English", "History",
                              "Computer Science", "Economics", "Political Science",
                              "Sociology", "Physical Education"
                            ])
                              PopupMenuItem<String>(
                                value: subject,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(subject),
                                ),
                              ),
                          ],
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.transparent,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  selectedSubject,
                                  style: const TextStyle(color: Colors.black, fontSize: 16),
                                ),
                                const SizedBox(width: 10,),
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.blue,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: filteredResults.isEmpty
                        ? const Center(child: Text("No results for this subject."))
                        : ListView.builder(
                      itemCount: filteredResults.length,
                      itemBuilder: (context, index) {
                        final result = filteredResults[index];
                        return buildResultCard(
                          subject: result.subjectName,
                          lesson: result.lessonIndex,
                          title: result.lessonName,
                          rightAnswers: result.correctAnsweredQuestion,
                          totalQuestions: result.totalQuestion,
                          score: result.securedMarks,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildResultCard({
    required String subject,
    required int lesson,
    required String title,
    required int rightAnswers,
    required int totalQuestions,
    required int score,
  }) {
    Color color = _getStatColor(score);
    return Card(
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
                  'lesson $lesson',
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
                const SizedBox(width: 83),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '$score',
                        style: TextStyle(
                          fontSize: 50,
                          color: color,
                        ),
                      ),
                      TextSpan(
                        text: '%',
                        style: TextStyle(
                          fontSize: 30,
                          color: color,
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
    );
  }

  Color _getStatColor(int value) {
    if (value < 30) {
      return Colors.red.shade600;
    } else if (value >= 30 && value <= 50) {
      return Colors.orange.shade600;
    } else if (value > 50 && value <= 75) {
      return Colors.yellow.shade600;
    } else {
      return Colors.green.shade600;
    }
  }
}
