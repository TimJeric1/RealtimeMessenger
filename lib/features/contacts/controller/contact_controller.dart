import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/contact_repository.dart';

final getContactsProvider = FutureProvider((ref) {
  final contactRepo = ref.watch(contactsRepositoryProvider);
  return contactRepo.getContacts();
});

final contactControllerProvider = Provider((ref) {
  final contactRepo = ref.watch(contactsRepositoryProvider);
  return ContactController(
    ref: ref,
    contactRepository: contactRepo,
  );
});

class ContactController {
  final ProviderRef ref;
  final ContactRepository contactRepository;

  ContactController({
    required this.ref,
    required this.contactRepository,
  });

  void selectContact(Contact selectedContact, BuildContext context) {
    contactRepository.selectContact(selectedContact, context);
  }
}
