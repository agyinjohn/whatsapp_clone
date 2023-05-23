import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/chat/model/chat_contact.dart';
import 'package:whatsapp_clone/chat/model/message_model.dart';
import 'package:whatsapp_clone/chat/repositories/chat_repository.dart';
import 'package:whatsapp_clone/common/providers/message_reply_provider.dart';
import 'package:whatsapp_clone/controller/auth_controller.dart';
import '../../group/model/group_model.dart';
import '../../utils/enums/message_enum.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(chatrepository: chatRepository, ref: ref);
});

class ChatController {
  final ChatRepository chatrepository;
  final ProviderRef ref;
  ChatController({
    required this.chatrepository,
    required this.ref,
  });

  Stream<List<Message>> chatStream(String recieverId) {
    return chatrepository.getChatStream(recieverId);
  }

  Stream<List<Message>> groupChatStream(String groupId) {
    return chatrepository.getGroupChatStream(groupId);
  }

  Stream<List<ChatContact>> chatContacts() {
    return chatrepository.getChatContacts();
  }

  Stream<List<Group>> chatGroups() {
    return chatrepository.getChatGroups();
  }

  void sendTextMessage(BuildContext context, String text, String recieverUid,
      MessageEnum messageEnum, bool isGroupChat) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataProvider).whenData(
          (value) => chatrepository.sendTextMessage(
              isGroupChat: isGroupChat,
              messageReply: messageReply,
              repleidMessageType: messageEnum,
              context: context,
              text: text,
              recievedUserId: recieverUid,
              senderUser: value!),
        );
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  void sendFileMessage(
      {required BuildContext context,
      required String recieverUid,
      required File file,
      required MessageEnum messageEnum,
      required bool isGroupChat}) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataProvider).whenData(
          (value) => chatrepository.sendFileMessage(
            isGroupChat: isGroupChat,
            messageReply: messageReply,
            context: context,
            file: file,
            messageEnum: messageEnum,
            recieverUserId: recieverUid,
            ref: ref,
            userDataModel: value!,
          ),
        );
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  void sendGIFMessage(BuildContext context, String recieverUserId,
      String gifUrl, bool isGroupChat) {
    int gifUrlPartIndex = gifUrl.lastIndexOf('-') + 1;
    String gifUrlPart = gifUrl.substring(gifUrlPartIndex);
    String newGifUrl = 'https://i.giphy.com/media/$gifUrlPart/200.gif';
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataProvider).whenData(
          (value) => chatrepository.sendGIFMessage(
              messageReply: messageReply,
              context: context,
              gifUrl: newGifUrl,
              recievedUserId: recieverUserId,
              senderUser: value!,
              isGroupChat: isGroupChat),
        );
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  void changeSeenStatus(
      {required BuildContext context,
      required String recieverUserId,
      required String messageId}) {
    chatrepository.changeSeenStatus(
        recieverUserId: recieverUserId, messageId: messageId, context: context);
  }
}
