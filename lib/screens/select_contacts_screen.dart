import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/constants/colours.dart';

import '../controller/select_contacts_controller.dart';
import 'error_screen.dart';
import 'loading_screen.dart';

class SelectContactsScreen extends ConsumerWidget {
  const SelectContactsScreen({super.key});
  static const routeName = '/select-contacts';
  void selectContact(
      WidgetRef ref, Contact selectedcontact, BuildContext context) {
    ref
        .read(selectContactControllerProvider)
        .selectContact(selectedcontact, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        title: const Text('Select contact'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: ref.watch(getContactsProvider).when(
          data: (contactList) {
            return ListView.builder(
                itemCount: contactList.length,
                itemBuilder: (context, index) {
                  final contact = contactList[index];
                  return InkWell(
                    onTap: () => selectContact(ref, contact, context),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        leading: contact.photo != null
                            ? CircleAvatar(
                                radius: 25,
                                backgroundColor: backgroundColor,
                                backgroundImage: MemoryImage(contact.photo!),
                              )
                            : const CircleAvatar(
                                radius: 25,
                                backgroundColor: backgroundColor,
                                backgroundImage:
                                    AssetImage("assets/profile.png"),
                              ),
                        title: Text(
                          contact.displayName,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  );
                });
          },
          error: (erroe, stacktrace) => const ErrorScreen(),
          loading: () => const Loader()),
    );
  }
}
