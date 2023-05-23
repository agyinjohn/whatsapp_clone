import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/chat/widgets/contact_list.dart';
import 'package:whatsapp_clone/controller/auth_controller.dart';
import 'package:whatsapp_clone/screens/select_contacts_screen.dart';

import '../constants/colours.dart';
import '../group/screens/create_group_screen.dart';
import '../status/screens/confirm_status.dart';
import '../status/screens/screen_status.dart';
import '../utils/show_snackbar.dart';

class MobileDeviceScreen extends ConsumerStatefulWidget {
  const MobileDeviceScreen({super.key});

  @override
  ConsumerState<MobileDeviceScreen> createState() => _MobileDeviceScreenState();
}

class _MobileDeviceScreenState extends ConsumerState<MobileDeviceScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        ref.read(authControllerProvider).setUserState(true);
        break;
    }
  }

  late TabController tabBarController;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    tabBarController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          elevation: 0,
          title: const Text(
            'WhatsApp',
            style: TextStyle(fontSize: 30, color: Colors.grey),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.camera_alt, color: Colors.grey),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search, color: Colors.grey),
            ),
            PopupMenuButton(
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.grey,
                ),
                itemBuilder: (context) => [
                      PopupMenuItem(
                        child: const Text('Create Group'),
                        onTap: () => Future(
                          () => Navigator.pushNamed(
                              context, CreateGroupScreen.routeName),
                        ),
                      ),
                    ]),
          ],
          bottom: TabBar(controller: tabBarController, tabs: const [
            Tab(
              text: 'CHATS',
            ),
            Tab(
              text: 'STATUS',
            ),
            Tab(
              text: 'CALLS',
            )
          ]),
        ),
        body: TabBarView(
            controller: tabBarController,
            children: const [ChatContactList(), StatusScreen(), Text('Calls')]),
        floatingActionButton: FloatingActionButton(
          backgroundColor: tabColor,
          onPressed: () async {
            if (tabBarController.index == 0) {
              Navigator.pushNamed(context, SelectContactsScreen.routeName);
            } else {
              File? pickedImage = await pickImageFromGallery(context);
              if (pickedImage != null) {
                // ignore: use_build_context_synchronously
                Navigator.pushNamed(context, ConfirmStatusScreen.routeName,
                    arguments: pickedImage);
              }
            }
          },
          child: Icon(
            tabBarController.index == 0 ? Icons.comment : Icons.camera,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
