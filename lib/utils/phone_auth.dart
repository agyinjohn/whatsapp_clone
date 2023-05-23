import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/model/user_model.dart';
import 'package:whatsapp_clone/utils/show_snackbar.dart';

import '../screens/mobile_screen.dart';
import '../screens/otp_screen.dart';
import '../screens/user_details.dart';
import 'package:whatsapp_clone/common/common_firebase_store.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthenticationRepository(
      auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance),
);

class AuthenticationRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthenticationRepository({required this.auth, required this.firestore});

  // void signInWithPhoneNumber(BuildContext context, String phoneNumber) async {
  //   try {
  //     // if (kIsWeb) {
  //     //   await auth.signInWithPhoneNumber(phoneNumber);
  //     // }
  //     await auth.verifyPhoneNumber(
  //         phoneNumber: phoneNumber,
  //         verificationCompleted:
  //             (PhoneAuthCredential phoneAuthCredential) async {
  //           await auth.signInWithCredential(phoneAuthCredential);
  //         },
  //         verificationFailed: (FirebaseAuthException e) =>
  //             showSnackBar(content: e.message!, context: context),
  //         // throw Exception(e.message);

  //         codeSent: (String verificationId, int? forceResendingToken) async {
  //           Navigator.pushNamed(context, OTPScreen.routeName,
  //               arguments: verificationId);
  //         },
  //         timeout: const Duration(seconds: 120),
  //         codeAutoRetrievalTimeout: (String verificationId) {});
  //   } on FirebaseAuthException catch (e) {
  //     showSnackBar(content: e.message!, context: context);
  //   }
  // }
  Future<UserModel?> getUserDetails() async {
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();
    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (e) {
          throw Exception(e.message);
        },
        codeSent: ((String verificationId, int? resendToken) async {
          Navigator.pushNamed(
            context,
            OTPScreen.routeName,
            arguments: verificationId,
          );
        }),
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void verifyOTP(
      {required BuildContext context,
      required String verificationId,
      required userOTP}) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOTP);
      await auth.signInWithCredential(credential);
      // ignore: use_build_context_synchronously
      await Navigator.pushNamedAndRemoveUntil(
          context, UserDetails.routeName, (route) => false);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void saveUserDataToFirebase({
    required BuildContext context,
    required File? profilePic,
    required String name,
    required ProviderRef ref,
  }) async {
    var navigator = Navigator.of(context);
    try {
      String uid = auth.currentUser!.uid;
      String profilePhoto =
          "https://th.bing.com/th/id/R.83ab137467dbc8dd837df78506cceaa9?rik=lzJhBTLH5sZDJQ&pid=ImgRaw&r=0";
      if (profilePic != null) {
        profilePhoto = await ref
            .read(commonFirebaseRepositoryProvider)
            .saveImageToFirebaseStorage(profilePic, 'profilePic/$uid');
      }
      var user = UserModel(
          phoneNumber: auth.currentUser!.phoneNumber!,
          groupId: [],
          name: name,
          profilePic: profilePhoto,
          uid: uid,
          isOnline: true);
      await firestore.collection('users').doc(uid).set(user.toJson());
      navigator.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const MobileScreen(),
          ),
          (route) => false);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Stream<UserModel> userData(String userId) {
    return firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((event) => UserModel.fromMap(event.data()!));
  }

  void setUserState(bool isOnline) async {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update({'isOnline': isOnline});
  }
}
