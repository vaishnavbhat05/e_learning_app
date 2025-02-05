import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../chapters/chapter_screen.dart';
import '../home/notifications_screen.dart';
import '../home/search_not_found_screen.dart';
import '../profile/provider/profile_provider.dart';
import 'currently_studying_card.dart';
import 'provider/home_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _suggestions = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeProvider = context.read<HomeProvider>();
      homeProvider.fetchCurrentlyStudyingChapters().then((_) {
        if (homeProvider.currentlyStudyingChapters.isEmpty) {
          homeProvider.fetchRecommendedChapters(); // Ensure this method exists
        }
      });
    });
  }

  void _onSearchChanged(String query) async {
    if (query.length >= 3) {
      final homeProvider = Provider.of<HomeProvider>(context, listen: false);
      await homeProvider.searchSubjects(query); // Search for the subjects
      setState(() {
        _suggestions = homeProvider.searchResults
            .map((subject) => subject.subjectName)
            .toList();
      });
    } else {
      setState(() {
        _suggestions.clear();
      });
    }
  }

  Color getFixedColorForCard(int index) {
    Random random = Random(index);
    return Color.fromRGBO(
      random.nextInt(150) + 50,
      random.nextInt(150) + 50,
      random.nextInt(150) + 50,
      0.5,
    );
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Spacer(),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationsScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.notifications_none_outlined,
                        color: Colors.black38, size: 36),
                  ),
                  Positioned(
                    right: 10,
                    top: 9,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: Consumer2<ProfileProvider, HomeProvider>(
          builder: (context, profileProvider, homeProvider, child) {
            final profile = profileProvider.profile;
            final isCurrentlyStudyingAvailable =
                homeProvider.currentlyStudyingChapters.isNotEmpty;
            final chapterList = isCurrentlyStudyingAvailable
                ? homeProvider.currentlyStudyingChapters
                : homeProvider.recommendedChapters;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Hi, ${profile?.userName ?? "Guest"}',
                        style: const TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
                        'What would you like to study today?',
                        style: TextStyle(fontSize: 22, color: Colors.black54),
                      ),
                    ),
                    const Center(
                      child: Text(
                        'You can search below.',
                        style: TextStyle(fontSize: 22, color: Colors.black54),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 6,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    onChanged: _onSearchChanged,
                                    decoration: const InputDecoration(
                                      hintText: 'Search subjects...',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    final keyword =
                                        _searchController.text.trim();
                                    if (keyword.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Please enter a search keyword")),
                                      );
                                      return;
                                    }

                                    setState(() {
                                      isLoading = true;
                                      _suggestions.clear();
                                    });

                                    final homeProvider =
                                        Provider.of<HomeProvider>(context,
                                            listen: false);
                                    try {
                                      homeProvider.searchResults.clear();
                                      await homeProvider
                                          .searchSubjects(keyword);

                                      if (homeProvider
                                          .searchResults.isNotEmpty) {
                                        final subject =
                                            homeProvider.searchResults.first;
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ChapterScreen(
                                              subjectId: subject.id,
                                              subjectName: subject.subjectName,
                                            ),
                                          ),
                                        );
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SearchNotFoundScreen()),
                                        );
                                      }
                                    } catch (error) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "An error occurred, please try again")),
                                      );
                                    } finally {
                                      setState(() => isLoading = false);
                                    }
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(13),
                                    ),
                                    child: isLoading
                                        ? const Center(
                                            child: CircularProgressIndicator(
                                                color: Colors.white))
                                        : const Icon(Icons.search,
                                            color: Colors.white, size: 30),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_suggestions.isNotEmpty)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(8.0),
                              margin: const EdgeInsets.only(top: 16.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    blurRadius: 6,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _suggestions.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(_suggestions[index]),
                                    onTap: () {
                                      final subject =
                                          homeProvider.searchResults.first;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChapterScreen(
                                            subjectId: subject.id,
                                            subjectName: subject.subjectName,
                                          ),
                                        ),
                                      );
                                      setState(() {
                                        _suggestions.clear();
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        isCurrentlyStudyingAvailable
                            ? 'CURRENTLY STUDYING'
                            : 'RECOMMENDED',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        height: 320,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: chapterList.length,
                          itemBuilder: (context, index) {
                            var chapter = chapterList[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChapterScreen(
                                      subjectId: chapter['subjectId'],
                                      subjectName: chapter['subjectName'],
                                    ),
                                    settings: RouteSettings(
                                      arguments: chapter['chapterId'],
                                    ),
                                  ),
                                );
                              },
                              child: StudyCard(
                                subject: chapter['subjectName'],
                                title: chapter['chapterName'] ?? "",
                                progress:
                                    chapter['completedChapterInPercentage'] ??
                                        0.0,
                                color: getFixedColorForCard(index),
                                imageUrl: chapter['chapterImage'] ?? "",
                              ),
                            );
                          },
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
}
