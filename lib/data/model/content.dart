class Content {
  final int id;
  final String heading;
  final String contentType;
  final String contentImg;
  final String info;
  final bool userLiked;
  final int totalPages;
  final int currentPage;
  final int lessonId;
  final int topicId;

  Content({
    required this.id,
    required this.heading,
    required this.contentType,
    required this.contentImg,
    required this.info,
    required this.userLiked,
    required this.totalPages,
    required this.currentPage,
    required this.lessonId,
    required this.topicId,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      id: json['id'],
      heading: json['heading'],
      contentType: json['contentType']??"",
      contentImg: json['contentImg']??"",
      info: json['info']??'',
      userLiked: json['userLiked'],
      totalPages: json['totalPages'] ?? 0,
      currentPage: json['currentPage'] ?? 0,
      lessonId: json['lessonId'] ?? 0,
      topicId: json['topicId'] ?? 0,
    );
  }
}
