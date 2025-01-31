class Item {
  final String contentType;
  final String? contentImg;
  final String? contentVideo;
  final String? contentAudio;
  final String? contentInfo;

  Item({
    required this.contentType,
    this.contentImg = '',
    this.contentVideo = '',
    this.contentAudio = '',
    this.contentInfo = '',
  });
}
