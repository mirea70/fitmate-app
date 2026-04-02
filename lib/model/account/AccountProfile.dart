class AccountProfile {
  final int accountId;
  final String loginName;
  final String nickName;
  final String introduction;
  final int? profileImageId;
  final String name;
  final String phone;
  final String email;
  final String? birthDate;
  final String role;
  final String gender;
  final List<int> followings;
  final List<int> followers;

  AccountProfile({
    required this.accountId,
    required this.loginName,
    required this.nickName,
    required this.introduction,
    this.profileImageId,
    required this.name,
    required this.phone,
    required this.email,
    this.birthDate,
    required this.role,
    required this.gender,
    required this.followings,
    required this.followers,
  });

  factory AccountProfile.fromJson(Map<String, dynamic> json) => AccountProfile(
    accountId: json['accountId'],
    loginName: json['loginName'],
    nickName: json['nickName'],
    introduction: json['introduction'] ?? '',
    profileImageId: json['profileImageId'],
    name: json['name'],
    phone: json['phone'],
    email: json['email'],
    birthDate: json['birthDate'],
    role: json['role'],
    gender: json['gender'],
    followings: json['followings'] != null ? List<int>.from(json['followings']) : [],
    followers: json['followers'] != null ? List<int>.from(json['followers']) : [],
  );
}
