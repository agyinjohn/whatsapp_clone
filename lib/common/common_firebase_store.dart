import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final commonFirebaseRepositoryProvider = Provider(
  (ref) => CommonFirebaseRepository(
    storage: FirebaseStorage.instance,
  ),
);

class CommonFirebaseRepository {
  final FirebaseStorage storage;

  CommonFirebaseRepository({required this.storage});

  Future<String> saveImageToFirebaseStorage(File file, String ref) async {
    UploadTask uploadTask = storage.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downLoadURL = await snapshot.ref.getDownloadURL();

    return downLoadURL;
  }
}
