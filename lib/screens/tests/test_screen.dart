import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../screens/tests/provider/test_screen_provider.dart';
import '../lessons/chapter_details_screen.dart';
import 'result_screen.dart';
import 'test_questions_screen.dart';

class TestScreen extends StatefulWidget {
  final int totalTime;
  final int topicId;
  final int lessonId;
  final int chapterId;
  final int testId;
  final int subjectId;
  final String subjectName;
  final int selectedQuestionIndex;
  const TestScreen(
      {super.key,
      required this.topicId,
      required this.lessonId,
      required this.chapterId,
      required this.testId,
      required this.totalTime,
      required this.subjectName,
      required this.subjectId,
        required this.selectedQuestionIndex,
      });

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  bool _testSubmitted = false;
  late Timer _timer;
  bool _isLoading = true;
  int _remainingTime = 0;
  int currentPage = 1;
  int totalPages = 1;
  late PageController _pageController;
  bool _modalShown = false;

  final ValueNotifier<double> _dividerProgress = ValueNotifier<double>(0.0);
  Color _dividerColor = Colors.green;

  @override
  void initState() {
    super.initState();
    _loadRemainingTime();
    currentPage = widget.selectedQuestionIndex+1;
    _pageController = PageController(initialPage: widget.selectedQuestionIndex);
    _remainingTime = widget.totalTime * 60;
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchTestData();
    });
  }

  Future<void> _fetchTestData() async {
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadRemainingTime() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _remainingTime = prefs.getInt('remainingTime') ?? widget.totalTime * 60;
    });
    _startTimer();
  }

  Future<void> _saveRemainingTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('remainingTime', _remainingTime);
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    _dividerProgress.dispose();
    _saveRemainingTime();
    super.dispose();
  }


  void _startTimer() {
    int totalTimeInSeconds = widget.totalTime * 60;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        _timer.cancel();
        return;
      }

      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
          _dividerProgress.value = _remainingTime / totalTimeInSeconds;
          _dividerColor = _getDividerColor(_remainingTime / totalTimeInSeconds);
        });
      } else {
        _timer.cancel();
        _submitTest(true);
      }
    });
  }


  Color _getDividerColor(double progress) {
    if (progress > 0.5) return Colors.green;
    if (progress > 0.2) return Colors.orange;
    return Colors.red;
  }

  void _submitTest(bool isTimeout) async {
    if (!mounted || _testSubmitted) return;
    _testSubmitted = true;

    if (_timer.isActive) {
      _timer.cancel();
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isTimeout', isTimeout);

    await Provider.of<TestScreenProvider>(context, listen: false)
        .submitTest(widget.testId, isTimeout);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          topicId: widget.topicId,
          chapterId: widget.chapterId,
          lessonId: widget.lessonId,
          testId: widget.testId,
          totalTime: widget.totalTime,
          subjectId: widget.subjectId,
          subjectName: widget.subjectName,
          isTimeout: isTimeout,
          selectedQuestionIndex: widget.selectedQuestionIndex,
        ),
      ),
    );
  }

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
      setState(() {
        currentPage = page;
      });

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          page - 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
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
                        if (_timer.isActive) {
                          _timer.cancel();
                        }
                        if (mounted) {
                          _submitTest(false);
                        }

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChapterDetailsScreen(
                              topicId: widget.topicId,
                              chapterId: widget.chapterId,
                              lessonId: widget.lessonId,
                              subjectName: widget.subjectName,
                              subjectId: widget.subjectId,
                            ),
                          ),
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
                          color: Colors.grey,
                          size: 22,
                        ),
                        const SizedBox(width: 5),
                        Consumer<TestScreenProvider>(
                          builder: (context, provider, child) {
                            return Text(
                              '${_formatTime(_remainingTime)} Remaining',
                              style: TextStyle(
                                  fontSize: 18, color: _dividerColor),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TestQuestionsScreen(
                                    topicId: widget.topicId,
                                    chapterId: widget.chapterId,
                                    lessonId: widget.lessonId,
                                    testId: widget.testId,
                                    totalTime: widget.totalTime,
                                    remainingTime: _remainingTime,
                                    subjectName: widget.subjectName,
                                    subjectId: widget.subjectId,
                                selectedQuestionIndex: widget.selectedQuestionIndex,
                                  )),
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
                      value: 1 - progress,
                      backgroundColor: Colors.grey.shade300,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(_dividerColor),
                      minHeight: 3,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        body: Consumer<TestScreenProvider>(
          builder: (context, provider, child) {

            totalPages = provider.questionStatements.length;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: totalPages,
                      onPageChanged: (index) {
                        if (mounted) {
                          setState(() {
                            currentPage = index + 1;
                          });
                        }
                      },
                      itemBuilder: (context, index) {
                        String questionStatement =
                            provider.questionStatements[index];
                        List<String> options = provider.optionsList[index];
                        String questionImage = provider.questionImages[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Q${index + 1} : $questionStatement',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              (questionImage != null && questionImage.isNotEmpty)
                                  ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 360,
                                  height: 240,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      questionImage,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              )
                                  : const SizedBox.shrink(),
                              const SizedBox(height: 10),
                              Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: options.length,
                                  itemBuilder: (context, i) => _buildOptionCard(index, options[i], i),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          top: BorderSide(
                              color: Colors.grey.shade300, width: 1)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Ch${provider.testData?.chapterIndex ?? 'N/A'},',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        ' L${provider.testData?.lessonIndex ?? 'N/A'}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        ': ${provider.testData?.testName ?? 'N/A'}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '$currentPage of ${provider.testData?.totalQuestions ?? 'N/A'} question',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Navigation buttons
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
                          onPressed: () async {
                            int selectedOption = provider.questionAttempts[currentPage - 1] ?? 0;
                            int questionId = provider.questionIds[currentPage - 1];
                              await provider.submitAnswer(selectedOption, questionId, widget.testId);

                              setState(() {
                                provider.setSelectedOption(currentPage - 1,selectedOption);
                              });

                              if (currentPage < totalPages) {
                                goToPage(currentPage + 1);
                              } else {
                                _showSubmitModal();
                              }
                          },
                          icon: provider.isLoading
                              ? const SizedBox(
                            width: 36,
                            height: 36,
                            child: CircularProgressIndicator(
                              color: Colors.blue,
                              strokeWidth: 2.5,
                            ),
                          )
                              : const Icon(
                            Icons.arrow_forward,
                            color: Colors.blue,
                            size: 36,
                          ),
                        ),
                      ],
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

  Widget _buildOptionCard(int questionIndex, String option, int optionIndex) {
    int displayedOptionIndex = optionIndex + 1;

    return Consumer<TestScreenProvider>(
      builder: (context, testProvider, child) {
        bool isSelected =
            testProvider.questionAttempts[questionIndex] == displayedOptionIndex;

        return GestureDetector(
          onTap: () {
            if (isSelected) {
              testProvider.setSelectedOption(questionIndex, 0);  // Deselect
            } else {
              testProvider.setSelectedOption(questionIndex, displayedOptionIndex);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              width: 360,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.white,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  SizedBox(
                    width: 320,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        option,
                        style: TextStyle(
                          color: isSelected ? Colors.blue : Colors.black45,
                          fontSize: 18,
                          fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  void _showSubmitModal() {
    if (_modalShown) return;
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
                          'Would you like to submit the test?',
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
                          onPressed: () async {
                            _timer.cancel();
                            _submitTest(false);
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.remove('remainingTime');
                            await prefs.remove('isTimeout');
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
                              _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors
                                          .white,
                                    )
                                  : const Text(
                                      'Yes',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                              const SizedBox(width: 20),
                              if (!_isLoading)
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
}
