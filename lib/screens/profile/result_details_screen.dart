// import 'package:e_learning_app/screens/main_page.dart';
// import 'package:e_learning_app/screens/profile/provider/result_details_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class ResultDetailsScreen extends StatelessWidget {
//   const ResultDetailsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         automaticallyImplyLeading: false,
//         leading: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15),
//           child: IconButton(
//             icon: const Icon(
//               Icons.arrow_back,
//               color: Colors.blue,
//               size: 30,
//             ),
//             onPressed: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) =>
//                       MainPage(index: 2), // Navigate to Profile tab
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//       body: Consumer<ResultProvider>(
//         builder: (context, provider, _) {
//           if (provider.isLoading) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           if (provider.results == null || provider.results!.isEmpty) {
//             return Center(child: Text('No results available.'));
//           }
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 25),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     const Text(
//                       "Results",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 34,
//                         color: Colors.black,
//                       ),
//                     ),
//                     const Spacer(),
//                     Container(
//                       height: 30,
//                       width: 65,
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.blue),
//                         borderRadius: BorderRadius.circular(8),
//                         color: Colors.transparent,
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Text(
//                             "All",
//                             style: TextStyle(color: Colors.black, fontSize: 16),
//                           ),
//                           const SizedBox(width: 10),
//                           GestureDetector(
//                             onTap: () async {
//                               final selectedValue = await showMenu<String>(
//                                   context: context,
//                                   position: const RelativeRect.fromLTRB(
//                                       100, 150, 20, 0),
//                                   items: [
//                                     const PopupMenuItem<String>(
//                                       value: 'All',
//                                       child: Padding(
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: 10),
//                                         child: ListTile(
//                                           // leading: Icon(Icons.subject,
//                                           //     color: Colors.blue),
//                                           title: Text(
//                                             "All",
//                                             style: TextStyle(fontSize: 20),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     const PopupMenuItem<String>(
//                                       value: 'Biology',
//                                       child: Padding(
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: 10),
//                                         child: ListTile(
//                                           // leading: Icon(Icons.subject,
//                                           //     color: Colors.blue),
//                                           title: Text(
//                                             "Biology",
//                                             style: TextStyle(fontSize: 20),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     const PopupMenuItem<String>(
//                                       value: 'Mathematics',
//                                       child: Padding(
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: 10),
//                                         child: ListTile(
//                                           // leading: Icon(Icons.date_range,
//                                           //     color: Colors.blue),
//                                           title: Text(
//                                             "Mathematics",
//                                             style: TextStyle(fontSize: 20),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     const PopupMenuItem<String>(
//                                       value: 'Physics',
//                                       child: Padding(
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: 10),
//                                         child: ListTile(
//                                           // leading:
//                                           //     Icon(Icons.star, color: Colors.blue),
//                                           title: Text(
//                                             "Physics",
//                                             style: TextStyle(fontSize: 20),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     const PopupMenuItem<String>(
//                                       value: 'Biology',
//                                       child: Padding(
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: 10),
//                                         child: ListTile(
//                                           // leading: Icon(Icons.subject,
//                                           //     color: Colors.blue),
//                                           title: Text(
//                                             "Biology",
//                                             style: TextStyle(fontSize: 20),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                   // Optional: Set the popup background color
//                                   elevation: 4,
//                                   color: Colors.white);
//
//
//                               if (selectedValue != null) {
//                                 if (selectedValue == 'All') {
//                                   // Handle Subject filter logic
//                                 } else if (selectedValue == 'Mathematics') {
//                                   // Handle Date filter logic
//                                 } else if (selectedValue == 'Biology') {
//                                   // Handle Top Scores filter logic
//                                 }
//                               }
//                             },
//                             child: const Icon(
//                               Icons.keyboard_arrow_down,
//                               color: Colors.blue,
//                               size: 18,
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 Expanded(
//                   child: ListView.builder(
//                       itemCount: provider.results!.length,
//                       itemBuilder: (context, index) {
//                         final result = provider.results![index];
//                         return buildResultCard(
//                           subject: result.subjectName,
//                           lesson: result.lessonIndex,
//                           title: result.lessonName,
//                           rightAnswers: result.correctAnsweredQuestion,
//                           totalQuestions: result.attemptedQuestion,
//                           score: result.securedMarks,
//                         );
//                       }),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     ));
//   }
//
//   Widget buildResultCard({
//     required String subject,
//     required int lesson,
//     required String title,
//     required int rightAnswers,
//     required int totalQuestions,
//     required int score,
//   }) {
//     Color color = _getStatColor(score);
//     return Card(
//       color: Colors.white,
//       margin: const EdgeInsets.only(bottom: 20.0),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   subject,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14,
//                     color: Colors.blue,
//                   ),
//                 ),
//                 Text(
//                   'lesson $lesson',
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14,
//                     color: Colors.black54,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             Text(
//               title,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 24,
//                 color: Colors.black,
//               ),
//               textAlign: TextAlign.justify,
//             ),
//             const SizedBox(height: 20),
//             Row(
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Right Answers",
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey,
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     Text(
//                       "$rightAnswers",
//                       style: const TextStyle(
//                         fontSize: 20,
//                         color: Colors.black,
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//                     const Text(
//                       "Questions attempted",
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey,
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     Text(
//                       "$rightAnswers of $totalQuestions",
//                       style: const TextStyle(
//                         fontSize: 16,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   width: 83,
//                 ),
//                 RichText(
//                   text: TextSpan(
//                     children: [
//                       TextSpan(
//                         text: '$score',
//                         style: TextStyle(
//                           fontSize: 50,
//                           color: color, // Text color
//                         ),
//                       ),
//                       TextSpan(
//                         text: '%',
//                         style: TextStyle(
//                           fontSize: 30,
//                           color: color, // Different color for %
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Color _getStatColor(int value) {
//     if (value < 30) {
//       return Colors.red.shade600;
//     } else if (value >= 30 && value <= 50) {
//       return Colors.orange.shade600;
//     } else if (value > 50 && value <= 75) {
//       return Colors.yellow.shade600;
//     } else if (value > 75 && value < 100) {
//       return Colors.green.shade600;
//     } else {
//       return Colors.green.shade600; // Darker green for 100%
//     }
//   }
// }
import 'package:e_learning_app/screens/main_page.dart';
import 'package:e_learning_app/screens/profile/provider/result_details_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResultDetailsScreen extends StatelessWidget {
  const ResultDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.blue,
                size: 30,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainPage(index: 2), // Navigate to Profile tab
                  ),
                );
              },
            ),
          ),
        ),
        body: Consumer<ResultProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.results == null || provider.results!.isEmpty) {
              return const Center(child: Text('No results available.'));
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        "Results",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 34,
                          color: Colors.black,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        height: 30,
                        width: 65,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.transparent,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "All",
                              style: TextStyle(color: Colors.black, fontSize: 16),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () async {
                                final selectedValue = await showMenu<String>(
                                  context: context,
                                  position: const RelativeRect.fromLTRB(100, 150, 20, 0),
                                  items: [
                                    const PopupMenuItem<String>(
                                      value: 'All',
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                        child: ListTile(
                                          title: Text("All", style: TextStyle(fontSize: 20)),
                                        ),
                                      ),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: 'Biology',
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                        child: ListTile(
                                          title: Text("Biology", style: TextStyle(fontSize: 20)),
                                        ),
                                      ),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: 'Mathematics',
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                        child: ListTile(
                                          title: Text("Mathematics", style: TextStyle(fontSize: 20)),
                                        ),
                                      ),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: 'Physics',
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                        child: ListTile(
                                          title: Text("Physics", style: TextStyle(fontSize: 20)),
                                        ),
                                      ),
                                    ),
                                  ],
                                  elevation: 4,
                                  color: Colors.white,
                                );

                                if (selectedValue != null) {
                                  // When "All" is selected, fetch all results
                                  if (selectedValue == 'All') {
                                    context.read<ResultProvider>().fetchResults();
                                  } else if (selectedValue == 'Mathematics') {
                                    context.read<ResultProvider>().fetchResultsSubject(1);
                                  } else if (selectedValue == 'Biology') {
                                    context.read<ResultProvider>().fetchResultsSubject(2);
                                  } else if (selectedValue == 'Physics') {
                                    context.read<ResultProvider>().fetchResultsSubject(3);
                                  }
                                }
                              },
                              child: const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.blue,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: provider.results!.length,
                      itemBuilder: (context, index) {
                        final result = provider.results![index];
                        return buildResultCard(
                          subject: result.subjectName,
                          lesson: result.lessonIndex,
                          title: result.lessonName,
                          rightAnswers: result.correctAnsweredQuestion,
                          totalQuestions: result.attemptedQuestion,
                          score: result.securedMarks,
                        );
                      },
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

  Widget buildResultCard({
    required String subject,
    required int lesson,
    required String title,
    required int rightAnswers,
    required int totalQuestions,
    required int score,
  }) {
    Color color = _getStatColor(score);
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 20.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  subject,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  'lesson $lesson',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.black,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Right Answers",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "$rightAnswers",
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Questions attempted",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "$rightAnswers of $totalQuestions",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 83),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '$score',
                        style: TextStyle(
                          fontSize: 50,
                          color: color, // Text color
                        ),
                      ),
                      TextSpan(
                        text: '%',
                        style: TextStyle(
                          fontSize: 30,
                          color: color, // Different color for %
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatColor(int value) {
    if (value < 30) {
      return Colors.red.shade600;
    } else if (value >= 30 && value <= 50) {
      return Colors.orange.shade600;
    } else if (value > 50 && value <= 75) {
      return Colors.yellow.shade600;
    } else if (value > 75 && value < 100) {
      return Colors.green.shade600;
    } else {
      return Colors.green.shade600; // Darker green for 100%
    }
  }
}
