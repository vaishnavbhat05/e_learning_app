import 'package:e_learning_app/screens/lessons/lessons_tests_screen.dart';
import 'package:e_learning_app/screens/tests/result_screen.dart';
import 'package:e_learning_app/screens/tests/test_questions_screen.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int _selectedOption = -1; // To keep track of the selected option

  Widget _buildOptionCard(String option, String text, int index) {
    bool isSelected = _selectedOption == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOption = index; // Update the selected option
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        width: 360,
        height: 80,
        decoration: BoxDecoration(
          // Highlight selected card
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                isSelected ? Colors.blue : Colors.grey.shade300, // Border color
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 8,
              offset: const Offset(0, 4), // Subtle shadow
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 20,
            ),
            Text(
              option,
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.black45, // Text color
                fontSize: 18,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.black45, // Text color
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TestQuestionsScreen()),
                  );
                },
                icon: const Icon(
                  Icons.insert_page_break_outlined,
                  color: Colors.blue,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 22.0),
                    child: Text(
                      'What does the feet in image below imply?',
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Container(
                    height: 200,
                    width: 360,
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Option cards
              Center(
                child: Column(
                  children: [
                    _buildOptionCard("A.", "Option 1", 0),
                    _buildOptionCard("B.", "Option 2", 1),
                    _buildOptionCard("C.", "Option 3", 2),
                    _buildOptionCard("D.", "Option 4", 3),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.white,
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (BuildContext context) {
                            return Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                    minHeight: 280,
                                    maxWidth: 340), // Limit the height
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Center(
                                      child: Column(
                                        children: [
                                          SizedBox(height: 20,),
                                          Text(
                                            'Submit Test',
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 50, right: 50),
                                            child: Text(
                                              'You have unattempted questions, would you like to submit the test?',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize:
                                                    21, // Slightly smaller text size
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 40),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 60, // Increased height
                                          width: 140, // Reduced width
                                          child: OutlinedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor: Colors
                                                  .transparent, // Transparent background
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              side: const BorderSide(
                                                  color: Colors.blue,
                                                  width: 2), // Blue border
                                            ),
                                            child: const Text(
                                              'No',
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 18),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 30),
                                        SizedBox(
                                          height: 60, // Increased height
                                          width: 140, // Reduced width
                                          child: Material(
                                            elevation:
                                                6, // Elevation for shadow
                                            shadowColor: Colors
                                                .blue[400], // Shadow color
                                            borderRadius: BorderRadius.circular(
                                                15), // Matches button border radius
                                            child: OutlinedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                       const ResultScreen(),
                                                  ),
                                                );
                                              },
                                              style: OutlinedButton.styleFrom(
                                                backgroundColor: Colors
                                                    .blue, // Blue background
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                side: const BorderSide(
                                                    color: Colors
                                                        .blue), // Blue border
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center, // Centers content
                                                children: [
                                                  const SizedBox(width: 8),
                                                  const Text(
                                                    'Yes',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18),
                                                  ),
                                                  const SizedBox(width: 20),
                                                  CircleAvatar(
                                                    backgroundColor:
                                                        Colors.blue[700],
                                                    radius: 12,
                                                    child: const Icon(
                                                        Icons
                                                            .arrow_right_alt_sharp,
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
