import 'package:e_learning_app/screens/lessons/lessons_tests_screen.dart';
import 'package:flutter/material.dart';

class LessonDetailScreen extends StatelessWidget {
  final String title;

  const LessonDetailScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              onPressed: () {
                // Favorite button logic
              },
              icon: const Icon(Icons.favorite_border_sharp, color: Colors.blue),
            ),
            IconButton(
              onPressed: () {
                // Show the modal bottom sheet on Save button click
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
                        constraints: const BoxConstraints(
                            minHeight: 220, maxWidth: 340), // Limit the height
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                      'Select the page number you want to read',
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
                            const SizedBox(height: 150),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 60,
                                  width: 130,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.pop(
                                          context); // Close the modal sheet
                                    },
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      side: const BorderSide(
                                          color: Colors.blue, width: 2),
                                    ),
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 18),
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
                                        Navigator.pop(
                                            context); // Close the modal sheet
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const LessonTestScreen(),
                                          ),
                                        );
                                      },
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        side:
                                            const BorderSide(color: Colors.blue),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Ok',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                          const SizedBox(width: 20),
                                          CircleAvatar(
                                            backgroundColor: Colors.blue[700],
                                            radius: 12,
                                            child: const Icon(
                                                Icons.arrow_right_alt_sharp,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              icon: const Icon(Icons.insert_page_break_outlined,
                  color: Colors.blue),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
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
                        borderRadius:
                            BorderRadius.circular(20) // Light background color
                        ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s.',
                  style: TextStyle(
                    fontSize: 19,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                child: Text(
                  'It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.',
                  style: TextStyle(fontSize: 19),
                  textAlign: TextAlign.justify,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                child: Text(
                  'It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.',
                  style: TextStyle(fontSize: 19),
                  textAlign: TextAlign.justify,
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
                        borderRadius:
                            BorderRadius.circular(20) // Light background color
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
