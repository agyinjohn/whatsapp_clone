import 'package:flutter/material.dart';
import 'package:whatsapp_clone/constants/colours.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/auth_controller.dart';

class OTPScreen extends ConsumerWidget {
  const OTPScreen({super.key, required this.verificationId});
  static const routeName = '/otp-screen';
  final String verificationId;

  void verifyingOTP(
      {required WidgetRef ref,
      required BuildContext context,
      required String userOTP}) {
    ref
        .read(authControllerProvider)
        .verifyOTP(context, verificationId, userOTP);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        title: const Text('Verifying your number'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text('We have sent an SMS with a code'),
            SizedBox(
              width: size.width * 0.50,
              child: TextField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: '-  -  -  -  -  -',
                  hintStyle: TextStyle(fontSize: 30),
                ),
                onChanged: (value) {
                  if (value.length == 6) {
                    verifyingOTP(
                        ref: ref, context: context, userOTP: value.trim());
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
