class Chapter {
  final int id;
  final String chapterName;
  final String chapterImg;
  final bool currentlyStudying;

  Chapter({
    required this.id,
    required this.chapterName,
    required this.chapterImg,
    required this.currentlyStudying,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'] ?? 0,
      chapterName: json['chapterName'] ?? 'Unknown',
      chapterImg: json['chapterImg'] ?? '',
      currentlyStudying: json['currentlyStudying'] ?? false,
    );
  }
}
