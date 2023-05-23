import 'package:flutter/material.dart';
import 'package:whatsapp_clone/constants/colours.dart';
import 'package:country_picker/country_picker.dart';
import '../controller/auth_controller.dart';
import '../utils/custom_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/show_snackbar.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  static const routeName = '/loginscreen';
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  TextEditingController phoneNumberController = TextEditingController();
  Country? _country;
  void pickCountry() {
    showCountryPicker(
        context: context,
        onSelect: (Country country) {
          setState(() {
            _country = country;
          });
        });
  }

  void sendPhoneNuber() {
    String phoneNumber = phoneNumberController.text.trim();
    if (_country != null && phoneNumber.isNotEmpty) {
      ref.read(authControllerProvider).signInWithPhoneNumber(
          context, '+${_country!.phoneCode}$phoneNumber');
    } else {
      showSnackBar(content: "Fill out all the fields", context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        title: const Text('Enter your phone number'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('WhatsApp will need to verify your phone number'),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: pickCountry,
                child: const Text('Pick your country'),
              ),
              Row(
                children: [
                  if (_country != null) Text("+${_country!.phoneCode}"),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: size.width * 0.70,
                    child: TextField(
                      controller: phoneNumberController,
                      decoration:
                          const InputDecoration(hintText: 'phone number'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: size.height * 0.45,
          ),
          SizedBox(
            width: 90,
            child: CustomButton(
              onPressed: sendPhoneNuber,
              text: 'NEXT',
            ),
          ),
        ]),
      ),
    );
  }
}
