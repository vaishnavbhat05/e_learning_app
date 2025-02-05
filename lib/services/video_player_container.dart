import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerContainer extends StatefulWidget {
  final String videoUrl;

  VideoPlayerContainer({required this.videoUrl});

  @override
  _VideoPlayerContainerState createState() => _VideoPlayerContainerState();
}

class _VideoPlayerContainerState extends State<VideoPlayerContainer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl) ?? "",
      flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 250.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black,
      ),
      child: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
      ),
    );
  }
}
