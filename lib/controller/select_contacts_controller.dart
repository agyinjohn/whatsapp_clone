import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsapp_clone/common/select_contact_repository.dart';

final getContactsProvider = FutureProvider((ref) {
  final selectContactsRepository = ref.watch(selectContactsRepositoryProvider);
  return selectContactsRepository.getContacts();
});
final selectContactControllerProvider = Provider((ref) {
  final selectContactRepository = ref.watch(selectContactsRepositoryProvider);
  return ContactController(
      ref: ref, selectContactRepository: selectContactRepository);
});

class ContactController {
  final ProviderRef ref;
  final SelectContactRepository selectContactRepository;
  ContactController({
    required this.ref,
    required this.selectContactRepository,
  });
  void selectContact(Contact contact, BuildContext context) {
    selectContactRepository.selectContact(context, contact);
  }
}
