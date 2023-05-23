import 'dart:io';

import 'package:flutter/material.dart';

import '../group/screens/create_group_screen.dart';
import '../screens/login_screen.dart';
import '../chat/screens/mobile_chat_screen.dart';
import '../screens/otp_screen.dart';
import '../screens/select_contacts_screen.dart';
import '../screens/user_details.dart';
import '../status/screens/confirm_status.dart';
import '../status/screens/single_status_screen.dart';
import '../status/status_model.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case MobileChatScreen.routeName:
      final argument = settings.arguments as Map<String, dynamic>;
      final name = argument['name'];
      final uid = argument['uid'];
      final isGroupChat = argument['isGroupChat'];
      return MaterialPageRoute(
        builder: (context) => MobileChatScreen(
          name: name,
          uid: uid,
          isGroupChat: isGroupChat,
        ),
      );
    case SelectContactsScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SelectContactsScreen(),
      );
    case SingleStatusScreen.routeName:
      final status = settings.arguments as Status;
      return MaterialPageRoute(
        builder: (context) => SingleStatusScreen(status: status),
      );
    case OTPScreen.routeName:
      final String verificationId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => OTPScreen(verificationId: verificationId),
      );
    case UserDetails.routeName:
      return MaterialPageRoute(
        builder: (context) => const UserDetails(),
      );
    case ConfirmStatusScreen.routeName:
      final file = settings.arguments as File;
      return MaterialPageRoute(
        builder: (context) => ConfirmStatusScreen(file: file),
      );
    case CreateGroupScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const CreateGroupScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(
              child: Text('This page does not exist or an error occured')),
        ),
      );
  }
}
