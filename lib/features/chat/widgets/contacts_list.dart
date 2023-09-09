import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../common/models/chat_contact.dart';
import '../../../common/utils/colors.dart';
import '../../../common/widgets/loading_widget.dart';
import '../controller/chat_controller.dart';
import '../screens/chat_screen.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<List<ChatContact>>(
              stream: ref.watch(chatControllerProvider).chatContacts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingWidget();
                }

                final chatContacts = snapshot.data ?? [];
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: chatContacts.length,
                  itemBuilder: (context, index) {
                    final chatContactData = chatContacts[index];
                    return _contactItem(context, chatContactData);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  Widget _contactItem(BuildContext context, ChatContact chatContactData) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              ChatScreen.routeName,
              arguments: {
                'name': chatContactData.name,
                'uid': chatContactData.contactId,
                'profilePic': chatContactData.profilePic,
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ListTile(
              title: Text(
                chatContactData.name,
                style: const TextStyle(fontSize: 18, color: textColor),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Text(
                  chatContactData.lastMessage,
                  style: const TextStyle(fontSize: 15, color: textColor),
                ),
              ),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(chatContactData.profilePic),
                radius: 30,
              ),
              trailing: Text(
                DateFormat.Hm().format(chatContactData.timeSent),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ),
        const Divider(color: dividerColor, indent: 85),
      ],
    );
  }
}
