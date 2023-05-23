import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/utils/phone_auth.dart';

import '../model/user_model.dart';

final authControllerProvider = Provider(
  (ref) {
    final authrespository = ref.watch(authRepositoryProvider);
    return AuthController(authentication: authrespository, ref: ref);
  },
);
final userDataProvider = FutureProvider((ref) {
  final authController = ref.watch(authRepositoryProvider);
  return authController.getUserDetails();
});

class AuthController {
  final AuthenticationRepository authentication;
  final ProviderRef ref;

  AuthController({required this.authentication, required this.ref});

  void signInWithPhoneNumber(BuildContext context, String phoneNumber) {
    authentication.signInWithPhone(context, phoneNumber);
  }

  void setUserState(bool isOnline) {
    authentication.setUserState(isOnline);
  }

  void verifyOTP(BuildContext context, String verificationId, String userOTP) {
    authentication.verifyOTP(
        context: context, verificationId: verificationId, userOTP: userOTP);
  }

  void saveUserDataToFirebaseFirestor(
      BuildContext context, File? profilePic, String name) {
    authentication.saveUserDataToFirebase(
        context: context, profilePic: profilePic, name: name, ref: ref);
  }

  Future<UserModel?> getUserDetails() async {
    UserModel? user = await authentication.getUserDetails();
    return user;
  }

  Stream<UserModel> getUserDataById(String userId) {
    return authentication.userData(userId);
  }
}
