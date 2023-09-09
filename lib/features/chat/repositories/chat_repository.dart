import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../common/firebase/common_firebase_storage_repository.dart';
import '../../../common/models/chat_contact.dart';
import '../../../common/models/enums/message_enum.dart';
import '../../../common/models/message.dart';
import '../../../common/models/user_model.dart';
import '../../../common/utils/utils.dart';


final chatRepositoryProvider = Provider(
  (ref) {
  return ChatRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  );
}
);

class ChatRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  ChatRepository({
    required firestore,
    required auth,
  }) : _firestore = firestore, _auth = auth;

  Stream<List<ChatContact>> getChatContacts() {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        var userData = await _firestore
            .collection('users')
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromMap(userData.data()!);

        contacts.add(
          ChatContact(
            name: user.name,
            profilePic: user.profilePic,
            contactId: chatContact.contactId,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage,
          ),
        );
      }
      return contacts;
    });
  }


  Stream<List<Message>> getChatStream(String recieverUserId) {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }


  void _saveDataToContactsSubcollection(
    UserModel senderUserData,
    UserModel? recieverUserData,
    String text,
    DateTime timeSent,
    String recieverUserId,
  ) async {

      var recieverChatContact = ChatContact(
        name: senderUserData.name,
        profilePic: senderUserData.profilePic,
        contactId: senderUserData.uid,
        timeSent: timeSent,
        lastMessage: text,
      );
      await _firestore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(_auth.currentUser!.uid)
          .set(
            recieverChatContact.toMap(),
          );
      var senderChatContact = ChatContact(
        name: recieverUserData!.name,
        profilePic: recieverUserData.profilePic,
        contactId: recieverUserData.uid,
        timeSent: timeSent,
        lastMessage: text,
      );
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .set(
            senderChatContact.toMap(),
          );
  }

  void _saveMessageToMessageSubcollection({
    required String recieverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String username,
    required MessageEnum messageType,
    required String senderUsername,
    required String? recieverUserName,
  }) async {
    final message = Message(
      senderId: _auth.currentUser!.uid,
      recieverid: recieverUserId,
      text: text,
      type: messageType,
      timeSent: timeSent,
      messageId: messageId,
    );




      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .collection('messages')
          .doc(messageId)
          .set(
        message.toMap(),
      );
      await _firestore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(_auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .set(
        message.toMap(),
      );
  }

  Future<void> sendTextMessage({
    required BuildContext context,
    required String text,
    required String recieverUserId,
    required UserModel senderUser,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel? recieverUserData;

        var userDataMap =
            await _firestore.collection('users').doc(recieverUserId).get();
        recieverUserData = UserModel.fromMap(userDataMap.data()!);

      var messageId = const Uuid().v1();


      _saveDataToContactsSubcollection(
        senderUser,
        recieverUserData,
        text,
        timeSent,
        recieverUserId,
      );


      _saveMessageToMessageSubcollection(
        recieverUserId: recieverUserId,
        text: text,
        timeSent: timeSent,
        messageType: MessageEnum.text,
        messageId: messageId,
        username: senderUser.name,
        recieverUserName: recieverUserData?.name,
        senderUsername: senderUser.name,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String recieverUserId,
    required UserModel senderUserData,
    required ProviderRef ref,
    required MessageEnum messageEnum,
  }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();

      String imageUrl = await ref
          .read(commonFirebaseStorageProvider)
          .storeFileToFirebase(
            'chat/${messageEnum.type}/${senderUserData.uid}/$recieverUserId/$messageId',
            file,
          );

      UserModel? recieverUserData;
        var userDataMap =
            await _firestore.collection('users').doc(recieverUserId).get();
        recieverUserData = UserModel.fromMap(userDataMap.data()!);

      String contactMsg;

      switch (messageEnum) {
        case MessageEnum.image:
          contactMsg = '📷 Photo';
          break;
        case MessageEnum.video:
          contactMsg = '📸 Video';
          break;
        case MessageEnum.audio:
          contactMsg = '🎵 Audio';
          break;
        case MessageEnum.gif:
          contactMsg = 'GIF';
          break;
        default:
          contactMsg = 'GIF';
      }

      _saveDataToContactsSubcollection(
        senderUserData,
        recieverUserData,
        contactMsg,
        timeSent,
        recieverUserId,
      );

      _saveMessageToMessageSubcollection(
        recieverUserId: recieverUserId,
        text: imageUrl,
        timeSent: timeSent,
        messageId: messageId,
        username: senderUserData.name,
        messageType: messageEnum,
        recieverUserName: recieverUserData?.name,
        senderUsername: senderUserData.name,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendGIFMessage({
    required BuildContext context,
    required String gifUrl,
    required String recieverUserId,
    required UserModel senderUser,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel? recieverUserData;

        var userDataMap =
            await _firestore.collection('users').doc(recieverUserId).get();
        recieverUserData = UserModel.fromMap(userDataMap.data()!);

      var messageId = const Uuid().v1();

      _saveDataToContactsSubcollection(
        senderUser,
        recieverUserData,
        'GIF',
        timeSent,
        recieverUserId,
      );

      _saveMessageToMessageSubcollection(
        recieverUserId: recieverUserId,
        text: gifUrl,
        timeSent: timeSent,
        messageType: MessageEnum.gif,
        messageId: messageId,
        username: senderUser.name,
        recieverUserName: recieverUserData?.name,
        senderUsername: senderUser.name,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }


}
