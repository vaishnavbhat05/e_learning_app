import 'dart:math';
import 'package:e_learning_app/screens/lessons/lesson_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/model/liked_topic.dart';
import '../chapters/provider/chapter_provider.dart';
import '../home/currently_studying_card.dart';
import '../lessons/chapter_details_screen.dart';
import '../main_page.dart';
import '../../data/model/lesson.dart';

class ChapterScreen extends StatefulWidget {
  final int subjectId;
  final String subjectName;

  const ChapterScreen({
    super.key,
    required this.subjectId,
    required this.subjectName,
  });

  @override
  _ChapterScreenState createState() => _ChapterScreenState();
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    // Start from top left
    path.lineTo(0, 0);
    // Go to top right
    path.lineTo(size.width * 1, 0); // Increase the width for a larger base
    // Go to bottom center (reduce height for a smaller triangle)
    path.lineTo(size.width / 2, size.height / 2); // Smaller height
    path.close(); // Close the path (back to the starting point)
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class _ChapterScreenState extends State<ChapterScreen> {
  int? selectedChapterIndex;
  int? _selectedIndex = 0;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose the ScrollController
    super.dispose();
  }
  void _fetchData() {
    final chapterProvider =
    Provider.of<ChapterProvider>(context, listen: false);
    chapterProvider.fetchChapters(widget.subjectId).then((_) {
      // Set selectedChapterIndex to 0 (first chapter) by default
      if (chapterProvider.chapters.isNotEmpty && mounted) {
        setState(() {
          selectedChapterIndex = 0;
        });

        // Fetch lessons for the first chapter
        chapterProvider.fetchLessonsByChapter(chapterProvider.chapters[0].id);

        chapterProvider.fetchLikedTopics(widget.subjectId);
      }
    });
  }

  Color getFixedColorForCard(int index) {
    Random random = Random(index); // Use index as a seed for consistency
    return Color.fromRGBO(
      random.nextInt(150) + 50,
      random.nextInt(150) + 50,
      random.nextInt(150) + 50,
      0.5, // Alpha (opacity)
    );
  }

  Future<void> _refreshContent() async {
    final chapterProvider =
    Provider.of<ChapterProvider>(context, listen: false);
    await chapterProvider.fetchChapters(widget.subjectId);
    await chapterProvider.fetchLessonsByChapter(chapterProvider.chapters[0].id);
    await chapterProvider.fetchLikedTopics(widget.subjectId);
  }

  Widget _buildTab(String label, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        if (_selectedIndex == 1) {
          final provider = Provider.of<ChapterProvider>(context, listen: false);
          provider.fetchStudyProgress(widget.subjectId);
        }
        if (_selectedIndex == 2) {
          final provider = Provider.of<ChapterProvider>(context, listen: false);
          provider.fetchLikedTopics(widget.subjectId);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.blue : Colors.grey.shade500,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.grey[100],
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.blue, size: 34),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MainPage(index: 1)),
              );
            },
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(
              height: 20,
            ),
            _buildTabBar(), // Tab Bar (Always Visible)
            const SizedBox(height: 20),
            Expanded(
              child: Consumer<ChapterProvider>(
                builder: (context, chapterProvider, child) {
                  if (chapterProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  // if (chapterProvider.errorMessage != null) {
                  //   return _buildErrorUI();
                  // }

                  return RefreshIndicator(
                    onRefresh: _refreshContent,
                    child: IndexedStack(
                      index: _selectedIndex!,
                      children: [
                        Column(
                          children: [
                            _buildChapterList(chapterProvider),
                            Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: chapterProvider.lessons.length,
                                  itemBuilder: (context, index) {
                                    final lesson = chapterProvider.lessons[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          top: 16, bottom: 18.0),
                                      child: _buildLessonProgressCard(
                                          chapterProvider, lesson),
                                    );
                                  },
                                )),
                          ],
                        ), // ALL Tab
                        _buildStudyingContent(chapterProvider), // STUDYING Tab
                        _buildLikedTab(chapterProvider), // LIKED Tab
                      ],
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Text(
        widget.subjectName,
        style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTabBar() {
    return Center(
      child: Container(
        height: 50,
        width: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTab('ALL', 0),
            const VerticalDivider(
                color: Colors.grey, width: 60, thickness: 0.3),
            _buildTab('STUDYING', 1),
            const VerticalDivider(
                color: Colors.grey, width: 60, thickness: 0.5),
            _buildTab('LIKED', 2),
          ],
        ),
      ),
    );
  }

  Widget _buildChapterAndLessonList(ChapterProvider provider) {
    return Column(
      children: [
        _buildChapterList(provider),
        Expanded(child: _buildLessonList(provider)),
      ],
    );
  }

  Widget _buildLikedTab(ChapterProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (provider.likedTopics.isEmpty) {
      return const Center(child: Text("No topics liked yet."));
    }

    return ListView.builder(
      itemCount: provider.likedTopics.length,
      itemBuilder: (context, index) {
        final LikedTopic topic = provider.likedTopics[index];

        return GestureDetector(
          onTap: () {
            // // // Handle tap (optional)
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) => LessonDetailScreen(
            //           chapterId: chapterId,
            //           lessonId: lessonId,
            //           subjectId: subjectId,
            //           subjectName: subjectName,
            //           topicId: topicId)),
            // );
          },
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              // leading: Image.network(
              //   topic.icon,
              //   width: 50,
              //   height: 50,
              //   fit: BoxFit.cover,
              //   errorBuilder: (context, error, stackTrace) =>
              //   const Icon(Icons.image_not_supported),
              // ),
              title: Text(
                topic.heading,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(topic.subHeading),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStudyingContent(ChapterProvider chapterProvider) {
    var studyProgressList = chapterProvider.studyProgress;

    // Check if the list is empty
    if (studyProgressList.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          "No study progress available.",
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    // Create the ListView to display study progress items
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 320,
        child: ListView.builder(
          scrollDirection: Axis.horizontal, // Scroll horizontally
          itemCount: studyProgressList.length, // Number of items in the list
          itemBuilder: (context, index) {
            // Get each study progress item
            var item = studyProgressList[index];

            return GestureDetector(
              onTap: () {
                // Handle tap (optional)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChapterScreen(
                      subjectName: item.subjectName,
                      subjectId: item.subjectId,
                    ),
                  ),
                );
              },
              child: StudyCard(
                subject: item.subjectName,
                title: item.currentLessonTitle,
                progress: item.completedChapterInPercentage,
                color: getFixedColorForCard(index),
                imageUrl: item.chapterImageUrl,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildChapterList(ChapterProvider provider) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(provider.chapters.length, (index) {
          final chapter = provider.chapters[index];
          return Padding(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () async {
                setState(() {
                  selectedChapterIndex = index;
                });
                await provider.fetchLessonsByChapter(chapter.id);
              },
              child: Container(
                width: 160,
                height: 175,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: getFixedColorForCard(index),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Align(
                            child: Image.network(
                              chapter.chapterImg.trim(),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Text(
                                chapter.chapterName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Stack pointer (triangle) for selected chapter
                    if (selectedChapterIndex == index)
                      Positioned(
                        bottom: -20,
                        left: 70,
                        child: ClipPath(
                          clipper: TriangleClipper(),
                          child: Container(
                              width: 20,
                              height: 20,
                              color: Colors.white // Triangle color
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLessonList(ChapterProvider provider) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: provider.lessons.length,
      itemBuilder: (context, index) {
        final lesson = provider.lessons[index];
        return Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 18.0),
          child: _buildLessonProgressCard(provider, lesson),
        );
      },
    );
  }

  Widget _buildLessonProgressCard(ChapterProvider provider, Lesson lesson) {
    bool allTopicsCompleted = lesson.topics.every((topic) => topic.completed);
    double currentProgress = lesson.completedLessonInPercentage;
    double normalizedProgress = (currentProgress / 100).clamp(0.0, 1.0);

    // Check if the current lesson is unlocked (based on the completion of the previous lesson)
    bool isUnlocked = lesson.lessonIndex == 1 ||
        (lesson.lessonIndex > 1 &&
            provider.lessons[lesson.lessonIndex - 2]
                .completedLessonInPercentage ==
                100);

    return GestureDetector(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('lessonId', lesson.lessonId);

        // Only open lesson if it's unlocked and topics are completed
        if (isUnlocked &&
            (lesson.lessonId == lesson.lessonId ||
                lesson.currentlyStudyingLesson ||
                allTopicsCompleted)) {
          print(
              'Lesson ID: ${lesson.lessonId}, Currently Studying: ${lesson.currentlyStudyingLesson}, All Topics Completed: $allTopicsCompleted');
          await Provider.of<ChapterProvider>(context, listen: false)
              .fetchLessonDetails(lesson.chapterId, lesson.lessonId);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChapterDetailsScreen(
                topicId: lesson.topics.first.topicId,
                lessonId: lesson.lessonId,
                chapterId: lesson.chapterId,
                subjectName: widget.subjectName,
                subjectId: widget.subjectId,
              ),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.rotate(
                      angle: 3.1,
                      child: CircularProgressIndicator(
                        value: isUnlocked ? normalizedProgress : 0,
                        strokeWidth: 2,
                        color: isUnlocked ? Colors.green : Colors.grey,
                        backgroundColor: Colors.grey[200],
                      ),
                    ),
                    if (!isUnlocked && !allTopicsCompleted)
                      const Icon(
                        Icons.lock,
                        size: 24,
                        color: Colors.grey,
                      ),
                    if (allTopicsCompleted)
                      const Icon(
                        Icons.check,
                        size: 24,
                        color: Colors.green,
                      ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: RichText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "${lesson.lessonName}       ",
                          style: TextStyle(
                            fontSize: 16,
                            color: isUnlocked ? Colors.blue : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'Lesson ${lesson.lessonIndex}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
              lesson.topics.map((topic) => _buildTopic(topic)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopic(Topic topic) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  width: 2, // Thickness of the line
                  height: 20, // Height of the line below the dot/check icon
                  color: Colors.grey[300], // Line color
                ),
              ),
              const SizedBox(height: 7),
              // Conditionally show the check icon or the dot container
              topic.completed
                  ? const Icon(
                Icons.check, // Check icon for completed topic
                color: Colors.green, // Green color for the check icon
                size: 18, // Icon size
              )
                  : Icon(
                Icons.circle_sharp,
                size: 12,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 17),
              // Line below the dot/check icon
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  width: 2, // Thickness of the line
                  height: 40, // Height of the line below the dot/check icon
                  color: Colors.grey[300], // Line color
                ),
              ),
            ],
          ),
          const SizedBox(width: 10), // Space between the dot/check and text
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    topic.heading,
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    topic.subHeading,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
