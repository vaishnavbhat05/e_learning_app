class TestResult {
  final String securedMarksInPercentage;
  final int totalNumberOfQuestionsAttempted;
  final int totalNumbersOfQuestions;
  final String remarksComment;
  final String remarkSubComment;

  TestResult({
    required this.securedMarksInPercentage,
    required this.totalNumberOfQuestionsAttempted,
    required this.totalNumbersOfQuestions,
    required this.remarksComment,
    required this.remarkSubComment,
  });

  factory TestResult.fromJson(Map<String, dynamic> json) {
    return TestResult(
      securedMarksInPercentage: json['securedMarksInPercentage']??'0%',
      totalNumberOfQuestionsAttempted: json['totalNumberOfQuestionsAttempted'],
      totalNumbersOfQuestions: json['totalNumbersOfQuestions'],
      remarksComment: json['remarksComment'],
      remarkSubComment: json['remarkSubComment'],
    );
  }
}
