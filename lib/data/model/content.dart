enum ContentType {
  IMAGE,
  VIDEO,
  AUDIO,
  IMAGEWITHVIDEO,
  IMAGEWITHAUDIO,
  IMAGEWITHINFO,
  VIDEOWITHAUDIO,
  VIDEOWITHINFO,
  AUDIOWITHINFO,
  AUDIOWITHIMAGE,
  IMAGEWITHVIDEOAUDIO,
  IMAGEWITHVIDEOINFO,
  IMAGEWITHAUDIOINFO,
  VIDEOWITHAUDIOINFO,
  IMAGEVIDEOAUDIOINFO,
  INFO,
}

class Content {
  final int id;
  final String heading;
  final ContentType contentType;
  final String? contentImg;
  final String? videoUrl;
  final String? audioUrl;
  final String info;
  final bool userLiked;

  Content({
    required this.id,
    required this.heading,
    required this.contentType,
    this.contentImg,
    this.videoUrl,
    this.audioUrl,
    required this.info,
    required this.userLiked,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    // Convert string from JSON to enum. Adjust if your JSON value doesn't match exactly.
    ContentType type = ContentType.INFO;
    try {
      type = ContentType.values.firstWhere((e) =>
      e.toString().split('.').last.toUpperCase() ==
          json['contentType'].toString().toUpperCase());
    } catch (e) {
      // fallback if not found
    }

    return Content(
      id: json['id'],
      heading: json['heading'],
      contentType: type,
      contentImg: json['contentImg'] ?? '',
      videoUrl: json['videoUrl'] ?? '', // if provided by your API
      audioUrl: json['audioUrl'] ?? '', // note: this is where your URL comes from
      info: json['info'] ?? '',
      userLiked: json['userLiked'] ?? false,
    );
  }
}
