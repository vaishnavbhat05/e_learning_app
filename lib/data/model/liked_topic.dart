import 'package:flutter/cupertino.dart';

class LikedTopic {
  final int id;
  final String heading;
  final String subHeading;
  final String level;
  final IconData icon;
  final String lessonName;
  final int chapterIndex;

  LikedTopic({
    required this.id,
    required this.heading,
    required this.subHeading,
    required this.level,
    required this.icon,
    required this.lessonName,
    required this.chapterIndex,
  });

  factory LikedTopic.fromJson(Map<String, dynamic> json) {
    return LikedTopic(
      id: json['id'],
      heading: json['heading'],
      subHeading: json['subHeading'],
      level: json['level']??"BEGINNER",
      icon: json['icon'],
      lessonName: json['lessonName'],
      chapterIndex: json['chapterIndex'],
    );
  }
}
