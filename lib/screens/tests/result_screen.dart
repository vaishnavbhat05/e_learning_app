import 'package:e_learning_app/screens/lessons/lessons_tests_screen.dart';
import 'package:e_learning_app/screens/tests/test_screen.dart';
import 'package:flutter/material.dart';

double currentProgress = 75;
double normalizedProgress = (currentProgress / 125).clamp(0.0, 1.0);

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
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
                        builder: (context) => const LessonTestScreen()),
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
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 80,
                ),
                SizedBox(
                  width: 210, // Adjust to set the width of the circle
                  height: 210, // Adjust to set the height of the circle
                  child: Stack(
                    alignment:
                    Alignment.center, // Center everything inside the circle
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: Transform.rotate(
                          angle: 3.14 / 1,
                          child: CircularProgressIndicator(
                            value:
                            normalizedProgress, // Ensure value is between 0.0 and 1.0
                            strokeWidth: 20,
                            color: Colors.green,
                            backgroundColor: Colors.grey[200],
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize
                            .min, // Adjust column size to fit content
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: '75',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black, // Text color
                                  ),
                                ),
                                TextSpan(
                                  text: '%',
                                  style: TextStyle(
                                    fontSize: 24, // Smaller font size for %
                                    fontWeight: FontWeight.bold,
                                    color:
                                    Colors.black, // Different color for %
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            '35 of 50',
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                        ],
                      ),
                      Align(
                        alignment: const Alignment(0,
                            1.3), // Position the container at the bottom of the circle
                        child: Container(
                          width: 100,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white, // Background color
                            borderRadius:
                            BorderRadius.circular(25), // Round corners
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '+20',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green, // Text color
                                ),
                              ),
                              SizedBox(width: 5,),
                              Icon(Icons.star,color: Colors.green,size: 25,)
                            ],
                          ),
                        ),
                      ),
                      // Check Container that appears when progress reaches 75%
                      if (normalizedProgress >= 0.6) // Only show when progress is 75% or more
                        Align(
                          alignment: const Alignment(0.8, -1.05), // Position it above the circle
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.green, // Background color for check icon container
                              borderRadius: BorderRadius.circular(25), // Round corners
                            ),
                            child: const Icon(
                              Icons.check, // Check icon
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 140),
                const Text(
                  'Bravo!',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'You are just 15 correct questions away from 100%. You can do it.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 150),
                SizedBox(
                  height: 60, // Increased height
                  width: 360, // Reduced width
                  child: Material(
                    elevation: 6, // Elevation for shadow
                    shadowColor: Colors.blue[400], // Shadow color
                    borderRadius: BorderRadius.circular(
                        12), // Matches button border radius
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TestScreen(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.blue, // Blue background
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side:
                        const BorderSide(color: Colors.blue), // Blue border
                      ),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.start, // Centers content
                        children: [
                          const SizedBox(width: 120),
                          const Text(
                            'Try Again',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          const SizedBox(width: 80),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
