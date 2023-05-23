import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/screens/loading_screen.dart';
import 'package:whatsapp_clone/status/controllers/status_controller.dart';
import 'package:whatsapp_clone/status/screens/single_status_screen.dart';
import 'package:whatsapp_clone/status/status_model.dart';

import '../../constants/colours.dart';
import '../../utils/show_snackbar.dart';
import 'confirm_status.dart';

class StatusScreen extends ConsumerWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<Status>>(
        future: ref.read(statusRepositoryControllerProvider).getStatus(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          return Scaffold(
            body: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var statusData = snapshot.data![index];
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, SingleStatusScreen.routeName,
                              arguments: statusData);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: ListTile(
                            title: Text(
                              statusData.username,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                statusData.profilePic,
                              ),
                              radius: 25,
                            ),
                            trailing: Text(
                              DateFormat.Hm().format(statusData.createdAt),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Divider(
                        color: dividerColor,
                        indent: 15,
                      )
                    ],
                  );
                }),
            floatingActionButton: FloatingActionButton(
              backgroundColor: tabColor,
              onPressed: () async {
                File? pickedImage = await pickImageFromGallery(context);
                if (pickedImage != null) {
                  // ignore: use_build_context_synchronously
                  Navigator.pushNamed(context, ConfirmStatusScreen.routeName,
                      arguments: pickedImage);
                }
              },
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
              ),
            ),
          );
        });
  }
}
