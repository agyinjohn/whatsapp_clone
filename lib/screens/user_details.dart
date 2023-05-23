import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whatsapp_clone/utils/show_snackbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/auth_controller.dart';

class UserDetails extends ConsumerStatefulWidget {
  const UserDetails({super.key});
  static const routeName = '/user-details';

  @override
  ConsumerState<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends ConsumerState<UserDetails> {
  File? image;

  void pickImage() async {
    image = await pickImageFromGallery(context);

    setState(() {});
  }

  TextEditingController nameController = TextEditingController();
  void saveUserDataToFirebase() {
    String name = nameController.text.trim();
    if (name.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .saveUserDataToFirebaseFirestor(context, image, name);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Stack(
              children: [
                image != null
                    ? CircleAvatar(
                        backgroundImage: FileImage(image!),
                        radius: 64,
                      )
                    : const CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                            "https://th.bing.com/th/id/R.83ab137467dbc8dd837df78506cceaa9?rik=lzJhBTLH5sZDJQ&pid=ImgRaw&r=0"),
                      ),
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                      onPressed: pickImage,
                      icon: const Icon(
                        Icons.add_a_photo,
                        color: Colors.grey,
                      )),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  width: size.width * 0.85,
                  child: Column(
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your name',
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: saveUserDataToFirebase,
                  icon: const Icon(Icons.done),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
