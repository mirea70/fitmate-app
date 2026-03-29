class FollowDetail {
  final int accountId;
  final int? profileImageId;
  final String nickName;

  FollowDetail({
    required this.accountId,
    this.profileImageId,
    required this.nickName,
  });

  factory FollowDetail.fromJson(Map<String, dynamic> json) => FollowDetail(
    accountId: json['accountId'],
    profileImageId: json['profileImageId'],
    nickName: json['nickName'] ?? '',
  );
}
