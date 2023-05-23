import 'package:flutter/material.dart';
import 'package:whatsapp_clone/screens/login_screen.dart';

import '../constants/colours.dart';
import '../utils/custom_button.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});
  void navigateToLoginScreen(BuildContext context) {
    Navigator.of(context).pushNamed(LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
          child: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(
            height: 40,
          ),
          const Text(
            "Welcome to WhatsApp",
            style: TextStyle(
                fontSize: 33, fontWeight: FontWeight.w600, color: textColor),
          ),
          SizedBox(
            height: size.height / 12,
          ),
          Image.asset(
            'assets/bg.png',
            width: 280,
            height: 250,
            color: tabColor,
          ),
          SizedBox(height: size.height / 12),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Read our Privacy and Policy. Tap "Agree and continue" to accept the Terms of  Service',
              textAlign: TextAlign.center,
              style: TextStyle(color: greyColor),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: CustomButton(
              onPressed: () => navigateToLoginScreen(context),
              text: "AGREE AND CONTINUE",
            ),
          )
        ]),
      )),
    );
  }
}
