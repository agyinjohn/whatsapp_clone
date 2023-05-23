import 'package:flutter/material.dart';
import 'package:whatsapp_clone/constants/colours.dart';
import 'mobile_screen_home.dart';
import './web_screen.dart';

class MobileScreen extends StatelessWidget {
  const MobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, BoxConstraints contraint) {
      if (contraint.maxWidth > screenSize) {
        return const WebScreen();
      }
      return const MobileDeviceScreen();
    });
  }
}
