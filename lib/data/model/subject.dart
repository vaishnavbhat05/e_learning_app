class SubjectModel {
  final int id;
  final String title;
  final String subjectName;
  final String subjectIcon;

  SubjectModel({required this.id,required this.title, required this.subjectName, required this.subjectIcon});

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'],
      title: 'Subjects',
      subjectName: json['subjectName'],
      subjectIcon: json['subjectIcon'],
    );
  }
}
