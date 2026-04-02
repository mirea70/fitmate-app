class NoticeResponse {
  final int id;
  final int? matingId;
  final int? senderAccountId;
  final String content;
  final String noticeType;
  final DateTime createdAt;

  NoticeResponse({
    required this.id,
    this.matingId,
    this.senderAccountId,
    required this.content,
    required this.noticeType,
    required this.createdAt,
  });

  factory NoticeResponse.fromJson(Map<String, dynamic> json) => NoticeResponse(
    id: json['id'],
    matingId: json['matingId'],
    senderAccountId: json['senderAccountId'],
    content: json['content'],
    noticeType: json['noticeType'] ?? '',
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : DateTime.now(),
  );
}
