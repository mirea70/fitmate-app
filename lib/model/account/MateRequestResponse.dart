class MateRequestResponse {
  final int mateId;
  final int? thumbnailImageId;
  final String title;
  final DateTime mateAt;
  final String fitPlaceName;
  final String fitPlaceAddress;
  final int permitPeopleCnt;
  final int approvedAccountCnt;
  final int totalFee;
  final DateTime applyAt;

  MateRequestResponse({
    required this.mateId,
    this.thumbnailImageId,
    required this.title,
    required this.mateAt,
    required this.fitPlaceName,
    required this.fitPlaceAddress,
    required this.permitPeopleCnt,
    required this.approvedAccountCnt,
    required this.totalFee,
    required this.applyAt,
  });

  factory MateRequestResponse.fromJson(Map<String, dynamic> json) {
    final fitPlace = json['fitPlace'];
    String name = '';
    String address = '';
    if (fitPlace is Map<String, dynamic>) {
      name = fitPlace['name'] ?? '';
      address = fitPlace['address'] ?? '';
    } else if (fitPlace is String) {
      name = fitPlace;
    }

    return MateRequestResponse(
      mateId: json['mateId'],
      thumbnailImageId: (json['thumbnailImageId'] != null && json['thumbnailImageId'] != 0)
          ? json['thumbnailImageId']
          : null,
      title: json['title'],
      mateAt: DateTime.parse(json['mateAt']),
      fitPlaceName: name,
      fitPlaceAddress: address,
      permitPeopleCnt: json['permitPeopleCnt'],
      approvedAccountCnt: json['approvedAccountCnt'],
      totalFee: json['totalFee'],
      applyAt: DateTime.parse(json['applyAt']),
    );
  }
}
