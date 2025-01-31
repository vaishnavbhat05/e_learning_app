import 'package:e_learning_app/screens/tests/test_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../screens/tests/provider/test_screen_provider.dart';

class TestQuestionsScreen extends StatefulWidget {
  final int lessonId;
  final int chapterId;
  final int testId;
  final int totalTime;
  final int remainingTime;
  final int subjectId;
  final String subjectName;
  final int topicId;
  const TestQuestionsScreen(
      {super.key,
        required this.chapterId,
        required this.lessonId,
      required this.testId,
      required this.totalTime,
      required this.remainingTime,
      required this.subjectId,
      required this.subjectName,
      required this.topicId});

  @override
  _TestQuestionsScreenState createState() => _TestQuestionsScreenState();
}

class _TestQuestionsScreenState extends State<TestQuestionsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        actions: [
          Padding(
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
                    builder: (context) => TestScreen(
                      chapterId: widget.chapterId,
                      lessonId: widget.lessonId,
                      subjectName: widget.subjectName,
                      subjectId: widget.subjectId,
                      testId: widget.testId,
                      totalTime: widget.totalTime,
                      topicId: widget.topicId,
                    ),
                  ),
                );
              },
            ),
          ),
          const Spacer(),
          const Text(
            'QUESTIONS',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18, // Ensure the title text color is visible
            ),
          ),
          const SizedBox(
            width: 160,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select a question from the below to attempt.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            const Text(
              '(Note: Attempted questions are in blue color)',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 28),
            Expanded(
              child: Consumer<TestScreenProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.errorMessage.isNotEmpty) {
                    return Center(child: Text(provider.errorMessage));
                  }

                  return ListView.builder(
                    itemCount: provider.questionStatements.length,
                    itemBuilder: (context, index) {
                      final questionText = provider.questionStatements[index];
                      // final isAttempted = provider.isAttempted(index);
                      const isAttempted = false;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TestScreen(
                                  topicId: widget.topicId,
                                  chapterId: widget.chapterId,
                                  lessonId: widget.lessonId,
                                  testId: widget.testId,
                                  totalTime: widget.totalTime,
                                  subjectName: widget.subjectName,
                                  subjectId: widget.subjectId,
                                ),
                              ),
                            );
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${index + 1}.',
                                style: const TextStyle(
                                  fontSize: 20,
                                  color:
                                      isAttempted ? Colors.blue : Colors.black,
                                  fontWeight: isAttempted
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Flexible(
                                child: Text(
                                  questionText,
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    fontSize: 21,
                                    color: isAttempted
                                        ? Colors.blue
                                        : Colors.black,
                                    fontWeight: isAttempted
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
