import 'dart:math';
import 'package:e_learning_app/screens/lessons/chapter_details_screen.dart';
import 'package:e_learning_app/screens/tests/provider/test_screen_provider.dart';
import 'package:e_learning_app/screens/tests/test_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Alignment calculateCheckMarkPosition(double progress) {
  double angle = pi * 2 * progress + (pi / 2);
  double radius = 1.4;
  double x = radius * cos(angle);
  double y = radius * sin(angle);
  return Alignment(x, y);
}
class ResultScreen extends StatefulWidget {
  final int lessonId;
  final int chapterId;
  final int testId;
  final int topicId;
  final int totalTime;
  final int subjectId;
  final String subjectName;
  final bool isTimeout;

  const ResultScreen({
    super.key,
    required this.topicId,
    required this.chapterId,
    required this.lessonId,
    required this.testId,
    required this.totalTime,
    required this.subjectId,
    required this.subjectName,
    required this.isTimeout,
  });

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool isTimeout = false;

  @override
  void initState() {
    super.initState();
    _loadTimeoutStatus();
  }

  Future<void> _loadTimeoutStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isTimeout = prefs.getBool('isTimeout') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChapterDetailsScreen(topicId: widget.topicId,chapterId:widget.chapterId,lessonId:widget.lessonId,subjectId: widget.subjectId,subjectName: widget.subjectName,)),
                  );
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.blue,
                  size: 40,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
        body: Consumer<TestScreenProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.errorMessage.isNotEmpty) {
              return Center(child: Text(provider.errorMessage));
            }
            Object securedPercentage = provider.testResult?.securedMarksInPercentage ?? '0%';

            String securedPercentageStr = securedPercentage.toString().replaceAll('%', '').trim();
            double normalizedProgress = (double.tryParse(securedPercentageStr) ?? 0.0) / 100.0;

            normalizedProgress = normalizedProgress.clamp(0.0, 1.0);

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 100),
                    SizedBox(
                      width: 180,
                      height: 180,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: Transform.rotate(
                              angle: 3.14 / 1,
                              child: CircularProgressIndicator(
                                value: normalizedProgress,
                                strokeWidth: 20,
                                color: Colors.green,
                                backgroundColor: Colors.grey[200],
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // RichText(
                              //   text: TextSpan(
                              //     children: [
                              //       TextSpan(
                              //         text: '${provider.testResult?.securedMarksInPercentage}',
                              //         style: const TextStyle(
                              //           fontSize: 32,
                              //           fontWeight: FontWeight.bold,
                              //           color: Colors.black,
                              //         ),
                              //       ),
                              //       const TextSpan(
                              //         text: '%',
                              //         style: TextStyle(
                              //           fontSize: 24,
                              //           fontWeight: FontWeight.bold,
                              //           color: Colors.black,
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              Text(
                                '${provider.testResult?.securedMarksInPercentage}',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 10), // Space between percentage and X of Y text
                              Text(
                                '${provider.testResult?.totalNumberOfQuestionsAttempted ?? 0} of ${provider.testResult?.totalNumbersOfQuestions ?? 0}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: const Alignment(0, 1.3),
                            child: _buildScoreContainer(),
                          ),
                          if (normalizedProgress >= 0.1 && normalizedProgress <= 0.9)
                            Align(
                              alignment: calculateCheckMarkPosition(normalizedProgress),
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 140),
                    Text(
                      provider.testResult?.remarksComment ??
                          'No remarks available',
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        provider.testResult?.remarkSubComment ??
                            'No additional comments.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 22, color: Colors
                            .grey),
                      ),
                    ),
                    const SizedBox(height: 120),
                    SizedBox(
                      width: 350,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              isTimeout
                                  ? ChapterDetailsScreen(chapterId: widget.chapterId,lessonId:widget.lessonId,subjectId: widget.subjectId,subjectName: widget.subjectName, topicId: widget.topicId,)
                                  : TestScreen(
                                topicId: widget.topicId,
                                chapterId: widget.chapterId,
                                lessonId: widget.lessonId,
                                  testId: widget.testId,
                                  totalTime: widget.totalTime,subjectName: widget.subjectName,
                                subjectId: widget.subjectId,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            isTimeout
                                ? const SizedBox(width: 80)
                                : const SizedBox(width: 110),
                            Text(
                              isTimeout ? 'Take a New Test' : 'Try Again',
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white),
                            ),
                            isTimeout
                                ? const SizedBox(width: 60)
                                : const SizedBox(width: 90),
                            CircleAvatar(
                              backgroundColor: Colors.blue[700],
                              radius: 12,
                              child: const Icon(Icons.arrow_right_alt_sharp,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  Widget _buildScoreContainer() {
    return Container(
      width: 80,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text('+20', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
          SizedBox(width: 5),
          Icon(Icons.star, color: Colors.green, size: 25),
        ],
      ),
    );
  }
}
