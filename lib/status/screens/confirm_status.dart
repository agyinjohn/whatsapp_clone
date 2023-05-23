import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/constants/colours.dart';

import '../controllers/status_controller.dart';

class ConfirmStatusScreen extends ConsumerWidget {
  static const routeName = '/confirm-status-screen';

  final File file;
  const ConfirmStatusScreen({
    super.key,
    required this.file,
  });
  void addStatus(WidgetRef ref, BuildContext context) {
    ref.read(statusRepositoryControllerProvider).addStatus(file, context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: 9 / 16,
          child: Image.file(file),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: tabColor,
          onPressed: () => addStatus(ref, context),
          child: const Icon(Icons.done, color: Colors.white)),
    );
  }
}
