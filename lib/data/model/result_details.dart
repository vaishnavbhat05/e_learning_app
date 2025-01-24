class ResultDetails {
  final int id;
  final String subjectName;
  final int lessonIndex;
  final String lessonName;
  final int correctAnsweredQuestion;
  final int attemptedQuestion;
  final int totalQuestion;
  final int securedMarks;
  final String createdAt;

  ResultDetails({
    required this.id,
    required this.subjectName,
    required this.lessonIndex,
    required this.lessonName,
    required this.correctAnsweredQuestion,
    required this.attemptedQuestion,
    required this.totalQuestion,
    required this.securedMarks,
    required this.createdAt,
  });

  factory ResultDetails.fromJson(Map<String, dynamic> json) {
    return ResultDetails(
      id: json['id'],
      subjectName: json['subjectName'],
      lessonIndex: json['lessonIndex'],
      lessonName: json['lessonName'],
      correctAnsweredQuestion: json['correctAnsweredQuestion'],
      attemptedQuestion: json['attemptedQuestion'],
      totalQuestion: json['totalQuestion'],
      securedMarks: json['securedMarks'],
      createdAt: json['createdAt'],
    );
  }
}
