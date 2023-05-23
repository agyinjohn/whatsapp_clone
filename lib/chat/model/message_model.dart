import '../../utils/enums/message_enum.dart';

class Message {
  final String senderId;
  final String recieverId;
  final String text;
  final String messageId;
  final MessageEnum type;
  final DateTime timeSent;
  final bool isSeen;
  final String repliedMessage;
  final String replyTo;
  final MessageEnum repliedMessageTpye;
  Message({
    required this.senderId,
    required this.recieverId,
    required this.text,
    required this.messageId,
    required this.type,
    required this.timeSent,
    required this.isSeen,
    required this.repliedMessage,
    required this.replyTo,
    required this.repliedMessageTpye,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'recieverId': recieverId,
      'text': text,
      'messageId': messageId,
      'type': type.type,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'isSeen': isSeen,
      'repliedMessage': repliedMessage,
      'replyTo': replyTo,
      'repliedMessageTpye': repliedMessageTpye.type,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'] ?? '',
      recieverId: map['recieverId'] ?? '',
      text: map['text'] ?? '',
      messageId: map['messageId'] ?? '',
      type: (map['type'] as String).toEnum(),
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
      isSeen: map['isSeen'] ?? false,
      repliedMessage: map['repliedMessage'] ?? '',
      replyTo: map['replyTo'] ?? '',
      repliedMessageTpye: (map['repliedMessageTpye'] as String).toEnum(),
    );
  }
}
