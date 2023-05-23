import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp_clone/common/providers/message_reply_provider.dart';

import 'package:whatsapp_clone/constants/colours.dart';

import '../../utils/enums/message_enum.dart';
import '../../utils/show_snackbar.dart';
import '../controllers/chat_controller.dart';
import 'message_reply_preview.dart';

class BottomChatField extends ConsumerStatefulWidget {
  const BottomChatField({
    super.key,
    required this.isGroupChat,
    required this.recieverUserId,
  });
  final String recieverUserId;
  final bool isGroupChat;
  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  FocusNode focusNode = FocusNode();
  final TextEditingController messageController = TextEditingController();
  FlutterSoundRecorder? _soundRecorder;
  bool isEmpty = true;
  bool isRecordInit = false;
  bool isRecording = false;
  @override
  void initState() {
    super.initState();
    _soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic permission not allowed');
    }
    await _soundRecorder!.openRecorder();
    isRecordInit = true;
  }

  void selectGIF() async {
    final gif = await pickGIF(context);
    if (gif != null) {
      // ignore: use_build_context_synchronously
      ref.read(chatControllerProvider).sendGIFMessage(
          context, widget.recieverUserId, gif.url, widget.isGroupChat);
    }
  }

  bool isShowEmojiContainer = false;
  void sendTextMessage() async {
    if (!isEmpty) {
      ref.read(chatControllerProvider).sendTextMessage(
          context,
          messageController.text.trim(),
          widget.recieverUserId,
          MessageEnum.text,
          widget.isGroupChat);
      setState(() {
        messageController.text = '';
      });
    } else {
      var tempDir = await getTemporaryDirectory();
      var path = '${tempDir.path}/flutter_sound.aac';
      if (!isRecordInit) {
        return;
      }
      if (isRecording) {
        await _soundRecorder!.stopRecorder();
        sendFileMessage(File(path), MessageEnum.audio);
      } else {
        await _soundRecorder!.startRecorder(
          toFile: path,
        );
      }
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void hideEmojiContainer() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showEmojiContainer() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void toggleEmojiContainer() {
    if (isShowEmojiContainer) {
      showKeyboard();
      hideEmojiContainer();
    } else {
      hideKeyboard();
      showEmojiContainer();
    }
  }

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus();
  void sendFileMessage(File file, MessageEnum messageEnum) {
    ref.read(chatControllerProvider).sendFileMessage(
        context: context,
        recieverUid: widget.recieverUserId,
        file: file,
        messageEnum: messageEnum,
        isGroupChat: widget.isGroupChat);
  }

  void selectImge() async {
    File? file = await pickImageFromGallery(context);
    if (file != null) {
      sendFileMessage(file, MessageEnum.image);
    }
  }

  void selectVideo() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFileMessage(video, MessageEnum.video);
    }
  }

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
    _soundRecorder!.closeRecorder();
    isRecordInit = false;
  }

  @override
  Widget build(BuildContext context) {
    final messageReply = ref.watch(messageReplyProvider);
    final isShowMessageReply = messageReply != null;
    return Column(
      children: [
        isShowMessageReply ? const MessageReplyPreview() : const SizedBox(),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                minLines: 1,
                focusNode: focusNode,
                controller: messageController,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      isEmpty = false;
                    });
                  } else {
                    setState(() {
                      isEmpty = true;
                    });
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: mobileChatBoxColor,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
                      width: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: toggleEmojiContainer,
                            icon: const Icon(
                              Icons.emoji_emotions,
                              color: Colors.grey,
                            ),
                          ),
                          // IconButton(
                          //   onPressed: selectGIF,
                          //   icon: const Icon(
                          //     Icons.gif,
                          //     color: Colors.grey,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  suffixIcon: SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: selectImge,
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                          ),
                        ),
                        IconButton(
                          onPressed: selectVideo,
                          icon: const Icon(
                            Icons.attach_file,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  hintText: 'Type a message',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide:
                        const BorderSide(width: 0, style: BorderStyle.none),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, right: 2, left: 2),
              child: CircleAvatar(
                backgroundColor: const Color(0xFF128C7E),
                child: GestureDetector(
                  onTap: sendTextMessage,
                  child: Icon(
                    !isEmpty
                        ? Icons.send
                        : isRecording
                            ? Icons.close
                            : Icons.mic,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
        !isShowEmojiContainer
            ? const SizedBox()
            : SizedBox(
                height: 310,
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    setState(() {
                      messageController.text =
                          messageController.text + emoji.emoji;
                    });
                    if (isEmpty) {
                      setState(() {
                        isEmpty = false;
                      });
                    }
                  },
                ),
              ),
      ],
    );
  }
}
