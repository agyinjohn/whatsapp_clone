import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/chat/model/chat_contact.dart';
import 'package:whatsapp_clone/chat/model/message_model.dart';
import 'package:whatsapp_clone/model/user_model.dart';
import 'package:whatsapp_clone/utils/enums/message_enum.dart';
import 'package:whatsapp_clone/utils/show_snackbar.dart';
import '../../common/common_firebase_store.dart';
import '../../common/providers/message_reply_provider.dart';
import '../../group/model/group_model.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(
      fireStore: FirebaseFirestore.instance, auth: FirebaseAuth.instance),
);

class ChatRepository {
  final FirebaseFirestore fireStore;

  final FirebaseAuth auth;
  ChatRepository({
    required this.fireStore,
    required this.auth,
  });

  Stream<List<Message>> getChatStream(String receieverUserId) {
    return fireStore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receieverUserId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var doucument in event.docs) {
        messages.add(
          Message.fromMap(doucument.data()),
        );
      }
      return messages;
    });
  }

  Stream<List<ChatContact>> getChatContacts() {
    return fireStore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        var userData = await fireStore
            .collection('users')
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromMap(userData.data()!);
        contacts.add(ChatContact(
            name: user.name,
            profilePic: user.profilePic,
            contactId: chatContact.contactId,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage));
      }
      return contacts;
    });
  }

  _saveDataToContactsCollection({
    required UserModel senderUserData,
    required UserModel? receieverUserModel,
    required String text,
    required DateTime timesent,
    required recieverUserId,
    required isGroupChat,
  }) async {
    if (isGroupChat) {
      await fireStore.collection('groups').doc(recieverUserId).update({
        "lastMessage": text,
        'timeSent': DateTime.now().millisecondsSinceEpoch,
      });
    } else {
      var receiverChatContact = ChatContact(
          name: senderUserData.name,
          profilePic: senderUserData.profilePic,
          contactId: senderUserData.uid,
          timeSent: timesent,
          lastMessage: text);
      await fireStore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .set(receiverChatContact.toMap());

      var senderChatContact = ChatContact(
          name: receieverUserModel!.name,
          profilePic: receieverUserModel.profilePic,
          contactId: receieverUserModel.uid,
          timeSent: timesent,
          lastMessage: text);
      await fireStore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .set(senderChatContact.toMap());
    }
  }

  void _sendMessageToMessageSubCollection({
    required String receieverUserId,
    required String senderUserName,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String? receiverUserName,
    required MessageEnum messageType,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    final message = Message(
      repliedMessage: messageReply == null ? '' : messageReply.message,
      repliedMessageTpye:
          messageReply == null ? MessageEnum.text : messageReply.messageEnum,
      replyTo: messageReply == null
          ? ''
          : messageReply.isMe
              ? senderUserName
              : receiverUserName ?? '',
      senderId: auth.currentUser!.uid,
      recieverId: receieverUserId,
      text: text,
      messageId: messageId,
      type: messageType,
      timeSent: timeSent,
      isSeen: false,
    );
    if (isGroupChat) {
      // groups -> group id -> chat -> message
      await fireStore
          .collection('groups')
          .doc(receieverUserId)
          .collection('chats')
          .doc(messageId)
          .set(
            message.toMap(),
          );
    } else {
      await fireStore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(receieverUserId)
          .collection('messages')
          .doc(messageId)
          .set(message.toMap());

      await fireStore
          .collection('users')
          .doc(receieverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .set(message.toMap());
    }
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String recievedUserId,
    required UserModel senderUser,
    required MessageReply? messageReply,
    required MessageEnum repleidMessageType,
    required bool isGroupChat,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel? receiverUserData;
      if (!isGroupChat) {
        var userDataMap =
            await fireStore.collection('users').doc(recievedUserId).get();
        receiverUserData = UserModel.fromMap(userDataMap.data()!);
      }

      _saveDataToContactsCollection(
        receieverUserModel: receiverUserData,
        recieverUserId: recievedUserId,
        senderUserData: senderUser,
        text: text,
        timesent: timeSent,
        isGroupChat: isGroupChat,
      );
      var messageId = const Uuid().v1();
      _sendMessageToMessageSubCollection(
          messageReply: messageReply,
          receieverUserId: recievedUserId,
          senderUserName: senderUser.name,
          text: text,
          timeSent: timeSent,
          messageId: messageId,
          receiverUserName: receiverUserData?.name,
          messageType: MessageEnum.text,
          isGroupChat: isGroupChat);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required recieverUserId,
    required UserModel userDataModel,
    required ProviderRef ref,
    required MessageEnum messageEnum,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();
      String imageUrl = await ref
          .read(commonFirebaseRepositoryProvider)
          .saveImageToFirebaseStorage(file,
              'chat/${messageEnum.type}/${userDataModel.uid}/$recieverUserId/$messageId');

      UserModel? recieverUserData;
      if (!isGroupChat) {
        var userDataMap =
            await fireStore.collection('users').doc(recieverUserId).get();
        recieverUserData = UserModel.fromMap(userDataMap.data()!);
      }

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
          contactMsg = ' GIF';
          break;
        default:
          contactMsg = ' GIF';
      }

      _saveDataToContactsCollection(
          senderUserData: userDataModel,
          receieverUserModel: recieverUserData,
          text: contactMsg,
          timesent: timeSent,
          recieverUserId: recieverUserId,
          isGroupChat: isGroupChat);
      _sendMessageToMessageSubCollection(
          messageReply: messageReply,
          receieverUserId: recieverUserId,
          senderUserName: userDataModel.name,
          text: imageUrl,
          timeSent: timeSent,
          messageId: messageId,
          receiverUserName: recieverUserData!.name,
          messageType: messageEnum,
          isGroupChat: isGroupChat);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendGIFMessage({
    required BuildContext context,
    required String gifUrl,
    required String recievedUserId,
    required UserModel senderUser,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel? receiverUserData;
      if (!isGroupChat) {
        var userDataMap =
            await fireStore.collection('users').doc(recievedUserId).get();
        receiverUserData = UserModel.fromMap(userDataMap.data()!);
      }

      _saveDataToContactsCollection(
          receieverUserModel: receiverUserData,
          recieverUserId: recievedUserId,
          senderUserData: senderUser,
          text: 'GIF',
          timesent: timeSent,
          isGroupChat: isGroupChat);
      var messageId = const Uuid().v1();
      _sendMessageToMessageSubCollection(
        messageReply: messageReply,
        receieverUserId: recievedUserId,
        senderUserName: senderUser.name,
        text: gifUrl,
        timeSent: timeSent,
        messageId: messageId,
        receiverUserName: receiverUserData!.name,
        messageType: MessageEnum.text,
        isGroupChat: isGroupChat,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void changeSeenStatus({
    required String recieverUserId,
    required String messageId,
    required BuildContext context,
  }) async {
    try {
      await fireStore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .collection('messages')
          .doc(messageId)
          .update({
        'isSeen': true,
      });

      await fireStore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .update({
        'isSeen': true,
      });
    } catch (e) {
      showSnackBar(context: context, content: 'You are offline');
    }
  }

  Stream<List<Group>> getChatGroups() {
    return fireStore.collection('groups').snapshots().asyncMap((event) {
      List<Group> groups = [];
      for (var document in event.docs) {
        var group = Group.fromMap(document.data());
        if (group.membersUid.contains(auth.currentUser!.uid)) {
          groups.add(group);
        }
      }
      return groups;
    });
  }

  Stream<List<Message>> getGroupChatStream(String groupId) {
    return fireStore
        .collection('groups')
        .doc(groupId)
        .collection('chats')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var doucument in event.docs) {
        messages.add(
          Message.fromMap(doucument.data()),
        );
      }
      return messages;
    });
  }
}
