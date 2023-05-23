import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/common/common_firebase_store.dart';
import 'package:whatsapp_clone/model/user_model.dart';
import 'package:whatsapp_clone/utils/show_snackbar.dart';

import '../status_model.dart';

final statusRepositoryProvider = Provider((ref) => StatusRepository(
    auth: FirebaseAuth.instance,
    firebaseFirestore: FirebaseFirestore.instance,
    ref: ref));

class StatusRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firebaseFirestore;
  final ProviderRef ref;
  StatusRepository({
    required this.auth,
    required this.firebaseFirestore,
    required this.ref,
  });

  void uploadStatus(
      {required String username,
      required String profilePic,
      required BuildContext context,
      required String phoneNumber,
      required File statusImage}) async {
    try {
      var statusId = const Uuid().v1();
      String uid = auth.currentUser!.uid;
      final imageUrl = await ref
          .read(commonFirebaseRepositoryProvider)
          .saveImageToFirebaseStorage(statusImage, '/status/$statusId$uid');
      List<String> uidWhoCan = [];
      List<Contact> contacts = [];

      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);

        for (int i = 0; i < contacts.length; i++) {
          var userDataFromFireStore = await firebaseFirestore
              .collection('users')
              .where('phoneNumber',
                  isEqualTo: contacts[i].phones[0].number.replaceAll(' ', ''))
              .get();

          if (userDataFromFireStore.docs.isNotEmpty) {
            var userData =
                UserModel.fromMap(userDataFromFireStore.docs[0].data());
            uidWhoCan.add(userData.uid);
          }
        }
      }
      List<String> statusImageUrls = [];
      var statusSnapShot = await firebaseFirestore
          .collection('status')
          .where('uid', isEqualTo: auth.currentUser!.uid)
          .get();
      if (statusSnapShot.docs.isNotEmpty) {
        Status status = Status.fromMap(statusSnapShot.docs[0].data());
        statusImageUrls = status.photoUrl;
        statusImageUrls.add(imageUrl);
        await firebaseFirestore
            .collection('status')
            .doc(statusSnapShot.docs[0].id)
            .update({
          'photoUrl': statusImageUrls,
        });
        return;
      } else {
        statusImageUrls = [imageUrl];
      }
      Status status = Status(
          uid: uid,
          username: username,
          phoneNumber: phoneNumber,
          createdAt: DateTime.now(),
          profilePic: profilePic,
          photoUrl: statusImageUrls,
          statusId: statusId,
          whoCanSee: uidWhoCan);
      await firebaseFirestore
          .collection('status')
          .doc(statusId)
          .set(status.toMap());
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Future<List<Status>> getStatus(BuildContext context) async {
    List<Status> statusData = [];

    try {
      List<Contact> contacts = [];

      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
      for (int i = 0; i < contacts.length; i++) {
        var statusSnapShot = await firebaseFirestore
            .collection('status')
            .where(
              'phoneNumber',
              isEqualTo: contacts[i].phones[0].number.replaceAll(
                    ' ',
                    '',
                  ),
            ).get();
            // .where('createdAt',
            //     isGreaterThan: DateTime.now()
            //         .subtract(const Duration(hours: 24))
            //         .millisecondsSinceEpoch)
            // .get();

        for (var tempData in statusSnapShot.docs) {
          Status tempStatus = Status.fromMap(tempData.data());
          if (tempStatus.whoCanSee.contains(auth.currentUser!.uid)) {
            statusData.add(tempStatus);
          }
        }
      }
    } catch (e) {
      print(e.toString());
      showSnackBar(context: context, content: 'error');
    }
    return statusData;
  }
}
