import 'package:e_learning_app/screens/lessons/lessons_tests_screen.dart';
import 'package:flutter/material.dart';

class LessonDetailScreen extends StatefulWidget {
  final String title;

  const LessonDetailScreen({super.key, required this.title});

  @override
  _LessonDetailScreenState createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  final PageController _pageController = PageController();
  int currentPage = 1;
  final int totalPages = 20;
  int? selectedPage;

  void goToPage(int pageNumber) {
    _pageController.animateToPage(
      pageNumber - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
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
            const SizedBox(width: 16,),
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LessonTestScreen()));
              },
              icon: const Icon(Icons.arrow_back, color: Colors.blue,size: 30,),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                // Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => const FavouriteScreen()));
              },
              icon: const Icon(Icons.favorite_border_sharp, color: Colors.blue),
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
                        double scrollOffset = (selectedPage! - 1) * 66.0; // Adjust item width + margin
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
                                    itemCount: totalPages,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setModalState(() {
                                            selectedPage = index + 1;
                                            scrollController.animateTo(
                                              (index - 2) * 66.0,  // Adjust to center selected item
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
                                            color: selectedPage == index + 1
                                                ? Colors.blue.withOpacity(0.2)
                                                : Colors.transparent,
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
              },
              icon: const Icon(Icons.insert_page_break_outlined, color: Colors.blue),
            ),
          ],
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
                },
                itemBuilder: (context, index) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            widget.title,
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Container(
                            height: 200,
                            width: 360,
                            decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                            style: TextStyle(fontSize: 19),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            'It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.',
                            style: TextStyle(fontSize: 19),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
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
                            width: 240, // Adjust width as per your design
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
                            width: 200, // Adjust width as per your design
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
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                    IconButton(
                      onPressed: currentPage < totalPages
                          ? () => goToPage(currentPage + 1)
                          : null,
                      icon: const Icon(
                        Icons.arrow_forward,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
