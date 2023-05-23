import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../common/common_firebase_store.dart';
import '../model/group_model.dart' as model;
import '../../utils/show_snackbar.dart';

final groupRepositoryProvider = Provider((ref) => GroupRepository(
    firebaseFirestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref));

class GroupRepository {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth auth;
  final ProviderRef ref;
  GroupRepository(
      {required this.firebaseFirestore, required this.auth, required this.ref});
  void createGroup(BuildContext context, String name, File profilePic,
      List<Contact> selectedContacts) async {
    try {
      List<String> uids = [];
      for (int i = 0; i < selectedContacts.length; i++) {
        var userCollection = await firebaseFirestore
            .collection('users')
            .where(
              'phoneNumber',
              isEqualTo: selectedContacts[i].phones[0].number.replaceAll(
                    ' ',
                    '',
                  ),
            )
            .get();
        if (userCollection.docs.isNotEmpty && userCollection.docs[0].exists) {
          uids.add(userCollection.docs[0].data()['uid']);
        }
      }

      var groupId = const Uuid().v1();
      String profileUrl = await ref
          .read(commonFirebaseRepositoryProvider)
          .saveImageToFirebaseStorage(profilePic, 'group/$groupId');
      model.Group group = model.Group(
          timeSent: DateTime.now(),
          name: name,
          groupId: groupId,
          lastMessage: '',
          groupPic: profileUrl,
          membersUid: [auth.currentUser!.uid, ...uids],
          senderId: auth.currentUser!.uid);
      await firebaseFirestore
          .collection('groups')
          .doc(groupId)
          .set(group.toMap());
    } catch (e) {
      showSnackBar(content: e.toString(), context: context);
    }
  }
}
