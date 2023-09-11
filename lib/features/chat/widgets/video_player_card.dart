import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerCard extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerCard({
    Key? key,
    required this.videoUrl,
  }) : super(key: key);

  @override
  VideoPlayerCardState createState() => VideoPlayerCardState();
}

class VideoPlayerCardState extends State<VideoPlayerCard> {
  late CachedVideoPlayerController videoPlayerController;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    videoPlayerController = CachedVideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        videoPlayerController.setVolume(1);
      });
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (isPlaying) {
      videoPlayerController.pause();
    } else {
      videoPlayerController.play();
    }

    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _aspectRatioPlayer();
  }

  Widget _aspectRatioPlayer() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: _videoStack(),
    );
  }

  Widget _videoStack() {
    return Stack(
      children: [
        _videoPlayer(),
        _playPauseButton(),
      ],
    );
  }

  Widget _videoPlayer() {
    return CachedVideoPlayer(videoPlayerController);
  }

  Widget _playPauseButton() {
    return Align(
      alignment: Alignment.center,
      child: IconButton(
        onPressed: _togglePlayPause,
        icon: Icon(
          isPlaying ? Icons.pause_circle : Icons.play_circle,
        ),
      ),
    );
  }
}
