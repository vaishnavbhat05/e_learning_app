import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerContainer extends StatefulWidget {
  final String audioUrl;

  const AudioPlayerContainer({Key? key, required this.audioUrl}) : super(key: key);

  @override
  _AudioPlayerContainerState createState() => _AudioPlayerContainerState();
}

class _AudioPlayerContainerState extends State<AudioPlayerContainer> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playPauseAudio() async {
    if (widget.audioUrl.trim().isEmpty) {
      debugPrint("Audio URL is empty");
      return;
    }

    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      try {
        await _audioPlayer.play(UrlSource(widget.audioUrl));
      } catch (e) {
        debugPrint("Error playing audio: $e");
      }
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100.0,
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _playPauseAudio,
            child: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              size: 50,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Tap to ${_isPlaying ? 'Pause' : 'Play'} Audio',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
