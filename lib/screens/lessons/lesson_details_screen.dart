import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/api/api_handler.dart';
import '../../data/api/endpoints.dart';
import '../chapters/provider/chapter_provider.dart';
import 'chapter_details_screen.dart';
class LessonDetailScreen extends StatefulWidget {
  final int chapterId;
  final int lessonId;
  final int subjectId;
  final String subjectName;
  final int topicId;
  final String topicLevel;
  final int pageStartsFrom;

  const LessonDetailScreen({
    super.key,
    required this.chapterId,
    required this.lessonId,
    required this.subjectId,
    required this.subjectName,
    required this.topicId,
    required this.topicLevel,
    required this.pageStartsFrom,
  });

  @override
  _LessonDetailScreenState createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  final PageController _pageController = PageController();
  int? selectedPage;
  bool isFavorited = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChapterProvider>(context, listen: false)
          .fetchLessonTopics(widget.topicId, widget.lessonId, widget.pageStartsFrom);
    });
    _loadFavoriteStatus();
  }
  Future<void> _loadFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorited = prefs.getBool('favorite_${widget.topicId}') ?? false;
    });
  }

  void goToPage(int pageNumber) {
    setState(() {
      selectedPage = pageNumber;
    });

    Provider.of<ChapterProvider>(context, listen: false)
        .fetchLessonTopics(widget.topicId, widget.lessonId, pageNumber);
    Provider.of<ChapterProvider>(context, listen: false).markTopicAsCompleted(widget.topicId);


    _pageController.animateToPage(
      pageNumber - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  Future<void> toggleFavorite(int topicId) async {
    final apiHandler = ApiHandler(); // Instance of ApiHandler

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      if (accessToken == null) {
        print("Access token is missing. Please log in again.");
        return;
      }

      final response = await apiHandler.putRequest(
        Endpoints.getFavourite(topicId), // Use dynamic topicId
        headers: {"Authorization": "Bearer $accessToken"},
      );

      if (response != null && response['status'] == 0) {
        setState(() {
          isFavorited = !isFavorited;
        });

        await prefs.setBool('favorite_$topicId', isFavorited);

        print(response["message"]); // Debugging message
      } else {
        print("Failed to toggle favorite: ${response?['message'] ?? 'Unknown error'}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<ChapterProvider>(context, listen: false).markTopicAsViewed(widget.topicId);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChapterDetailsScreen(
                        chapterId: widget.chapterId,
                        lessonId: widget.lessonId,
                        subjectName: widget.subjectName,
                        subjectId: widget.subjectId,
                        topicId: widget.topicId,

                      )));
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.blue,
              size: 30,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () async {
              await toggleFavorite(widget.topicId);
            },
            icon: Icon(
              isFavorited ? Icons.favorite : Icons.favorite_border_sharp,
              color: isFavorited ? Colors.red : Colors.blue,
            ),
          ),
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                backgroundColor: Colors.white,
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (BuildContext context) {
                  final ScrollController scrollController = ScrollController();

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (selectedPage != null) {
                      double scrollOffset = (selectedPage! - 1) *
                          66.0; // Adjust item width + margin
                      scrollController.animateTo(
                        scrollOffset,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  });

                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setModalState) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minHeight: 220,
                            maxWidth: 340,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Center(
                                child: Column(
                                  children: [
                                    Text(
                                      'Go to the Page',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Padding(
                                      padding:
                                      EdgeInsets.symmetric(horizontal: 25),
                                      child: Text(
                                        'Select the page number you want to read.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                height: 60,
                                child: ListView.builder(
                                  controller: scrollController,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: Provider.of<ChapterProvider>(context, listen: false).totalPages,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setModalState(() {
                                          selectedPage = index + 1;
                                          scrollController.animateTo(
                                            (index - 2) * 66.0,
                                            // Adjust to center selected item
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.easeInOut,
                                          );
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                          // color: selectedPage == index + 1
                                          //     ? Colors.blue.withOpacity(0.2)
                                          //     : Colors.transparent,
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${index + 1}',
                                            style: TextStyle(
                                              color: selectedPage == index + 1
                                                  ? Colors.blue
                                                  : Colors.grey[300],
                                              fontSize: 36,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 60,
                                    width: 130,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                        ),
                                        side: const BorderSide(
                                          color: Colors.blue,
                                          width: 2,
                                        ),
                                      ),
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 30),
                                  SizedBox(
                                    height: 60,
                                    width: 130,
                                    child: Material(
                                      elevation: 6,
                                      shadowColor: Colors.blue[400],
                                      borderRadius: BorderRadius.circular(10),
                                      child: OutlinedButton(
                                        onPressed: () {
                                          if (selectedPage != null) {
                                            goToPage(selectedPage!);
                                            Navigator.pop(context);
                                          }
                                        },
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                          ),
                                          side: const BorderSide(
                                              color: Colors.blue),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'Ok',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                            CircleAvatar(
                                              backgroundColor: Colors.blue[700],
                                              radius: 12,
                                              child: const Icon(
                                                Icons.arrow_right_alt_sharp,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
            icon: const Icon(Icons.insert_page_break_outlined,
                color: Colors.blue),
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer<ChapterProvider>(
          builder: (context, chapterProvider, child) {
            if (chapterProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (chapterProvider.errorMessage != null) {
              return Center(
                child: Text(
                  chapterProvider.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            final content = chapterProvider.content;

            if (content.isEmpty) {
              return const Center(child: Text("No content available."));
            }

            return Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: chapterProvider.content.length, // Dynamic item count
                    onPageChanged: (index) {
                      goToPage(index + 1);
                    },
                    itemBuilder: (context, index) {
                      final item = chapterProvider.content[index];
                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 40),
                              child: Text(
                                item.heading,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (item.contentType == 'IMAGE')
                              Center(
                                child: Container(
                                  height: 200,
                                  width: 360,
                                  decoration: BoxDecoration(
                                    color: Colors.black38,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      item.contentImg,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: Text(
                                item.info,
                                style: const TextStyle(fontSize: 19),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade300, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('L${chapterProvider.lessonIndex}:',style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                SizedBox(
                                  width: 220,
                                  child: Text(
                                    chapterProvider.heading,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '${chapterProvider.currentPage} of ${chapterProvider.totalPages} pages',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: chapterProvider.currentPage > 1
                            ? () => goToPage(chapterProvider.currentPage - 1)
                            : null,
                        icon: Icon(
                          Icons.arrow_back,
                          color: chapterProvider.currentPage > 1 ? Colors.blue : Colors.grey,
                          size: 40,
                        ),
                      ),
                      IconButton(
                        onPressed: chapterProvider.currentPage < chapterProvider.totalPages
                            ? () => goToPage(chapterProvider.currentPage + 1)
                            : null,
                        icon: Icon(
                          Icons.arrow_forward,
                          color: chapterProvider.currentPage < chapterProvider.totalPages
                              ? Colors.blue
                              : Colors.grey,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
  // Widget _buildContent(Item item) {
  //   switch (item.contentType) {
  //     case 'IMAGE':
  //       return _buildImage(item.contentImg);
  //     case 'VIDEO':
  //       return _buildVideo(item.contentVideo);
  //     case 'AUDIO':
  //       return _buildAudio(item.contentAudio);
  //     case 'IMAGEWITHVIDEO':
  //       return Column(
  //         children: [
  //           _buildImage(item.contentImg),
  //           _buildVideo(item.contentVideo),
  //         ],
  //       );
  //     case 'IMAGEWITHAUDIO':
  //       return Column(
  //         children: [
  //           _buildImage(item.contentImg),
  //           _buildAudio(item.contentAudio),
  //         ],
  //       );
  //     case 'IMAGEWITHINFO':
  //       return Column(
  //         children: [
  //           _buildImage(item.contentImg),
  //           _buildInfo(item.contentInfo),
  //         ],
  //       );
  //     case 'VIDEOWITHAUDIO':
  //       return Column(
  //         children: [
  //           _buildVideo(item.contentVideo),
  //           _buildAudio(item.contentAudio),
  //         ],
  //       );
  //     case 'VIDEOWITHINFO':
  //       return Column(
  //         children: [
  //           _buildVideo(item.contentVideo),
  //           _buildInfo(item.contentInfo),
  //         ],
  //       );
  //     case 'AUDIOWITHINFO':
  //       return Column(
  //         children: [
  //           _buildAudio(item.contentAudio),
  //           _buildInfo(item.contentInfo),
  //         ],
  //       );
  //     case 'IMAGEWITHVIDEOAUDIO':
  //       return Column(
  //         children: [
  //           _buildImage(item.contentImg),
  //           _buildVideo(item.contentVideo),
  //           _buildAudio(item.contentAudio),
  //         ],
  //       );
  //     case 'IMAGEWITHVIDEOINFO':
  //       return Column(
  //         children: [
  //           _buildImage(item.contentImg),
  //           _buildVideo(item.contentVideo),
  //           _buildInfo(item.contentInfo),
  //         ],
  //       );
  //     case 'IMAGEWITHAUDIOINFO':
  //       return Column(
  //         children: [
  //           _buildImage(item.contentImg),
  //           _buildAudio(item.contentAudio),
  //           _buildInfo(item.contentInfo),
  //         ],
  //       );
  //     case 'VIDEOWITHAUDIOINFO':
  //       return Column(
  //         children: [
  //           _buildVideo(item.contentVideo),
  //           _buildAudio(item.contentAudio),
  //           _buildInfo(item.contentInfo),
  //         ],
  //       );
  //     case 'IMAGEVIDEOAUDIOINFO':
  //       return Column(
  //         children: [
  //           _buildImage(item.contentImg),
  //           _buildVideo(item.contentVideo),
  //           _buildAudio(item.contentAudio),
  //           _buildInfo(item.contentInfo),
  //         ],
  //       );
  //     case 'INFO':
  //       return _buildInfo(item.contentInfo);
  //     default:
  //       return const Center(child: Text('Content not available'));
  //   }
  // }
  // Widget _buildImage(String imageUrl) {
  //   return Center(
  //     child: Container(
  //       height: 200,
  //       width: 360,
  //       decoration: BoxDecoration(
  //         color: Colors.black38,
  //         borderRadius: BorderRadius.circular(20),
  //       ),
  //       child: ClipRRect(
  //         borderRadius: BorderRadius.circular(20),
  //         child: Image.network(
  //           imageUrl,
  //           fit: BoxFit.cover,
  //           errorBuilder: (context, error, stackTrace) => const Center(
  //               child: Text(
  //                 'Image not available',
  //                 style: TextStyle(fontSize: 30),
  //               )),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget _buildVideo(String videoUrl) {
  //   return Container(
  //     height: 200,
  //     width: 360,
  //     child: Center(child: Text('Video Placeholder')), // Replace with Video Player widget
  //   );
  // }
  //
  // Widget _buildAudio(String audioUrl) {
  //   return Container(
  //     height: 100,
  //     width: 360,
  //     child: Center(child: Text('Audio Placeholder')), // Replace with Audio Player widget
  //   );
  // }
  //
  // Widget _buildInfo(String infoText) {
  //   return Padding(
  //     padding: const EdgeInsets.all(10),
  //     child: Text(
  //       infoText,
  //       style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //     ),
  //   );
  // }

}
