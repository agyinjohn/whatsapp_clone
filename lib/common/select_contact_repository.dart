import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/model/user_model.dart';
import 'package:whatsapp_clone/utils/show_snackbar.dart';

import '../chat/screens/mobile_chat_screen.dart';

final selectContactsRepositoryProvider = Provider(
  (ref) => SelectContactRepository(firestore: FirebaseFirestore.instance),
);

class SelectContactRepository {
  final FirebaseFirestore firestore;
  SelectContactRepository({
    required this.firestore,
  });

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  void selectContact(BuildContext context, Contact contact) async {
    try {
      var userCollecton = await firestore.collection('users').get();
      bool isFound = false;
      for (var document in userCollecton.docs) {
        var userData = UserModel.fromMap(document.data());
        String selectedNum = contact.phones[0].number.replaceAll(' ', '');
        if (selectedNum == userData.phoneNumber) {
          isFound = true;
          // ignore: use_build_context_synchronously
          Navigator.pushNamed(context, MobileChatScreen.routeName, arguments: {
            'name': userData.name,
            'uid': userData.uid,
          });
        }
      }
      if (!isFound) {
        // ignore: use_build_context_synchronously
        showSnackBar(
            context: context,
            content: 'This Number does not exist on this app');
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
