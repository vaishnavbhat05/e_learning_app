class TestModel {
  final int id;
  final String? testIcon;
  final String heading;
  final String level;
  final int totalTime;
  final String lessonName;
  final String subHeading;
  final int totalNumberOfQuestions;
  final DateTime createdAt;
  final DateTime updatedAt;

  TestModel({
    required this.id,
    this.testIcon,
    required this.heading,
    required this.level,
    required this.totalTime,
    required this.lessonName,
    required this.subHeading,
    required this.totalNumberOfQuestions,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TestModel.fromJson(Map<String, dynamic> json) {
    return TestModel(
      id: json['id'],
      testIcon: json['testIcon'],
      heading: json['heading'],
      level: json['level'],
      totalTime: json['totalTime'],
      lessonName: json['lessonName'],
      subHeading: json['subHeading'],
      totalNumberOfQuestions: json['totalNumberOfQuestions'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
