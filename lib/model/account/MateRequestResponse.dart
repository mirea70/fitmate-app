class MateRequestResponse {
  final int mateId;
  final int? thumbnailImageId;
  final String title;
  final DateTime mateAt;
  final String fitPlace;
  final int permitPeopleCnt;
  final int approvedAccountCnt;
  final int totalFee;
  final DateTime applyAt;

  MateRequestResponse({
    required this.mateId,
    this.thumbnailImageId,
    required this.title,
    required this.mateAt,
    required this.fitPlace,
    required this.permitPeopleCnt,
    required this.approvedAccountCnt,
    required this.totalFee,
    required this.applyAt,
  });

  factory MateRequestResponse.fromJson(Map<String, dynamic> json) => MateRequestResponse(
    mateId: json['mateId'],
    thumbnailImageId: json['thumbnailImageId'],
    title: json['title'],
    mateAt: DateTime.parse(json['mateAt']),
    fitPlace: json['fitPlace'] ?? '',
    permitPeopleCnt: json['permitPeopleCnt'],
    approvedAccountCnt: json['approvedAccountCnt'],
    totalFee: json['totalFee'],
    applyAt: DateTime.parse(json['applyAt']),
  );
}
