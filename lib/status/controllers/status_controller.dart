import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/controller/auth_controller.dart';

import '../repositories/status_repository.dart';
import '../status_model.dart';

final statusRepositoryControllerProvider = Provider((ref) {
  final statusRepository = ref.read(statusRepositoryProvider);
  return StatusRepositoryController(
      statusRepository: statusRepository, ref: ref);
});

class StatusRepositoryController {
  final StatusRepository statusRepository;
  final ProviderRef ref;
  StatusRepositoryController({
    required this.statusRepository,
    required this.ref,
  });

  void addStatus(File file, BuildContext context) {
    ref.watch(userDataProvider).whenData((value) =>
        statusRepository.uploadStatus(
            username: value!.name,
            profilePic: value.profilePic,
            context: context,
            phoneNumber: value.phoneNumber,
            statusImage: file));
  }

  Future<List<Status>> getStatus(BuildContext context) async {
    List<Status> statuses = await statusRepository.getStatus(context);
    return statuses;
  }
}
