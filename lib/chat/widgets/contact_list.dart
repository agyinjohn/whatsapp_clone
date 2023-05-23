import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/chat/model/chat_contact.dart';
import 'package:whatsapp_clone/chat/screens/mobile_chat_screen.dart';
import 'package:whatsapp_clone/screens/loading_screen.dart';
import 'package:whatsapp_clone/screens/select_contacts_screen.dart';
import '../../constants/colours.dart';
import '../../group/model/group_model.dart';
import '../controllers/chat_controller.dart';

class ChatContactList extends ConsumerWidget {
  const ChatContactList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder<List<Group>>(
                  stream: ref.watch(chatControllerProvider).chatGroups(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Loader();
                    } else if (!snapshot.hasData) {
                      return const Loader();
                    }
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var chatGroup = snapshot.data![index];

                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, MobileChatScreen.routeName,
                                      arguments: {
                                        'name': chatGroup.name,
                                        'uid': chatGroup.groupId,
                                        'isGroupChat': true
                                      });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: ListTile(
                                    title: Text(
                                      chatGroup.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 6.0),
                                      child: Text(
                                        chatGroup.lastMessage,
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        chatGroup.groupPic,
                                      ),
                                      radius: 30,
                                    ),
                                    trailing: Column(
                                      children: [
                                        Text(
                                          DateFormat.Hm()
                                              .format(chatGroup.timeSent),
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(top: 3),
                                          child: CircleAvatar(
                                            backgroundColor: tabColor,
                                            radius: 9,
                                            child: Center(
                                              child: Text(
                                                '5',
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 7,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        });
                  }),
              StreamBuilder<List<ChatContact>>(
                  stream: ref.watch(chatControllerProvider).chatContacts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Loader();
                    } else if (!snapshot.hasData) {
                      return const Loader();
                    }
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var chatContact = snapshot.data![index];

                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, MobileChatScreen.routeName,
                                      arguments: {
                                        'name': chatContact.name,
                                        'uid': chatContact.contactId,
                                        'isGroupChat': false
                                      });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: ListTile(
                                    title: Text(
                                      chatContact.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 6.0),
                                      child: Text(
                                        chatContact.lastMessage,
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        chatContact.profilePic,
                                      ),
                                      radius: 30,
                                    ),
                                    trailing: Column(
                                      children: [
                                        Text(
                                          DateFormat.Hm()
                                              .format(chatContact.timeSent),
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(top: 3),
                                          child: CircleAvatar(
                                            backgroundColor: tabColor,
                                            radius: 9,
                                            child: Center(
                                              child: Text(
                                                '5',
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 7,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        });
                  }),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, SelectContactsScreen.routeName);
        },
        backgroundColor: tabColor,
        child: const Icon(Icons.message),
      ),
    );
  }
}
