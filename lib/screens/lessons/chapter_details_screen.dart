import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/model/lesson.dart';
import '../../data/model/test.dart';
import '../chapters/chapter_screen.dart';
import '../chapters/provider/chapter_provider.dart';
import '../tests/provider/test_screen_provider.dart';
import '../tests/test_screen.dart';
import 'lesson_details_screen.dart';

class ChapterDetailsScreen extends StatefulWidget {
  final int subjectId;
  final String subjectName;
  final int lessonId;
  final int chapterId;
  final int topicId;

  const ChapterDetailsScreen({
    super.key,
    required this.subjectId,
    required this.subjectName,
    required this.chapterId,
    required this.lessonId,
    required this.topicId,
  });

  @override
  _ChapterDetailsScreenState createState() => _ChapterDetailsScreenState();
}

class _ChapterDetailsScreenState extends State<ChapterDetailsScreen> {
  bool showLessons = true;
  bool isLoading = false;


  Future<void> _refreshContent() async {
    await Provider.of<ChapterProvider>(context, listen: false)
        .fetchLessonDetails(widget.chapterId,widget.lessonId);
    if (!showLessons) {
      await Provider.of<ChapterProvider>(context, listen: false)
          .fetchTests(widget.lessonId);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        centerTitle: true,
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
                builder: (context) => ChapterScreen(
                  subjectId: widget.subjectId,
                  subjectName: widget.subjectName,
                ),
                settings: RouteSettings(
                  arguments: widget.chapterId,
                ),
              ),
            );
          },
        ),
        title: Text(
          widget.subjectName.toUpperCase(),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ),
      body: Consumer<ChapterProvider>(
        builder: (context, provider, child) {

          var lessons = provider.lessons;

          if (lessons.isEmpty) {
            return const Center(child: Text('No lessons available.'));
          }

          var lesson = lessons.firstWhere(
                (lesson) => lesson.lessonId == widget.lessonId,
            orElse: () => lessons.first,
          );

          return RefreshIndicator(
            onRefresh: _refreshContent,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      lesson.lessonName,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Lesson ${lesson.lessonIndex}',
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 50),
                    Container(
                      height: 50,
                      width: 370,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildTab("LESSONS", showLessons, () {
                            setState(() {
                              showLessons = true;
                            });
                          }),
                          const VerticalDivider(
                            color: Colors.grey,
                            width: 100,
                            thickness: 0.2,
                          ),
                          _buildTab("TESTS", !showLessons, () {
                            setState(() {
                              showLessons = false;
                            });
                            Provider.of<ChapterProvider>(context, listen: false)
                                .fetchTests(
                                    lesson.lessonId);
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Expanded(
                      child: showLessons
                          ? provider.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _buildLessonsContent(lesson.topics)
                          : provider.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _buildTestsContent(),
                    ),

                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTab(String label, bool isSelected, VoidCallback onTap) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: isSelected
          ? BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            )
          : null,
      child: GestureDetector(
        onTap: onTap,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
                color: isSelected ? Colors.blue : Colors.grey.shade500,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildLessonsContent(List<Topic> topics) {
    return ListView.builder(
      itemCount: topics.length,
      itemBuilder: (context, index) {
        var topic = topics[index];
        Random random = Random(index);
        Color randomColor = Color.fromARGB(
          255,
          random.nextInt(150) + 50,
          random.nextInt(150) + 50,
          random.nextInt(150) + 50,
        );

        return _buildLessonCard(
          topic.heading,
          topic.subHeading,
          randomColor,
          topic.level ?? "BEGINNER",
          topic,
          topic.pageStartsFrom ?? 1,
        );
      },
    );
  }


  Widget _buildLessonCard(
      String title, String description, Color color, String level,Topic topic, int pageStartsFrom) {
    return GestureDetector(
        onTap: () async {
          Provider.of<ChapterProvider>(context, listen: false)
              .fetchLessonTopics(widget.topicId, widget.lessonId, pageStartsFrom)
              .then((_) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LessonDetailScreen(
                  chapterId: widget.chapterId,
                  lessonId: widget.lessonId,
                  subjectId: widget.subjectId,
                  subjectName: widget.subjectName,
                  topicId: topic.topicId,
                  pageStartsFrom: pageStartsFrom,
                  topicLevel: level
                ),
              ),
            );
          });
        },
        child: Container(
        margin: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: color,
                child: const Icon(Icons.eco,
                    color: Colors.white, size: 32),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '$level\n\n',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blue,
                            ),
                          ),
                          TextSpan(
                            text: title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
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

  Widget _buildTestsContent() {
    return Consumer<ChapterProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.errorMessage != null) {
          return Center(child: Text(provider.errorMessage!));
        }

        return ListView.builder(
          itemCount: provider.tests.length,
          itemBuilder: (context, index) {
            final test = provider.tests[index];
            Random random =
                Random(index);
            Color randomColor = Color.fromARGB(
              255,
              random.nextInt(150) + 50,
              random.nextInt(150) + 50,
              random.nextInt(150) + 50,
            );

            return _buildTestCard(
              test,
              test.level,
              test.heading,
              test.subHeading,
              "${test.totalTime} minutes to complete",
              randomColor,
              true,
            );
          },
        );
      },
    );
  }
  Map<int, bool> loadingTests = {};

  void _startLoading(int testId) {
    setState(() {
      loadingTests[testId] = true;
    });
  }

  void _stopLoading(int testId) {
    setState(() {
      loadingTests[testId] = false;
    });
  }

  Widget _buildTestCard(
      TestModel test,
      String level,
      String title,
      String subtitle,
      String testDescription,
      Color color,
      bool isCurrentContent) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: color,
                      radius: 35,
                      child: const Icon(Icons.eco, color: Colors.white, size: 32),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            level,
                            style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 18),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 60,
                  width: 320,
                  child: Material(
                    shadowColor: Colors.blue[300],
                    borderRadius: BorderRadius.circular(10),
                    child: OutlinedButton(
                      onPressed: () async {
                        if (loadingTests[test.id] == true) return;

                        _startLoading(test.id);
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.setInt('testId', test.id);
                        await prefs.remove('remainingTime');
                        await prefs.remove('isTimeout');
                        await prefs.setInt('totalTime', test.totalTime);

                        try {
                          await Provider.of<TestScreenProvider>(context, listen: false)
                              .fetchTestData(test.id);
                          Provider.of<TestScreenProvider>(context,listen: false).clearSelections();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TestScreen(
                                topicId: widget.topicId,
                                chapterId: widget.chapterId,
                                lessonId: widget.lessonId,
                                testId: test.id,
                                totalTime: test.totalTime,
                                subjectName: widget.subjectName,
                                subjectId: widget.subjectId,
                                selectedQuestionIndex: 0,
                              ),
                            ),
                          );
                        } catch (e) {
                          print("Error: $e");
                        } finally {
                          _stopLoading(test.id);
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(width: 80),
                          const Text(
                            'Begin Test',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          const SizedBox(width: 70),
                          CircleAvatar(
                            backgroundColor: Colors.blue[700],
                            radius: 12,
                            child: const Icon(Icons.arrow_right_alt_sharp, color: Colors.white),
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
        // Show loading only for this test
        if (loadingTests[test.id] == true)
          const Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          ),
      ],
    );
  }
}