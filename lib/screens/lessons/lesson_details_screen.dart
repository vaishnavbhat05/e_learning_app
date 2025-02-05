import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../data/api/api_handler.dart';
import '../../data/api/endpoints.dart';
import '../../data/model/content.dart';
import '../../services/audio_player_container.dart';
import '../../services/video_player_container.dart';
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
  int currentPage = 1;
  Map<int, bool> pageFavoriteStatus = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChapterProvider>(context, listen: false).fetchLessonTopics(
          widget.topicId, widget.lessonId, widget.pageStartsFrom);
      Provider.of<ChapterProvider>(context, listen: false)
          .markTopicAsCompleted(widget.topicId, widget.pageStartsFrom);
    });
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final provider = Provider.of<ChapterProvider>(context, listen: false);

    setState(() {
      pageFavoriteStatus.clear();
      for (var item in provider.content) {
        pageFavoriteStatus[widget.pageStartsFrom] = item.userLiked;
      }
    });

    print("Favorite status loaded: $pageFavoriteStatus");
  }




  void goToPage(int page) {
    setState(() {
      selectedPage = page;
      Provider.of<ChapterProvider>(context, listen: false).clearContent();
    });

    Provider.of<ChapterProvider>(context, listen: false)
        .fetchLessonTopics(widget.topicId, widget.lessonId, page);

    _pageController.animateToPage(
      page - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    Provider.of<ChapterProvider>(context, listen: false)
        .markTopicAsCompleted(widget.topicId, page);
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
              if (selectedPage != null) {
                await toggleFavorite(widget.topicId, selectedPage!);
              }
            },
            icon: Icon(
              pageFavoriteStatus[selectedPage ?? 1] == true
                  ? Icons.favorite
                  : Icons.favorite_border_sharp,
              color: pageFavoriteStatus[selectedPage ?? 1] == true
                  ? Colors.red
                  : Colors.blue,
            ),
          ),
          IconButton(
            onPressed: () {
              _showPageSelectionBottomSheet(context);
            },
            icon: const Icon(Icons.insert_page_break_outlined,
                color: Colors.blue),
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer<ChapterProvider>(
          builder: (context, chapterProvider, child) {

            if (chapterProvider.errorMessage != null) {
              return Center(
                child: Text(
                  chapterProvider.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            return Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount:
                        chapterProvider.content.length,
                    onPageChanged: (index) {
                      int pageNumber = index + 1;
                      setState(() {
                        currentPage = pageNumber;
                      });
                      Provider.of<ChapterProvider>(context, listen: false)
                          .markTopicAsCompleted(widget.topicId, pageNumber);
                    },

                    itemBuilder: (context, index) {
                      final item = chapterProvider.content[index];
                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: Text(
                                item.heading,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildContent(item),
                            const SizedBox(height: 20),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
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
                                Text(
                                  'L${chapterProvider.lessonIndex}: ',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
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
                      const Spacer(),
                      IconButton(
                        onPressed: chapterProvider.currentPage <
                                chapterProvider.totalPages
                            ? () {
                                int nextPage = chapterProvider.currentPage + 1;
                                goToPage(nextPage);
                              }
                            : null,
                        icon: Icon(
                          Icons.arrow_forward,
                          color: chapterProvider.currentPage <
                                  chapterProvider.totalPages
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

  Widget _buildImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        imageUrl,
        fit: BoxFit.contain,
      ),
    );
  }


  Widget _buildVideo(String videoUrl) {
    if (YoutubePlayer.convertUrlToId(videoUrl) != null) {
      return VideoPlayerContainer(videoUrl: videoUrl);
    } else {
      return Container();
    }
  }


  Widget _buildAudio(String audioUrl) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AudioPlayerContainer(audioUrl: audioUrl),
    );
  }

  Widget _buildInfo(String infoText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
      child: Text(
        infoText,
        style: const TextStyle(fontSize: 18),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _buildContent(Content item) {
    switch (item.contentType) {
      case ContentType.IMAGE:
        return _buildImage(item.contentImg ?? '');
      case ContentType.VIDEO:
        return _buildVideo(item.videoUrl ?? '');
      case ContentType.AUDIO:
        return _buildAudio(item.audioUrl ?? '');
      case ContentType.IMAGEWITHVIDEO:
        return Column(
          children: [
            _buildImage(item.contentImg ?? ''),
            _buildVideo(item.videoUrl ?? ''),
          ],
        );
      case ContentType.IMAGEWITHAUDIO:
        return Column(
          children: [
            _buildImage(item.contentImg ?? ''),
            _buildAudio(item.audioUrl ?? ''),
          ],
        );
      case ContentType.IMAGEWITHINFO:
        return Column(
          children: [
            _buildImage(item.contentImg ?? ''),
            _buildInfo(item.info),
          ],
        );
      case ContentType.VIDEOWITHAUDIO:
        return Column(
          children: [
            _buildVideo(item.videoUrl ?? ''),
            _buildAudio(item.audioUrl ?? ''),
          ],
        );
      case ContentType.VIDEOWITHINFO:
        return Column(
          children: [
            _buildVideo(item.videoUrl ?? ''),
            _buildInfo(item.info),
          ],
        );
      case ContentType.AUDIOWITHINFO:
        return Column(
          children: [
            _buildAudio(item.audioUrl ?? ''),
            _buildInfo(item.info),
          ],
        );
      case ContentType.AUDIOWITHIMAGE:
        return Column(
          children: [
            _buildAudio(item.audioUrl ?? ''),
            _buildImage(item.contentImg ?? ''),
          ],
        );
      case ContentType.IMAGEWITHVIDEOAUDIO:
        return Column(
          children: [
            _buildImage(item.contentImg ?? ''),
            _buildVideo(item.videoUrl ?? ''),
            _buildAudio(item.audioUrl ?? ''),
          ],
        );
      case ContentType.IMAGEWITHVIDEOINFO:
        return Column(
          children: [
            _buildImage(item.contentImg ?? ''),
            _buildVideo(item.videoUrl ?? ''),
            _buildInfo(item.info),
          ],
        );
      case ContentType.IMAGEWITHAUDIOINFO:
        return Column(
          children: [
            _buildImage(item.contentImg ?? ''),
            _buildAudio(item.audioUrl ?? ''),
            _buildInfo(item.info),
          ],
        );
      case ContentType.VIDEOWITHAUDIOINFO:
        return Column(
          children: [
            _buildVideo(item.videoUrl ?? ''),
            _buildAudio(item.audioUrl ?? ''),
            _buildInfo(item.info),
          ],
        );
      case ContentType.IMAGEVIDEOAUDIOINFO:
        return Column(
          children: [
            _buildImage(item.contentImg ?? ''),
            _buildVideo(item.videoUrl ?? ''),
            _buildAudio(item.audioUrl ?? ''),
            _buildInfo(item.info),
          ],
        );
      case ContentType.INFO:
        return _buildInfo(item.info);
      default:
        return const Center(child: Text('Content not available'));
    }
  }


  Future<void> toggleFavorite(int topicId, int pageNumber) async {
    final apiHandler = ApiHandler();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      if (accessToken == null) {
        print("Access token is missing. Please log in again.");
        return;
      }

      final response = await apiHandler.putRequest(
        Endpoints.getFavourite(topicId, pageNumber),
        {'pageNumber': pageNumber},
        headers: {
          "Authorization": "Bearer $accessToken",
          'Content-Type': 'application/json',
        },
      );

      if (response != null && response['status'] == 0) {
        setState(() {
          pageFavoriteStatus[pageNumber] =
              !(pageFavoriteStatus[pageNumber] ?? false);
        });

        await prefs.setBool('favorite_${widget.topicId}_$pageNumber',
            pageFavoriteStatus[pageNumber]!);

        print(response["message"]);
      } else {
        print(
            "Failed to toggle favorite: ${response?['message'] ?? 'Unknown error'}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  void _showPageSelectionBottomSheet(BuildContext context) {
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
            double scrollOffset =
                (selectedPage! - 1) * 66.0;
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
                            padding: EdgeInsets.symmetric(horizontal: 25),
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
                        itemCount:
                            Provider.of<ChapterProvider>(context, listen: false)
                                .totalPages,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setModalState(() {
                                selectedPage = index + 1;
                                scrollController.animateTo(
                                  (index - 2) *
                                      66.0, // Adjust to center selected item
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
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
                                borderRadius: BorderRadius.circular(10),
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
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                side: const BorderSide(color: Colors.blue),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
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
  }
}
