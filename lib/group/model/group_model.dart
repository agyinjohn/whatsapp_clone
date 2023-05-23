class Group {
  final String name;
  final DateTime timeSent;
  final String groupId;
  final String lastMessage;
  final String groupPic;
  final List<String> membersUid;
  final String senderId;
  Group({
    required this.name,
    required this.timeSent,
    required this.groupId,
    required this.lastMessage,
    required this.groupPic,
    required this.membersUid,
    required this.senderId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'groupId': groupId,
      'lastMessage': lastMessage,
      'groupPic': groupPic,
      'membersUid': membersUid,
      'senderId': senderId,
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      name: map['name'] ?? '',
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
      groupId: map['groupId'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      groupPic: map['groupPic'] ?? '',
      membersUid: List<String>.from(map['membersUid']),
      senderId: map['senderId'] ?? '',
    );
  }
}
