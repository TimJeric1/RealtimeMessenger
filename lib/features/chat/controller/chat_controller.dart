import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/models/chat_contact.dart';
import '../../../common/models/enums/message_enum.dart';
import '../../../common/models/message.dart';
import '../../auth/controller/auth_controller.dart';
import '../repositories/chat_repository.dart';


final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(
    chatRepository: chatRepository,
    ref: ref,
  );
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  Stream<List<ChatContact>> chatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<Message>> chatStream(String recieverUserId) {
    return chatRepository.getChatStream(recieverUserId);
  }

  Future<void> _readUserDataAndExecute({
    required BuildContext context,
    required String recieverUserId,
    required Function callback,
  }) async {
    ref.read(userDataAuthProvider).whenData(
          (value) async {
        await callback(value!);
      },
    );
  }

  void sendTextMessage(
      BuildContext context,
      String text,
      String recieverUserId,
      ) {
    _readUserDataAndExecute(
      context: context,
      recieverUserId: recieverUserId,
      callback: (userData) async {
        return await chatRepository.sendTextMessage(
          context: context,
          text: text,
          recieverUserId: recieverUserId,
          senderUser: userData,
        );
      },
    );
  }

  void sendFileMessage(
      BuildContext context,
      File file,
      String recieverUserId,
      MessageEnum messageEnum,
      ) {
    _readUserDataAndExecute(
      context: context,
      recieverUserId: recieverUserId,
      callback: (userData) {
        chatRepository.sendFileMessage(
          context: context,
          file: file,
          recieverUserId: recieverUserId,
          senderUserData: userData,
          messageEnum: messageEnum,
          ref: ref,
        );
      },
    );
  }

  void sendGIFMessage(
      BuildContext context,
      String gifUrl,
      String recieverUserId,
      ) {
    String newGifUrl = _transformGifUrl(gifUrl);
    _readUserDataAndExecute(
      context: context,
      recieverUserId: recieverUserId,
      callback: (userData) {
        chatRepository.sendGIFMessage(
          context: context,
          gifUrl: newGifUrl,
          recieverUserId: recieverUserId,
          senderUser: userData,
        );
      },
    );
  }

  String _transformGifUrl(String gifUrl) {
    int gifUrlPartIndex = gifUrl.lastIndexOf('-') + 1;
    String gifUrlPart = gifUrl.substring(gifUrlPartIndex);
    return 'https://i.giphy.com/media/$gifUrlPart/200.gif';
  }
}
