class UserModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String postName;
  final String birthDate;
  final String phoneNumber;
  final String email;
  final String? avatar;
  final DateTime createdAt;
  final DateTime? lastActive;

  UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.postName,
    required this.birthDate,
    required this.phoneNumber,
    required this.email,
    this.avatar,
    required this.createdAt,
    this.lastActive,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'postName': postName,
      'birthDate': birthDate,
      'phoneNumber': phoneNumber,
      'email': email,
      'avatar': avatar,
      'createdAt': createdAt.toIso8601String(),
      'lastActive': lastActive?.toIso8601String(),
    };
  }

  // Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      postName: json['postName'] ?? '',
      birthDate: json['birthDate'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      lastActive: json['lastActive'] != null
          ? DateTime.parse(json['lastActive'])
          : null,
    );
  }

  // Get full name
  String get fullName => '$firstName $lastName';
}
