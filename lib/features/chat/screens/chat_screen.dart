import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/models/user_model.dart';
import '../../../common/utils/colors.dart';
import '../../../common/widgets/loading_widget.dart';
import '../../auth/controller/auth_controller.dart';
import '../widgets/chat_field.dart';
import '../widgets/chat_list.dart';

class ChatScreen extends ConsumerWidget {
  static const String routeName = '/mobile-chat-screen';
  final String name;
  final String uid;
  final String profilePic;

  const ChatScreen({
    Key? key,
    required this.name,
    required this.uid,
    required this.profilePic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: _appBar(ref),
      body: Column(
        children: [
          Expanded(
            child: ChatList(
              recieverUserId: uid,
            ),
          ),
          ChatField(
            recieverUserId: uid,
          ),
        ],
      ),
    );
  }

  AppBar _appBar(WidgetRef ref) {
    return AppBar(
      backgroundColor: appBarColor,
      title: StreamBuilder<UserModel>(
          stream: ref.read(authControllerProvider).userDataById(uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingWidget();
            }
            return _title(snapshot);
          }),
      centerTitle: false,
    );
  }

  Column _title(AsyncSnapshot<UserModel> snapshot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name),
        Text(
          snapshot.data!.isOnline ? 'online' : 'offline',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }



}
