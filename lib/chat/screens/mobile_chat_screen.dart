import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/colours.dart';
import '../../controller/auth_controller.dart';
import '../widgets/bottom_chat_text_field.dart';
import '../widgets/chat_list.dart';

class MobileChatScreen extends ConsumerWidget {
  const MobileChatScreen({
    super.key,
    required this.name,
    required this.uid,
    required this.isGroupChat,
  });
  static const routeName = 'mobile-chat-screen';
  final String name;
  final String uid;
  final bool isGroupChat;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: appBarColor,
          elevation: 0,
          title: isGroupChat
              ? Text(name)
              : StreamBuilder(
                  stream: ref.read(authControllerProvider).getUserDataById(uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    }
                    return Column(
                      children: [
                        Text(name),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          snapshot.data!.isOnline ? 'online' : 'offline',
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.normal),
                        ),
                      ],
                    );
                  }),
        ),
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: ChatList(recieverUserId: uid, isGroupChat: isGroupChat),
              ),
            ),
            BottomChatField(recieverUserId: uid, isGroupChat: isGroupChat)
          ],
        ));
  }
}
