import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../common/models/enums/message_enum.dart';
import '../../../common/utils/colors.dart';
import '../../../common/utils/utils.dart';
import '../controller/chat_controller.dart';


class ChatField extends ConsumerStatefulWidget {
  final String recieverUserId;
  const ChatField({
    Key? key,
    required this.recieverUserId,
  }) : super(key: key);

  @override
  ConsumerState<ChatField> createState() => _ChatFieldState();
}

class _ChatFieldState extends ConsumerState<ChatField> {
  bool shouldShowSendButton = false;
  final TextEditingController _messageController = TextEditingController();
  FlutterSoundRecorder? _soundRecorder;
  bool isRecorderInit = false;
  bool shouldShowEmojiContainer = false;
  bool isRecording = false;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic permission not allowed!');
    }
    await _soundRecorder!.openRecorder();
    isRecorderInit = true;
  }

  void sendTextMessage() async {
    if (shouldShowSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
        context,
        _messageController.text.trim(),
        widget.recieverUserId,
      );
      setState(() {
        _messageController.text = '';
      });
    } else {
      var tempDir = await getTemporaryDirectory();
      var path = '${tempDir.path}/flutter_sound.aac';
      if (!isRecorderInit) {
        return;
      }
      if (isRecording) {
        await _soundRecorder!.stopRecorder();
        sendFileMessage(File(path), MessageEnum.audio);
      } else {
        await _soundRecorder!.startRecorder(
          toFile: path,
        );
      }

      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void sendFileMessage(
      File file,
      MessageEnum messageEnum,
      ) {
    ref.read(chatControllerProvider).sendFileMessage(
      context,
      file,
      widget.recieverUserId,
      messageEnum,
    );
  }

  void selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void selectVideo() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFileMessage(video, MessageEnum.video);
    }
  }

  void selectGIF() async {
    final gif = await pickGIF(context);
    if (gif != null) {
      ref.read(chatControllerProvider).sendGIFMessage(
        context,
        gif.url,
        widget.recieverUserId,
      );
    }
  }

  void hideEmojiContainer() {
    setState(() {
      shouldShowEmojiContainer = false;
    });
  }

  void showEmojiContainer() {
    setState(() {
      shouldShowEmojiContainer = true;
    });
  }

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus();

  void toggleEmojiKeyboardContainer() {
    if (shouldShowEmojiContainer) {
      showKeyboard();
      hideEmojiContainer();
    } else {
      hideKeyboard();
      showEmojiContainer();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    _soundRecorder!.closeRecorder();
    isRecorderInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _textFormField(),
            ),
            _send_record_button(),
          ],
        ),
        shouldShowEmojiContainer
            ? _emojiPicker()
            : const SizedBox(),
      ],
    );
  }

  SizedBox _emojiPicker() {
    return SizedBox(
        height: 310,
        child: EmojiPicker(
          onEmojiSelected: ((category, emoji) {
            setState(() {
              _messageController.text =
                  _messageController.text + emoji.emoji;
            });

            if (!shouldShowSendButton) {
              setState(() {
                shouldShowSendButton = true;
              });
            }
          }),
        ),
      );
  }

  Padding _send_record_button() {
    return Padding(
            padding: const EdgeInsets.only(
              bottom: 8,
              right: 2,
              left: 2,
            ),
            child: CircleAvatar(
              backgroundColor: const Color(0xFF128C7E),
              radius: 25,
              child: GestureDetector(
                onTap: sendTextMessage,
                child: Icon(
                  shouldShowSendButton
                      ? Icons.send
                      : isRecording
                      ? Icons.close
                      : Icons.mic,
                  color: Colors.white,
                ),
              ),
            ),
          );
  }

  TextFormField _textFormField() {
    return TextFormField(
              focusNode: focusNode,
              controller: _messageController,
              onChanged: _onTextChange,
              decoration: InputDecoration(
                filled: true,
                fillColor: ChatBoxColor,
                prefixIcon: _prefixIcons(),
                suffixIcon: _suffixIcons(),
                hintText: 'Type a message!',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                contentPadding: const EdgeInsets.all(10),
              ),
            );
  }

  void _onTextChange(val) {
              if (val.isNotEmpty) {
                setState(() {
                  shouldShowSendButton = true;
                });
              } else {
                setState(() {
                  shouldShowSendButton = false;
                });
              }
            }

  Padding _prefixIcons() {
    return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: toggleEmojiKeyboardContainer,
                        icon: const Icon(
                          Icons.emoji_emotions,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                        onPressed: selectGIF,
                        icon: const Icon(
                          Icons.gif,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
  }

  SizedBox _suffixIcons() {
    return SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: selectImage,
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Colors.grey,
                      ),
                    ),
                    IconButton(
                      onPressed: selectVideo,
                      icon: const Icon(
                        Icons.attach_file,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
  }
}
