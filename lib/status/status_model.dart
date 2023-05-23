class Status {
  final String uid;
  final String username;
  final String phoneNumber;
  final DateTime createdAt;
  final String profilePic;
  final List<String> photoUrl;
  final String statusId;
  final List<String> whoCanSee;
  Status({
    required this.uid,
    required this.username,
    required this.phoneNumber,
    required this.createdAt,
    required this.profilePic,
    required this.photoUrl,
    required this.statusId,
    required this.whoCanSee,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'profilePic': profilePic,
      'photoUrl': photoUrl,
      'statusId': statusId,
      'whoCanSee': whoCanSee,
    };
  }

  factory Status.fromMap(Map<String, dynamic> map) {
    return Status(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      profilePic: map['profilePic'] ?? '',
      photoUrl: List<String>.from(map['photoUrl']),
      statusId: map['statusId'] ?? '',
      whoCanSee: List<String>.from(map['whoCanSee']),
    );
  }
}
