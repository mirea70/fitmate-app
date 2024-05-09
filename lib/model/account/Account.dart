import 'dart:convert';

Account accountFromJson(String str) => Account.fromJson(json.decode(str));

String accountToJson(Account data) => json.encode(data.toJson());

class Account {
  final String loginName;
  final String password;
  final String nickName;
  final String introduction;
  final String name;
  final String phone;
  final String email;
  final String role;
  final String gender;
  final int? profileImageId;

  Account({
    required this.loginName,
    required this.password,
    required this.nickName,
    required this.introduction,
    required this.name,
    required this.phone,
    required this.email,
    required this.role,
    required this.gender,
    required this.profileImageId,
  });

  factory Account.initial() {
    return Account(
      loginName: '',
      password: '',
      nickName: '',
      introduction: '',
      name: '',
      phone: '',
      email: '',
      role: 'USER',
      gender: '',
      profileImageId: null,
    );
  }

  Account copyWith({
    String? loginName,
    String? password,
    String? nickName,
    String? introduction,
    String? name,
    String? phone,
    String? email,
    String? role,
    String? gender,
    int? profileImageId,
  }) =>
      Account(
        loginName: loginName ?? this.loginName,
        password: password ?? this.password,
        nickName: nickName ?? this.nickName,
        introduction: introduction ?? this.introduction,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        role: role ?? this.role,
        gender: gender ?? this.gender,
        profileImageId: profileImageId ?? this.profileImageId,
      );

  factory Account.fromJson(Map<String, dynamic> json) => Account(
    loginName: json["loginName"],
    password: json["password"],
    nickName: json["nickName"],
    introduction: json["introduction"],
    name: json["name"],
    phone: json["phone"],
    email: json["email"],
    role: json["role"],
    gender: json["gender"],
    profileImageId: json["profileImageId"],
  );

  Map<String, dynamic> toJson() => {
    "loginName": loginName,
    "password": password,
    "nickName": nickName,
    "introduction": introduction,
    "name": name,
    "phone": phone,
    "email": email,
    "role": role,
    "gender": gender,
    "profileImageId": profileImageId,
  };
}