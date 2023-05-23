import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/show_snackbar.dart';
import '../controller/group_controller.dart';
import '../widgets/select_contacts.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  const CreateGroupScreen({super.key});
  static const String routeName = 'create-group-screen';
  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  File? image;
  TextEditingController groupNamecontroller = TextEditingController();
  void pickImage() async {
    image = await pickImageFromGallery(context);

    setState(() {});
  }

  void createGroup() {
    if (groupNamecontroller.text.trim().isNotEmpty && image != null) {
      ref.read(groupControllerProvider).createGroup(
          context,
          groupNamecontroller.text.trim(),
          image!,
          ref.read(selectedGroupContacts));
      ref.read(selectedGroupContacts.notifier).update((state) => []);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    groupNamecontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Group'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 5,
          ),
          Stack(
            children: [
              image != null
                  ? CircleAvatar(
                      backgroundImage: FileImage(image!),
                      radius: 64,
                    )
                  : const CircleAvatar(
                      radius: 64,
                      backgroundImage: AssetImage('assets/profile.png'),
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
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: groupNamecontroller,
              decoration: const InputDecoration(hintText: 'Enter Group Name'),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(8),
            child: const Text(
              'Select contacts',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SelectContactGroup(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createGroup,
        child: const Icon(
          Icons.done,
          color: Colors.white,
        ),
      ),
    );
  }
}
