import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:realtime_messenger/common/utils/colors.dart';
import 'package:realtime_messenger/features/chat/widgets/video_player_card.dart';
import '../../../common/models/enums/message_enum.dart';

class DisplayTextImageGIF extends StatelessWidget {
  final String message;
  final MessageEnum type;
  const DisplayTextImageGIF({
    Key? key,
    required this.message,
    required this.type,
  }) : super(key: key);

  Widget displayTextMessage() {
    return Text(
      message,
      style: const TextStyle(
        fontSize: 16,
        color: textColor
      ),
    );
  }

  Widget displayAudioMessage(bool isPlaying) {
    return StatefulBuilder(
      builder: (context, setState) {

        final AudioPlayer audioPlayer = AudioPlayer();

        return IconButton(
          constraints: const BoxConstraints(
            minWidth: 100,
          ),
          onPressed: () async {
            if (isPlaying) {
              await audioPlayer.pause();
              setState(() {
                isPlaying = false;
              });
            } else {
              await audioPlayer.play(UrlSource(message));
              setState(() {
                isPlaying = true;
              });
            }
          },
          icon: Icon(
            isPlaying ? Icons.pause_circle : Icons.play_circle,
          ),
        );
      },
    );
  }

  Widget _videoMessage() {
    return VideoPlayerCard(
      videoUrl: message,
    );
  }

  Widget _imageOrGif() {
    return CachedNetworkImage(
      imageUrl: message,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;
    switch (type) {
      case MessageEnum.text:
        return displayTextMessage();
      case MessageEnum.audio:
        return displayAudioMessage(isPlaying);
      case MessageEnum.video:
        return _videoMessage();
      case MessageEnum.gif:
      default:
        return _imageOrGif();
    }
  }
}
