import 'package:e_learning_app/screens/tests/test_screen.dart';
import 'package:flutter/material.dart';

class TestQuestionsScreen extends StatelessWidget {
  const TestQuestionsScreen({super.key});

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
                    builder: (context) => const TestScreen(),
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
          const SizedBox(width: 160,),
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
              child: ListView.builder(
                itemCount: 7,
                itemBuilder: (context, index) {
                  final questionText = [
                    "Where is the majority of ATP’s energy stored?",
                    "How much energy is potentially released from an ATP molecule?",
                    "ATP formation is best described by which of the following statements?",
                    "Formation is best described by which of the following statements?",
                    "Which of the following statements about photosynthesis is FALSE?",
                    "How does photosynthesis occur?",
                    "Which of the following is a TRUE statement regarding the energy-fixing reactions of photosynthesis?"
                  ][index];
                  final isAttempted =
                      [true, true, false, true, true, false, true][index];
                  return Padding(
                    padding: const EdgeInsets.only(
                        bottom: 30.0), // Increased vertical spacing
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TestScreen(),
                          ),
                        );
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${index + 1}.',
                            style: TextStyle(
                              fontSize: 20,
                              color: isAttempted ? Colors.blue : Colors.black,
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
                              style: TextStyle(
                                fontSize: 21,
                                color: isAttempted ? Colors.blue : Colors.black,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
