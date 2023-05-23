class UserModel {
  final String name;
  final String profilePic;
  final String uid;
  final bool isOnline;
  final String phoneNumber;
  final List<String> groupId;

  UserModel({
    required this.phoneNumber,
    required this.groupId,
    required this.name,
    required this.profilePic,
    required this.uid,
    required this.isOnline,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'profilePic': profilePic,
        'uid': uid,
        'isOnline': isOnline,
        'phoneNumber': phoneNumber,
        'groupId': groupId,
      };
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      phoneNumber: map['phoneNumber'] ?? '',
      groupId: List<String>.from(map['groupId']),
      name: map['name'] ?? '',
      profilePic: map['profilePic'] ?? '',
      uid: map['uid'] ?? '',
      isOnline: map['isOnline'] ?? false,
    );
  }
}
