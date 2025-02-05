class Lesson {
  final int lessonId;
  final String lessonName;
  final int lessonIndex;
  final int chapterId;
  final bool currentlyStudyingLesson;
  final double completedLessonInPercentage;
  final List<Topic> topics;

  Lesson({
    required this.lessonId,
    required this.lessonName,
    required this.lessonIndex,
    required this.chapterId,
    required this.currentlyStudyingLesson,
    required this.completedLessonInPercentage,
    required this.topics,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      lessonId: json['lessonId'],
      lessonName: json['lessonName'],
      lessonIndex: json['lessonIndex'],
      chapterId: json['chapterId'],
      currentlyStudyingLesson: json['currentlyStudyingLesson'],
      completedLessonInPercentage: json['completedLessonInPercentage'].toDouble(),
      topics: (json['topics'] as List<dynamic>)
          .map((topic) => Topic.fromJson(topic))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lessonId': lessonId,
      'lessonName': lessonName,
      'lessonIndex': lessonIndex,
      'chapterId': chapterId,
      'currentlyStudyingLesson': currentlyStudyingLesson,
      'completedLessonInPercentage': completedLessonInPercentage,
      'topics': topics.map((topic) => topic.toJson()).toList(),
    };
  }
}

class Topic {
  final int topicId;
  final int lessonId;
  final String heading;
  final String subHeading;
  final int subjectId;
  final bool completed;
  final String? level;
  final int? pageStartsFrom;

  Topic({
    required this.topicId,
    required this.lessonId,
    required this.heading,
    required this.subHeading,
    required this.subjectId,
    required this.completed,
    this.level,
    this.pageStartsFrom,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      topicId: json['topicId'],
      lessonId: json['lessonId'],
      heading: json['heading'],
      subHeading: json['subHeading'],
      subjectId: json['subjectId'],
      completed: json['completed'],
      level: json['level'],
      pageStartsFrom: json['pageStartsFrom'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'topicId': topicId,
      'lessonId': lessonId,
      'heading': heading,
      'subHeading': subHeading,
      'subjectId': subjectId,
      'completed': completed,
      'level': level,
      'pageStartsFrom': pageStartsFrom,
    };
  }
}
