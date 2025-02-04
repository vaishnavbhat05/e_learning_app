import 'package:flutter/cupertino.dart';

class LikedTopic {
  final int id;
  final String heading;
  final String subHeading;
  final String level;
  final String icon;
  final String lessonName;
  final int chapterIndex;
  final int pageNumber;
  final int lessonId;
  final int chapterId;

  LikedTopic({
    required this.id,
    required this.heading,
    required this.subHeading,
    required this.level,
    required this.icon,
    required this.lessonName,
    required this.chapterIndex,
    required this.pageNumber,
    required this.lessonId,
    required this.chapterId,
  });

  factory LikedTopic.fromJson(Map<String, dynamic> json) {
    return LikedTopic(
      id: json['topicId'],
      heading: json['heading'],
      subHeading: json['subHeading'],
      level: json['level'] ?? "BEGINNER",
      icon: json['icon'] ?? '',
      lessonName: json['lessonName'],
      chapterIndex: json['chapterIndex'],
      pageNumber: json['pageNumber'],
      lessonId: json['lessonId'],
      chapterId:json['chapterId'],
    );
  }
}
