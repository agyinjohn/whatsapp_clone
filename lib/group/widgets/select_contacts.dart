import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/controller/select_contacts_controller.dart';

import '../../screens/loading_screen.dart';

final selectedGroupContacts = StateProvider<List<Contact>>((ref) => []);

class SelectContactGroup extends ConsumerStatefulWidget {
  const SelectContactGroup({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectContactGroupState();
}

class _SelectContactGroupState extends ConsumerState<SelectContactGroup> {
  List<int> selectedContactIdex = [];
  void selectedContact(int index, Contact contact) {
    if (selectedContactIdex.contains(index)) {
      selectedContactIdex.remove(index);
    } else {
      selectedContactIdex.add(index);
    }
    setState(() {});
    ref
        .read(selectedGroupContacts.notifier)
        .update((state) => [...state, contact]);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getContactsProvider).when(
        data: (contactList) => Expanded(
                child: ListView.builder(
              itemCount: contactList.length,
              itemBuilder: (context, index) {
                final contact = contactList[index];
                return InkWell(
                  onTap: () => selectedContact(index, contact),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(
                        contact.displayName,
                        style: const TextStyle(fontSize: 18),
                      ),
                      leading: selectedContactIdex.contains(index)
                          ? IconButton(
                              onPressed: () {}, icon: const Icon(Icons.done))
                          : null,
                    ),
                  ),
                );
              },
            )),
        error: (error, trace) => const Scaffold(
              body: Center(
                child: Text('Please an error occured'),
              ),
            ),
        loading: () => const Loader());
  }
}
