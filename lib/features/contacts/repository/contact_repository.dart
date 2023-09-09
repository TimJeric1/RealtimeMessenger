import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/models/user_model.dart';
import '../../../common/utils/utils.dart';
import '../../chat/screens/chat_screen.dart';

final contactsRepositoryProvider = Provider(
      (ref) => ContactRepository(
    firestore: FirebaseFirestore.instance,
  ),
);

class ContactRepository {
  final FirebaseFirestore firestore;

  ContactRepository({
    required this.firestore,
  });

  Future<List<Contact>> getContacts() async {
    try {
      if (await FlutterContacts.requestPermission()) {
        return await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<bool> _isUserExists(String phoneNumber) async {
    var userCollection = await firestore.collection('users').get();
    for (var document in userCollection.docs) {
      var userData = UserModel.fromMap(document.data());
      if (phoneNumber == userData.phoneNumber) {
        return true;
      }
    }
    return false;
  }

  void selectContact(Contact selectedContact, BuildContext context) async {
    try {
      String selectedPhoneNum = selectedContact.phones[0].number.replaceAll(' ', '');
      bool userExists = await _isUserExists(selectedPhoneNum);

      if (userExists) {
        var userData = await firestore.collection('users').where('phoneNumber', isEqualTo: selectedPhoneNum).get().then((snapshot) => UserModel.fromMap(snapshot.docs.first.data()));
        Navigator.pushNamed(
          context,
          ChatScreen.routeName,
          arguments: {
            'name': userData.name,
            'uid': userData.uid,
            'profilePic': userData.profilePic
          },
        );
      } else {
        showSnackBar(
          context: context,
          content: 'This number does not exist on this app.',
        );
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
