// import 'package:e_learning_app/screens/chapters/provider/studying_progress_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class StudyProgressScreen extends StatelessWidget {
//   const StudyProgressScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<StudyProgressProvider>(
//       builder: (context, provider, child) {
//         if (provider.isLoading) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (provider.studyProgress == null) {
//           return const Center(child: Text('No data available'));
//         }
//         final progress = provider.studyProgress!;
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Subject: ${progress.subjectName}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//             Text('Current Chapter: ${progress.currentChapterTitle}'),
//             Text('Lesson: ${progress.currentLessonTitle}'),
//             Text('Progress: ${progress.completedChapterInPercentage}%'),
//             Image.network(progress.chapterImageUrl),
//           ],
//         );
//       },
//     );
//   }
// }
