import 'dart:async';
import 'package:e_learning_app/screens/tests/result_screen.dart';
import 'package:e_learning_app/screens/tests/test_questions_screen.dart';
import 'package:flutter/material.dart';

import '../lessons/lessons_tests_screen.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}
class _TestScreenState extends State<TestScreen> {
  int _selectedOption = -1; // To keep track of the selected option
  int currentPage = 1; // Current page
  int totalPages = 4; // Total number of pages
  final PageController _pageController = PageController();
  late Timer _timer;
  int _remainingTime = 10; // Start from 300 seconds (5 minutes)
  bool _modalShown = false; // Track if the submit modal has been shown

  final ValueNotifier<double> _dividerProgress = ValueNotifier<double>(0.0);

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget _buildOptionCard(String option, String text, int index) {
    bool isSelected = _selectedOption == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          // If the same option is clicked again, unselect it
          _selectedOption = isSelected ? -1 : index;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        width: 360,
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.white,
            width: 2, // Border color
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.white, // Subtle shadow
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 20),
            Text(
              option,
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.black45, // Text color
                fontSize: 18,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.black45, // Text color
                fontSize: 18,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
        _dividerProgress.value = _remainingTime / 120;
      } else {
        _timer.cancel();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ResultScreen(isTimeout: true),
          ),
        );// Stop the timer when time is up
      }
    });
  }

  // bool _isSubmitted = false;
  //
  // void _submitTest() {
  //   if (_isSubmitted) return;
  //   _isSubmitted = true;
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (context) => const ResultScreen(isTimeout: false)),
  //   );
  // }

  String _formatTime(int seconds) {
    if (seconds < 60) {
      return '${seconds.toString().padLeft(2)}s';
    } else {
      int minutes = seconds ~/ 60;
      seconds = seconds % 60;
      return '${minutes.toString().padLeft(2)}m';
    }
  }

  void goToPage(int page) {
    if (page > 0 && page <= totalPages) {
      _pageController.animateToPage(page - 1,
          duration: const Duration(milliseconds: 120), curve: Curves.easeInOut);
      setState(() {
        currentPage = page;
      });

      if (page == totalPages) {
        _showSubmitModal();
      }
    }
  }

  void _showSubmitModal() {
    if (_modalShown) return; // Prevent showing the modal multiple times
    _modalShown = true;

    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 280, maxWidth: 340),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Center(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Submit Test',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.only(left: 50, right: 50),
                        child: Text(
                          'You have unattempted questions, would you like to submit the test?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 21,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60,
                      width: 140,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          side: const BorderSide(color: Colors.blue, width: 2),
                        ),
                        child: const Text(
                          'No',
                          style: TextStyle(color: Colors.blue, fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(width: 30),
                    SizedBox(
                      height: 60,
                      width: 140,
                      child: Material(
                        elevation: 6,
                        shadowColor: Colors.blue[400],
                        borderRadius: BorderRadius.circular(15),
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ResultScreen(isTimeout: false,),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            side: const BorderSide(color: Colors.blue),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(width: 8),
                              const Text(
                                'Yes',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              const SizedBox(width: 20),
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
              ],
            ),
          ),
        );
      },
    ).whenComplete(() {
      _modalShown = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 72,
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
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
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.alarm,
                          color: Colors.blue,
                          size: 20,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${_formatTime(_remainingTime)} Remaining',
                          style: const TextStyle(fontSize: 16, color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 4),
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
              ValueListenableBuilder<double>(
                valueListenable: _dividerProgress,
                builder: (context, progress, _) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: LinearProgressIndicator(
                      value: 1- progress,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.blue),
                      minHeight: 3,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: totalPages,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index + 1;
                  });

                  // Show the submit modal when on the last page
                  if (index == totalPages - 1) {
                    _showSubmitModal();
                  }
                },
                itemBuilder: (context, index) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
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
                                style: TextStyle(
                                    fontSize: 26, fontWeight: FontWeight.bold),
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
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    top: BorderSide(color: Colors.grey.shade300, width: 1)),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 240,
                          child: Text(
                            'Ch1 L1: Animal Nutrition',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: Text(
                            '50 of 50 questions',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: currentPage > 1
                        ? () => goToPage(currentPage - 1)
                        : null,
                    icon: Icon(
                      Icons.arrow_back,
                      color: currentPage > 1 ? Colors.blue : Colors.grey,
                      size: 36,
                    ),
                  ),
                  IconButton(
                    onPressed: currentPage < totalPages
                        ? () => goToPage(currentPage + 1)
                        : null,
                    icon: Icon(
                      Icons.arrow_forward,
                      color: currentPage < totalPages ? Colors.blue : Colors.grey,
                      size: 36,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
