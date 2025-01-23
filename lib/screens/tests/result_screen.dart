import 'dart:math';
import 'package:e_learning_app/screens/lessons/lessons_tests_screen.dart';
import 'package:e_learning_app/screens/tests/test_screen.dart';
import 'package:flutter/material.dart';

double currentProgress = 50;
double normalizedProgress = (currentProgress / 100).clamp(0.0, 1.0);

Alignment calculateCheckMarkPosition(double progress) {
  double angle = pi * 2 * progress + (pi / 2);
  double radius = 1.4;
  double x = radius * cos(angle);
  double y = radius * sin(angle);
  return Alignment(x, y);
}

class ResultScreen extends StatelessWidget {
  final bool isTimeout;

  const ResultScreen({super.key, required this.isTimeout});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          actions: [
            _buildCloseButton(context),
            const Spacer(),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 100),
                _buildProgressIndicator(),
                const SizedBox(height: 140),
                _buildTitleText(),
                const SizedBox(height: 20),
                _buildMessageText(),
                const SizedBox(height: 120),
                _buildActionButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LessonTestScreen()),
          );
        },
        icon: const Icon(
          Icons.close,
          color: Colors.blue,
          size: 40,
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return SizedBox(
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
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${currentProgress.toInt()}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const TextSpan(
                      text: '%',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const Text('35 of 50', style: TextStyle(fontSize: 15, color: Colors.grey)),
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
    );
  }

  Widget _buildScoreContainer() {
    return Container(
      width: 110,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('+20', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
          SizedBox(width: 5),
          Icon(Icons.star, color: Colors.green, size: 25),
        ],
      ),
    );
  }

  Widget _buildTitleText() {
    return Text(
      isTimeout ? 'Oooops!' : 'Bravo!',
      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildMessageText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        isTimeout
            ? 'You ran out of time.\nYour test has been submitted by default.'
            : 'You are just 15 correct questions away from 100%. You can do it.',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 22, color: Colors.grey),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return SizedBox(
      width: 350,
      height: 60,
      child: ElevatedButton(

        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => isTimeout ? const LessonTestScreen() : const TestScreen(),),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 5,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isTimeout ?
            const SizedBox(width: 80)
                :
            const SizedBox(width: 110),
            Text(
              isTimeout ? 'Take a New Test' : 'Try Again',
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            isTimeout ?
            const SizedBox(width: 60)
            :
            const SizedBox(width: 90),
            CircleAvatar(
              backgroundColor: Colors.blue[700],
              radius: 12,
              child: const Icon(Icons.arrow_right_alt_sharp,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
