class StudyProgress {
  final int id;
  final int subjectId;
  final String subjectName;
  final double completedChapterInPercentage;
  final String currentChapterTitle;
  final int currentChapterId;
  final int currentLessonId;
  final String currentLessonTitle;
  final String currentTopicTitle;
  final String chapterImageUrl;
  final double completedLessonInPercentage;

  StudyProgress({
    required this.id,
    required this.subjectId,
    required this.subjectName,
    required this.completedChapterInPercentage,
    required this.currentChapterTitle,
    required this.currentChapterId,
    required this.currentLessonId,
    required this.currentLessonTitle,
    required this.currentTopicTitle,
    required this.chapterImageUrl,
    required this.completedLessonInPercentage,
  });

  factory StudyProgress.fromJson(Map<String, dynamic> json) {
    return StudyProgress(
      id: json['id'],
      subjectId: json['subjectId'],
      subjectName: json['subjectName'],
      completedChapterInPercentage: (json['completedChapterInPercentage'] ?? 0.0).toDouble(),
      currentChapterTitle: json['chapterName'],
      currentChapterId: json['chapterId'],
      currentLessonId: json['lessonId'],
      currentLessonTitle: json['lessonName'],
      currentTopicTitle: json['topicName'],
      chapterImageUrl: json['chapterImage'],
      completedLessonInPercentage: (json['completedLessonInPercentage'] ?? 0.0).toDouble(),
    );
  }
}
