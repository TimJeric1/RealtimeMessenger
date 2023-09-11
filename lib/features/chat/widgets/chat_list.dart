import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:realtime_messenger/features/chat/widgets/my_message_card.dart';
import '../../../common/models/message.dart';
import '../../../common/widgets/loading_widget.dart';
import '../controller/chat_controller.dart';
import 'receiver_message_card.dart';

class ChatList extends ConsumerStatefulWidget {
  final String recieverUserId;

  const ChatList({
    Key? key,
    required this.recieverUserId,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  void scrollToLatestMessage() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      messageController.jumpTo(messageController.position.maxScrollExtent);
    });
  }

  Widget _messageCard(Message messageData) {
    final timeSent = DateFormat.Hm().format(messageData.timeSent);
    if (messageData.senderId == FirebaseAuth.instance.currentUser!.uid) {
      return ReceiverMessageCard(
        message: messageData.text,
        date: timeSent,
        type: messageData.type,
      );
    } else {
      return MyMessageCard(
        message: messageData.text,
        date: timeSent,
        type: messageData.type,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream: ref.read(chatControllerProvider).chatStream(widget.recieverUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWidget();
        }

        scrollToLatestMessage();

        return ListView.builder(
          controller: messageController,
          itemCount: snapshot.data?.length ?? 0,
          itemBuilder: (context, index) {
            final messageData = snapshot.data![index];
            return _messageCard(messageData);
          },
        );
      },
    );
  }
}
